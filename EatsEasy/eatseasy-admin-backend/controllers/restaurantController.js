const Restaurant = require('../models/Restaurant');
const Order = require('../models/Order');
const User = require('../models/User');
const Food = require('../models/Food');
const sendPushNotification = require('../utils/notification');
const sendMail = require('../utils/smtp_function');
const rejectionEmail = require('../utils/rejection_email');

module.exports = {

    getRestaurants: async (req, res) => {
        const { page = 1, status } = req.query;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            let query = {};
            if (status) {
                query = { verification: req.query.status };
            }

            const totalItems = await Restaurant.countDocuments(query);

            const restaurants = await Restaurant.find(query, {logoUrl: 1,title:1, isAvailable: 1,ratingCount: 1, rating: 1, time: 1, coords: 1 })
                .sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);

            res.status(200).json({
                restaurants,
                currentPage: +page,
                totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    getRestaurantById: async (req, res) => {
        const id = req.params.id;
        try {
            const data = await Restaurant.findById(id);
            
            const ordersTotal = await Order.countDocuments({ restaurantId: id, orderStatus: "Delivered" });
            const cancelledOrders = await Order.countDocuments({ restaurantId: id, orderStatus: "Cancelled" });
            
            const revenue = await Order.aggregate([
                { $match: { restaurantId: id, orderStatus: "Delivered" } },
                { $group: { _id: null, total: { $sum: "$orderTotal" } } }
            ]);

           

            const processingOrders = await Order.countDocuments({
                restaurantId: id,
                orderStatus: {
                  $in: ["Placed", "Preparing", "Manual", "Ready", "Out_for_Delivery"],
                },
              });

              const revenueTotalString = revenue[0]?.total.toString() || 0.0.toString();

            const revenueTotal = parseFloat(revenueTotalString)
            const restaurantToken = await User.findById(data.owner, { fcm: 1 });
           


            res.status(200).json(
                {
                    data,
                    ordersTotal,
                    cancelledOrders,
                    revenueTotal,
                    processingOrders,
                    restaurantToken
                });


        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    searchRestaurants: async (req, res) => {
        const search = req.params.search;

        try {
            const results = await Restaurant.aggregate([
                {
                    $search: {
                        index: "default",
                        text: {
                            query: search,
                            path: {
                                wildcard: "*"
                            }
                        }
                    }
                }
            ])

            res.status(200).json(results);
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    changeStatus: async (req, res) => {
            const id = req.params.id;
            let status = req.query.status;

            try {
                const restaurant = await Restaurant.findById(id);
                if (!restaurant) {
                  return res.status(404).json({ message: "Restaurant not found" });
                }
                restaurant.verification = status;
                await restaurant.save();

                const restaurantData = await User.findById(restaurant.owner, {fcm: 1, email: 1, username: 1});

                if(restaurantData.email){
                    if(status == "Verified"){
                         if(restaurantData.fcm != "none"){
                             let data = {
                                 "type": "verification",
                                 "message": "Your restaurant has been verified"
                             }
                             await sendPushNotification(restaurantData.fcm, "Restaurant Verification","Your restaurant has been verified",data, "Your restaurant has been verified")
                         }
                        await sendMail(restaurantData.email, restaurantData.username);
                    }
                    else if (status == "Rejected"){

                         if(restaurantData.fcm != "none"){
                             let data = {
                                 "type": "verification",
                                 "message": "Your restaurant has been verified"
                             }
                             await sendPushNotification(restaurantData.fcm, "Restaurant Verification","Your restaurant has been rejected",data, "Your restaurant has been rejected",)
                         }
                        await rejectionEmail(restaurantData.email, restaurantData.username);
                    }

                }

                res.status(200).json({ status: true, message: "Status changed successfully" });
            } catch (error) {
                res.status(500).json({ status: false, message: error.message });
            }
    },

    deleteRestaurant: async (req, res) => {
        const id  = req.params;
        const owner = req.query.owner;

        if (!owner) {
            return res.status(400).json({ status: false, message: 'Owner ID is required for deletion.' });
        }
    
        if (!id) {
            return res.status(400).json({ status: false, message: 'Restaurant ID is required for deletion.' });
        }
    
        try {
            await Food.deleteMany({restaurant: id});
            await Order.deleteMany({restaurantId: id});
            await User.findByIdAndUpdate(
                owner,
                { userType: "Client" },
                { new: true, runValidators: true });
            await Restaurant.findByIdAndRemove(id);

            
    
            res.status(200).json({ status: true, message: 'Restaurant successfully deleted' });
        } catch (error) {
            console.error("Error deleting Restaurant:", error);
            res.status(500).json({ status: false, message: 'An error occurred while deleting the restaurant.' });
        }
    },

    getTotalEarnings: async (req, res) => {
        try {
            // Extract the commissionRate from the request query or body (default to 10% if not provided)
            const commissionRate = req.query.commissionRate || req.body.commissionRate || 0.10;  // Default to 10% if not provided

            // Aggregate all earnings from all restaurants
            const earnings = await Restaurant.aggregate([
                {
                    $group: {
                        _id: null, // Grouping all records together
                        totalEarnings: { $sum: "$earnings" } // Summing up the earnings
                    }
                }
            ]);

            // If no earnings found, return a 0 total
            const totalEarnings = earnings.length > 0 ? earnings[0].totalEarnings : 0;

            // Calculate the commission based on the provided commissionRate
            const commission = totalEarnings * commissionRate;

            // Return the total earnings and commission
            res.status(200).json({
                totalEarnings,
                commission
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    getSpecificVendorEarnings: async (req, res) => {
            const id = req.params.id;
            try {
                // Find the restaurant by ID
                const restaurant = await Restaurant.findById(id);

                // If restaurant not found, return an error
                if (!restaurant) {
                    return res.status(404).json({ status: false, message: "Restaurant not found" });
                }

                // Retrieve the total earnings
                const totalEarnings = restaurant.earnings;

                // Calculate 10% of the total earnings
                const tenPercent = totalEarnings * 0.10;

                // Return the total earnings and 10% of it
                res.status(200).json({
                    totalEarnings,
                    tenPercent
                });
            } catch (error) {
                res.status(500).json({ status: false, message: error.message });
            }
        },
}