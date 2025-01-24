const Driver = require('../models/Drivers');
const Order = require('../models/Order');
const User = require('../models/User');
const rejectionDriverEmail = require('../utils/driver_rejection_email');
const sendVerificationEmail = require('../utils/driver_verification_email');

module.exports = {
    getDriverOrders: async (req, res) => {
        const page  = req.query.page || 1;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            const orders = await Order.find({ orderStatus: req.query.orderStatus, driverId: req.query.id}, {deliveryFee: 1, orderStatus: 1, orderItems: 1})
                .populate({
                    path: 'orderItems.foodId',
                    select: "imageUrl title"
                }).sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);

                const totalItems = await Order.countDocuments({ orderStatus: req.query.orderStatus, page: req.query.page});
                const fulfilled = await Order.countDocuments({ orderStatus: 'Delivered', page: req.query.id});
                const incomplete = await Order.countDocuments({ orderStatus: 'Out_for_Delivery', page: req.query.id});

                res.status(200).json({
                    orders,
                    fulfilled: fulfilled,
                    incomplete: incomplete,
                    currentPage: +page,
                    totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
                });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    getDrivers: async (req, res) => {
        const page = 1, status  = req.query;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            let query = {};
            if (status) {
                query = { verification: req.query.status };
            }

            const totalItems = await Driver.countDocuments(query);

            const drivers = await Driver.find(query, {createdAt: 0, updatedAt: 0, __v: 0})
                .populate(
                    'driver',
                    'fcm username'
                )
                .sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);
            


            res.status(200).json({
                drivers,
                currentPage: +page,
                totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },


    updateStatus: async(req, res) => {
        const id = req.query.id;
        const status = req.query.status;
        try {
            const driver = await Driver.findByIdAndUpdate(id, {verification: status }, { new: true });
            
            const user = await User.findById(driver.driver, {email: 1, fcm: 1, username:1});
            
            if(user.email){
                if(status === "Verified"){
                    
                    await sendVerificationEmail(user.email, user.username);
                }else if (status === "Rejected"){

                   
                    await rejectionDriverEmail(user.email, user.username);
                }
              
            }
            res.status(200).json({ status: true, message: "Your restaurant has been accepted" });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    }
}