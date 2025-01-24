const express = require('express');
const app = express();
const cors = require('cors');
const Stripe = require("stripe");
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const stripeRouter = require("./routes/stripe");
const bodyParser = require('body-parser');
const Order = require('./models/Orders');
const User = require('./models/User');
const Food = require('./models/Food');
const Restaurant = require('./models/Restaurant');
const admin = require("firebase-admin");
const { updateRestaurant } = require('./utils/driver_update');
const { fireBaseConnection } = require('./utils/fbConnect');
const sendNotification = require('./utils/sendNotifications');

dotenv.config();

fireBaseConnection();
const stripe = Stripe(process.env.STRIPE_SECRET);
mongoose.connect(process.env.MONGO_URL)
  .then(() => console.log("DB connected"))
  .catch((err) => console.log(err));

// CORS Configuration
const corsOptions = {
  origin: ['https://eatseasy-partner.web.app',
             'https://eatseasyfoods.web.app',
             'https://partner.eatseasy.online',
             'https://foods.eatseasy.online'], // Allow specific origins or all
  methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'], // Allowed headers
  credentials: true, // Include credentials (e.g., cookies) if needed
};

// Apply CORS middleware
app.use(cors(corsOptions));

const endpointSecret = "whsec_ehjK3AgF2xip3iDyRxHS2xqXOyNjmDMB";

app.post('/webhook', express.raw({ type: 'application/json' }), async (request, response) => {
  const sig = request.headers['stripe-signature'];

  let event;

  try {
    event = stripe.webhooks.constructEvent(request.body, sig, endpointSecret);
  } catch (err) {
    response.status(400).send(`Webhook Error: ${err.message}`);
    return;
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      paymentIntentSucceeded = event.data.object;
      break;

    case 'checkout.session.completed':
      const checkoutData = event.data.object;
      console.log("Session Completed");

      try {
        const customer = await stripe.customers.retrieve(checkoutData.customer);
        const data = JSON.parse(customer.metadata.cart);

        const products = data.map((item) => ({
          name: item.name,
          id: item.id,
          price: item.price,
          quantity: item.quantity,
          restaurantId: item.restaurantId
        }));

        const orderId = products[0].id;
        console.log('Product ID:', orderId);

        // Convert the ID to ObjectId if necessary
        let objectId;
        try {
          objectId = new mongoose.Types.ObjectId(orderId);
        } catch (err) {
          console.error('Invalid ObjectId:', orderId);
          return response.status(400).send('Invalid ObjectId');
        }

        // Verify if the order exists before updating
        const orderExists = await Order.findById(objectId);
        if (!orderExists) {
          console.log("Order not found:", objectId);
          return response.status(404).send('Order not found');
        }

        const updatedOrder = await Order.findByIdAndUpdate(
          objectId,
          { paymentStatus: 'Completed' },
          { new: true }
        );

        if (updatedOrder) {
          console.log('Updated Order:', updatedOrder);

          const db = admin.database();
          const status = "Placed";
          updateRestaurant(updatedOrder, db, status);

          const user = await User.findById(updatedOrder.userId.toString());
          const food = await Food.findById(updatedOrder.orderItems[0].foodId.toString(), { imageUrl: 1, _id: 0 });
          const restaurant = await Restaurant.findById(updatedOrder.restaurantId.toString(), { owner: 1, _id: 0 });
          const restaurantOwner = await User.findById(restaurant.owner.toString());

          const notificationData = {
            orderId: updatedOrder._id.toString(),
            imageUrl: food.imageUrl[0],
            messageType: 'order'
          };

          if (user?.fcm && user.fcm !== 'none') {
            sendNotification(user.fcm, "🥡 Your Order Placed Successfully", notificationData, `Please wait patiently, you will be updated on your order: ${updatedOrder._id} as soon as there is an update, 🙏`);
          }

          if (restaurantOwner?.fcm && restaurantOwner.fcm !== 'none') {
            console.log("sending notification to restaurant");
            sendNotification(restaurantOwner.fcm, "🥡 Incoming Order", notificationData, `You have a new order: ${updatedOrder._id}. Please process the order 🙏`);
            console.log("successfully sent notification");
          }
        }
      } catch (err) {
        console.error('Error processing order:', err.message);
      }
      break;

    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  // Return a 200 response to acknowledge receipt of the event
  response.send();
});

app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));

app.use("/stripe", stripeRouter);

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`App listening on port ${port}!`));
