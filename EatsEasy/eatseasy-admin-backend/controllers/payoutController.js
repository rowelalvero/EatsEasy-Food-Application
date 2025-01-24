const Payout = require('../models/Payout');
const Restaurant = require('../models/Restaurant');
const User = require('../models/User');
const approvedRequestEmail = require('../utils/completed_payout_email');
const rejectedRequestEmail = require('../utils/rejected_payout_email');
const payoutRequestEmail = require('../utils/payout_request_email');
const sendPayoutNotification = require('../utils/notifications_list');
module.exports = {
    getPayouts: async (req, res) => {
        const page = 1, status  = req.query;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            let query = {};
            if (status) {
                query = { status: req.query.status };
            }

            const totalItems = await Payout.countDocuments(query);

            const payouts = await Payout.find(query, { updatedAt: 0, __v: 0})
                .populate(
                    'restaurant',
                    'title logoUrl earnings'
                )
                .sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);

            res.status(200).json({
                payouts,
                currentPage: +page,
                totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    getRestaurantWithdrawalsStats: async (req, res) => {
            const { restaurantId } = req.params;

            try {
                // Validate if the restaurant exists
                const restaurant = await Restaurant.findById(restaurantId);
                if (!restaurant) {
                    return res.status(404).json({ status: false, message: "Restaurant not found" });
                }

                // Total number of withdrawals
                const totalWithdrawals = await Payout.countDocuments({ restaurant: restaurantId });

                // Pending withdrawals
                const pendingWithdrawals = await Payout.countDocuments({
                    restaurant: restaurantId,
                    status: 'pending'
                });

                // Completed withdrawals
                const completedWithdrawals = await Payout.countDocuments({
                    restaurant: restaurantId,
                    status: 'completed'
                });

                // Respond with the stats
                res.status(200).json({
                    status: true,
                    message: 'Withdrawal stats retrieved successfully',
                    data: {
                        totalWithdrawals,
                        pendingWithdrawals,
                        completedWithdrawals
                    }
                });
            } catch (error) {
                res.status(500).json({ status: false, message: error.message });
            }
        },
    
    updatePayoutStatus: async (req, res) => {
        const id = req.query.id;
        const status = req.query.status;
        try {
            const cashout = await Payout.findById(id);
            if (!cashout) {
                return res.status(404).json({ status: false, message: "Cashout not found" });
            }

            if (status == "completed") {
                cashout.status = "completed";
                await cashout.save();
                const restaurant = await Restaurant.findById(cashout.restaurant);
                
                if(!restaurant){
                    return res.status(404).json({ status: false, message: "Restaurant does not exist" });
                }
                
                restaurant.earnings = restaurant.earnings - cashout.amount;
                await restaurant.save();

                const user = await User.findById(restaurant.owner, { email: 1, username: 1 , fcm: 1});
                
                if(!user){
                    return res.status(404).json({ status: false, message: "User does not exist" });

                }

                approvedRequestEmail(user.email, user.username,cashout._id,cashout.createdAt,cashout.amount);
                
                sendPayoutNotification(user.fcm,cashout.amount, cashout._id.toString() )

                return res.status(200).json({ status: true, message: "Cashout approved successfully" });
            }

            if (status === "failed") {
                cashout.status = "failed";
                await cashout.save();

                const restaurant = await Restaurant.findById(cashout.restaurant);

                if(!restaurant){
                    return res.status(404).json({ status: false, message: "Restaurant does not exist" });
                }

                const user = await User.findById(restaurant.owner, { email: 1, username: 1 , fcm: 1});
               
                if(!user){
                    return res.status(404).json({ status: false, message: "User does not exist" });

                }

                
                rejectedRequestEmail(user.email, user.username,"Your cashout request has been rejected, because of insufficient balance")
                
                sendPayoutNotification(user.fcm,cashout.amount, cashout._id.toString() )
                
                return res.status(200).json({ status: true, message: "Cashout rejected successfully" });
            }
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    deletePayout: async (req, res) => {
        const { id } = req.params;
        try {
            await Payout.findByIdAndDelete(id);
            res.status(200).json({ status: true, message: 'Payout deleted successfully' });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    createPayout: async (req, res) => {
       

        try {
            const restaurant = await Restaurant.findById(req.body.restaurant);
            if (restaurant.earnings < req.body.amount) {
                return res.status(400).json({ status: false, message: "Insufficient balance" });
            }
            const user = await User.findById(restaurant.owner, { email: 1, username: 1 });

            if (!user) {
                return res.status(404).json({ status: false, message: "User not found" });
            }

            const cashout = new Payout({
                amount: req.body.amount,
                restaurant: req.body.restaurant,
                accountNumber: req.body.accountNumber,
                accountName: req.body.accountName,
                accountBank: req.body.accountBank,
                paymentMethod: req.body.paymentMethod,
            });
            await cashout.save();
            payoutRequestEmail(user.email, user.username,req.body.amount)
            // send notification to the restaurant  
            res.status(200).json({ status: true, message: "Cashout request sent successfully" });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

}