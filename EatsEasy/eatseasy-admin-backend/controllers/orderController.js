const Order = require('../models/Order');

module.exports = {
    placeOrder: async (req, res) => {
        const newOrder = new Order({
            ...req.body,
            userId: req.user.id
        });

        try {
            await newOrder.save();

            const orderId = newOrder._id;
            res.status(200).json({ status: true, message: "Order placed successfully", orderId: orderId });
        } catch (error) {
            res.status(500).json({ status: true, message: error.message });
        }
    },

    getUserOrders: async (req, res) => {
        const page  = req.query.page || 1;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            const orders = await Order.find({ orderStatus: req.query.orderStatus })
                .populate({
                    path: 'orderItems.foodId',
                    select: "imageUrl title rating time"
                }).sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);

                const totalItems = await Order.countDocuments({ orderStatus: req.query.orderStatus });

                res.status(200).json({
                    orders,
                    currentPage: +page,
                    totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
                });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    }

    
}