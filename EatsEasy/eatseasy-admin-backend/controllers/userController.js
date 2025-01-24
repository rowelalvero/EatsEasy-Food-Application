const User = require('../models/User');

module.exports = {
    getUser: async (req, res) => {
        try {
            const user = await User.findById(req.user.id)

            const { password, __v,otp,updatedAt, createdAt, ...userData } = user._doc;

            res.status(200).json(userData);
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    verifyAccount: async (req, res) => {
        const userOtp = req.params.otp;

        try {
            const user = await User.findById(req.user.id);

            if (!user) {
                return res.status(400).json({ status: false, message: "User not found" });
            }

            if (userOtp === user.otp) {
                user.verification = true;
                user.otp = "none";

                await user.save();

                const { password, __v, otp, createdAt, ...others } = user._doc;
                return res.status(200).json({ ...others })
            } else {
                return res.status(400).json({ status: false, message: "Otp verification failed" });
            }
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    verifyPhone: async (req, res) => {
        const phone = req.params.phone;

        try {
            const user = await User.findById(req.user.id);

            if (!user) {
                return res.status(400).json({ status: false, message: "User not found" });
            }

            user.phoneVerification = true;
            user.phone = phone;

            await user.save();

            const { password, __v, otp, createdAt, ...others } = user._doc;
            return res.status(200).json({ ...others })
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },


    getUsers: async (req, res) => {
        const { page = 1 } = req.query;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            const users = await User.find({verification: req.query.status}, { __v: 0, createdAt: 0, updatedAt: 0, password: 0 })
                .sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);
            const totalItems = await User.countDocuments({verification: req.query.status});
            res.status(200).json({
                users,
                currentPage: +page,
                totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    updateFcm: async (req, res) => {
        const token = req.params.token;

        try {
            const user = await User.findById(req.user.id);

            if (!user) {
                return res.status(404).json({ status: false, message: 'User not found' });
            }

            user.fcm = token;

            await user.save();
            return res.status(200).json({ status: true, message: 'FCM token updated successfully' });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
     }


}