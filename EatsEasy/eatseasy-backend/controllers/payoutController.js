const Payout = require('../models/Payout');
const Restaurant = require('../models/Restaurant');
const User = require('../models/User');
const approvedRequestEmail = require('../utils/completed_payout_email');
const rejectedRequestEmail = require('../utils/rejected_payout_email');
const payoutRequestEmail = require('../utils/payout_request_email');
const {sendPayoutRequestNotification} = require('../utils/notifications_list');
module.exports = {
   

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

            const admin = await User.findOne({userType: "Admin"},{ fcm: 1});
            if(admin){
                sendPayoutRequestNotification(admin.fcm,cashout.amount, cashout.id.toString());
            }
            
            res.status(200).json({ status: true, message: "Cashout request sent successfully" });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

}