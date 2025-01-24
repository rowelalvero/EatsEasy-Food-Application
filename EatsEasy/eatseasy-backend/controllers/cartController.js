const Cart = require('../models/Cart');
const Food = require('../models/Food');

module.exports = {

    addProductToCart: async (req, res) => {
        const userId = req.user.id;
        const {  productId, totalPrice, quantity } = req.body;
        let count;
        try {
            const existingProduct = await Cart.findOne({ userId, productId });
             count = await Cart.countDocuments({ userId });

            if (existingProduct) {
                existingProduct.quantity += 1;
                existingProduct.totalPrice += totalPrice;
                await existingProduct.save();
            } else {
                const newCartEntry = new Cart({
                    userId: userId,
                    productId: req.body.productId,
                    additives: req.body.additives,
                    instructions: req.body.instructions,
                    totalPrice: req.body.totalPrice,
                    quantity: req.body.quantity,
                    prepTime: req.body.prepTime,
                    restaurant: req.body.restaurant,
                    customAdditives: req.body.customAdditives
                });
                await newCartEntry.save();
                 count = await Cart.countDocuments({ userId });
            }

            res.status(201).json({ status: true, count: count });
        } catch (error) {
            res.status(500).json(error);
        }
    },

    removeProductFromCart: async (req, res) => {
        const itemId = req.params.id;
        const userId = req.user.id;

        try {
            await Cart.findOneAndDelete({_id:itemId});
            count = await Cart.countDocuments({ userId });
            res.status(200).json({ status: true, count: count });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },



    fetchUserCart: async (req, res) => {
        const id = req.user.id;

        try {
            const userCart = await Cart.find({ userId: id })
            .populate({
                path: 'productId',
                select: "imageUrl title restaurant rating ratingCount",
                populate: {
                    path: 'restaurant',
                    select: "time coords" // Add the fields you want to select from the restaurant
                }
            })

            const count = await Cart.countDocuments({userId: id });

            res.status(200).json(userCart);
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    clearUserCart: async (req, res) => {
        const userId = req.user.id;


        try {
            await Cart.deleteMany({ userId });
            res.status(200).json({ status: true, message: 'User cart cleared successfully' });
        } catch (error) {
            res.status(500).json(error);
        }
    },

    getCartCount: async (req, res) => {
        const userId = req.user.id;
    
        try {
            const count = await Cart.countDocuments({ userId: userId });
            res.status(200).json({ status: true, cartCount: count });
        } catch (error) {
            res.status(500).json(error);
        }
    },

    decrementProductQuantity: async (req, res) => {
        const userId = req.user.id;
        const productId = req.body.productId;
        const quantity = req.body.quantity;
    
        try {
            const cartItem = await Cart.findOne({ userId, productId });
            
            if (cartItem) {
                // Calculate the price of a single product
                const productPrice = cartItem.totalPrice / cartItem.quantity;
    
                // If quantity is more than 1, decrement and adjust price
                if (cartItem.quantity > 1) {
                    cartItem.quantity = quantity;
                    cartItem.totalPrice = quantity * productPrice;
                    await cartItem.save();
                    res.status(200).json({ status: true, message: 'Product quantity decreased successfully' });
                } 
                // If quantity is 1, remove the item from the cart
                else {
                    await Cart.findOneAndDelete({ userId, productId });
                    res.status(200).json({ status: true, message: 'Product removed from cart' });
                }
            } else {
                res.status(404).json({ status: false, message: 'Product not found in cart' });
            }
        } catch (error) {
            res.status(500).json(error);
        }
    },
    incrementProductQuantity: async (req, res) => {
        const userId = req.user.id;
        const productId = req.body.productId;
        const quantity = req.body.quantity;

        console.log("productId:", productId);
        console.log("userId:", userId);

        try {
            const cartItem = await Cart.findOne({ userId, productId });

            if (cartItem) {
                // Calculate the price of a single product
                const productPrice = cartItem.totalPrice / cartItem.quantity;

                // Increment the quantity and adjust the total price
                cartItem.quantity = quantity;
                cartItem.totalPrice = quantity * productPrice;
                await cartItem.save();

                res.status(200).json({ status: true, message: 'Product quantity increased successfully' });
            } else {
                res.status(404).json({ status: false, message: 'Product not found in cart' });
            }
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },
    updateCustomAdditives: async (req, res) => {
        const productId = req.params.productId;
        const { customAdditives } = req.body;  // Custom additives data sent from the frontend

          try {
            // Find the food item by ID
            const cartItem = await Cart.findOne({ productId });

            if (!cartItem) {
              return res.status(404).json({ message: 'Food item not found' });
            }

            // Update customAdditives
            cartItem.customAdditives = customAdditives;

            // Save the updated food document
            await cartItem.save();

            return res.status(200).json({ message: 'Custom additives updated successfully', cartItem });
          } catch (error) {
            console.error(error);
            return res.status(500).json({ message: 'Failed to update custom additives', error });
          }
    },

};