const express = require('express');
const cors = require('cors');
const compression = require('compression');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const CategoryRoute = require("./routes/category");
const RestaurantRoute = require("./routes/restaurant");
const FoodRoute = require("./routes/food");
const AuthRoute = require("./routes/auth");
const UserRoute = require("./routes/user");
const AddressRoute = require("./routes/address");
const OrderRoute = require("./routes/order");
const PayoutRoute = require("./routes/payouts");
const DriverRoute = require("./routes/drivers");
const FeedBackRoute = require("./routes/feedback");
const ConstantRoute = require('./routes/constant');
const { fireBaseConnection } = require('./utils/fbConnect');

dotenv.config();
fireBaseConnection();

mongoose.connect(process.env.MONGO_URL)
  .then(() => console.log("EatsEasy Database Connected"))
  .catch((err) => console.log(err));

const app = express();

const corsOptions = {
  origin: ['https://admin.eatseasy.online', 'https://eatseasy-admin.web.app'],
  methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
};

app.use(cors(corsOptions));
app.use(compression({ level: 6, threshold: 0 }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/", AuthRoute);
app.use("/api/users", UserRoute);
app.use("/api/category", CategoryRoute);
app.use("/api/restaurants", RestaurantRoute);
app.use("/api/foods", FoodRoute);
app.use("/api/address", AddressRoute);
app.use("/api/orders", OrderRoute);
app.use("/api/payouts", PayoutRoute);
app.use("/api/drivers", DriverRoute);
app.use("/api/constants", ConstantRoute);
app.use("/api/feedbacks", FeedBackRoute);

// Optional error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!' });
});

app.listen(process.env.PORT || 6013, () =>
  console.log(`Eatseasy Backend is running on ${process.env.PORT || 6013}!`)
);
