const FeedBack = require("../models/FeedBack");
const User = require("../models/User");
const admin = require('firebase-admin');
const CryptoJS = require("crypto-js");
const generateOtp = require('../utils/otp_generator');
const sendVerificationEmail = require('../utils/email_verification');
const sendNotification = require('../utils/sendNotification');

module.exports = {

    updateUser: async (req, res) => {
            if (req.body.password) {
                req.body.password = CryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString();
            }
            try {
                const updatedUser = await User.findByIdAndUpdate(
                    req.user.id, {
                    $set: req.body
                }, { new: true });
                const { password, __v, createdAt, ...others } = updatedUser._doc;

                res.status(200).json({ ...others });
            } catch (err) {
                res.status(500).json(err)
            }
    },

    topUpWallet: async (req, res) => {
            const userId = req.params.id; // Assuming the user ID comes from a verified token
            const { amount, paymentMethod } = req.body;

            try {
                const user = await User.findById(userId);
                if (!user) {
                    return res.status(404).json({ status: false, message: 'User not found' });
                }

                // Create a new wallet transaction
                const newTransaction = {
                    amount: amount,
                    paymentMethod: paymentMethod,
                };

                // Update the user wallet balance and add the transaction
                user.walletTransactions.push(newTransaction);
                user.walletBalance += amount; // Update the wallet balance

                const data = { messageType: "pay" };
                // Send notification if FCM token exists
                if (user.fcm || user.fcm !== null || user.fcm !== "") {
                   sendNotification(
                     user.fcm,
                     'Top-up successful',
                     data,
                     `An amount of Php ${amount} has been added to your wallet.`
                   );
                }
                // Save the updated user document
                await user.save();

                res.status(200).json({ status: true, message: 'Wallet top-up successful', user });
            } catch (error) {
                res.status(500).json({ status: false, message: error.message });
            }
    },

    withdraw: async (req, res) => {
            const userId = req.params.id; // Get the user ID from the request parameters
            const { amount } = req.body; // Get the withdrawal amount from the request body

            try {
                const user = await User.findById(userId);
                if (!user) {
                    return res.status(404).json({ status: false, message: 'User not found' });
                }

                // Check if the withdrawal amount is valid
                if (amount <= 0) {
                    return res.status(400).json({ status: false, message: 'Amount must be greater than zero' });
                }
                if (amount > user.walletBalance) {
                    return res.status(400).json({ status: false, message: 'Insufficient balance' });
                }

                // Deduct the amount from the user's wallet balance
                user.walletBalance -= amount;

                // Create a new wallet transaction for the withdrawal
                const withdrawalTransaction = {
                    amount: -amount, // Negative amount to indicate a withdrawal
                    paymentMethod: 'Withdrawal', // You can adjust this as necessary
                    date: new Date() // Optional: record the date of the transaction
                };

                // Add the withdrawal transaction to the user's wallet transactions
                user.walletTransactions.push(withdrawalTransaction);

                // Save the updated user document
                await user.save();

                res.status(200).json({ status: true, message: 'Withdrawal successful', driver });
            } catch (error) {
                res.status(500).json({ status: false, message: error.message });
            }
        },

    findUserByEmail: async (req, res) => {
        const { email } = req.body;

        // Validate email format
        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({ status: false, message: "Invalid email format" });
        }

        try {
            // Check if user exists
            const user = await User.findOne({ email });
            if (!user) {
                return res.status(404).json({ status: false, message: "Email does not exist" });
            }

            // Exclude sensitive fields
            const { password, __v, createdAt, ...userData } = user._doc;

            res.status(200).json({ status: true, user: userData });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    sendVerificationEmail: async (req, res) => {
        const { email } = req.body;

        // Validate email format
        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({ status: false, message: "Invalid email format" });
        }

        try {
            // Check if the user exists
            const user = await User.findOne({ email });
            if (!user) {
                return res.status(404).json({ status: false, message: "User not found" });
            }

            // Generate OTP and update the user record
            const otp = generateOtp();
            user.otp = otp.toString();

            // Send verification email and wait for it to complete
            await sendVerificationEmail(email, otp); // Ensure this is awaited

            await user.save();

            res.status(200).json({ status: true, message: "Verification email sent successfully" });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    changePassword: async (req, res) => {
        try {
            if (req.body.password) {
                if (!process.env.SECRET) {
                    throw new Error("SECRET environment variable is not defined");
                }

                // Encrypt the password
                req.body.password = CryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString();
            }

            const updatedUser = await User.findOneAndUpdate(
                { email: req.params.userEmail },  // Find user by email
                { $set: req.body },  // Set new password
                { new: true }  // Return updated user document
            );

            if (!updatedUser) {
                return res.status(404).json({ message: "User not found" });
            }

            const { password, __v, createdAt, ...others } = updatedUser._doc;

            // Return the updated user details (without sensitive information)
            res.status(200).json({ ...others });
        } catch (err) {
            console.error(err.message);
            res.status(500).json({ error: err.message || "An error occurred" });
        }
    },

    deleteUser: async (req, res) => {
        try {
            await User.findByIdAndDelete(req.user.id)
            res.status(200).json("Successfully Deleted")
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    },

    verifyEmail: async (req, res) => {
      const providedOtp = req.params.otp;
      const providedEmail = req.params.email;

      try {
        if (!providedOtp || !providedEmail) {
          return res.status(400).json({ status: false, message: 'OTP and email are required' });
        }

        const user = await User.findOne({ email: providedEmail });

        if (!user) {
          return res.status(404).json({ status: false, message: 'User not found' });
        }

        if (user.otp === providedOtp) {
          user.verification = true;
          user.otp = 'none'; // Optionally reset the OTP
          await user.save();

          const { password, __v, otp, createdAt, ...others } = user._doc;
          return res.status(200).json({ status: true, message: 'Email verified', user: others });
        } else {
          return res.status(400).json({ status: false, message: 'OTP verification failed' });
        }
      } catch (error) {
        console.error(error);
        res.status(500).json({ status: false, message: 'Internal server error' });
      }
    },

    verifyAccount: async (req, res) => {
        const providedOtp = req.params.otp
        try {
            
            const user = await User.findById(req.user.id);

            if(!user){
                return res.status(404).json({status: false, message: 'User not found'})
            }
    
            // Check if user exists and OTP matches
            if (user.otp === providedOtp) {
                // Update the verification field
                user.verification = true;
                user.otp = 'none'; // Optionally reset the OTP
                await user.save();
    
                const { password, __v, otp, createdAt, ...others } = user._doc;
                return res.status(200).json({ ...others });
            } else {
                return res.status(400).json({status: false, message: 'OTP verification failed'});
            }
        } catch (error) {
            res.status(500).json({status: false, message: error.message });
        }
    },

    verifyPhone: async (req, res) => {
        const phone = req.params.phone
        try {
            
            const user = await User.findById(req.user.id);

            if(!user){
                return res.status(404).json({status: false, message: 'User not found'})
            }
    
            user.phoneVerification = true;
            user.phone = phone; // Optionally reset the OTP
            await user.save();

            const { password, __v, otp, createdAt, ...others } = user._doc;
            return res.status(200).json({ ...others });

        } catch (error) {
            res.status(500).json({status: false, message: error.message });
        }
    },
  
    getUser: async (req, res) => {
        try {
            const user = await User.findById(req.user.id).populate('address');
            const { password, __v, createdAt, ...userdata } = user._doc;
            res.status(200).json(userdata)
        } catch (error) {
            res.status(500).json(error)
        }
    },


    getAdminNumber: async (req, res) => {
        try {
            const adminNumber = await User.find({userType: "Admin"}, {phone: 1});

            res.status(200).json(adminNumber[0]['phone'])
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    },

    userFeedback: async (req, res) => {
        const id = req.user.id
        try {
            const feedback = new FeedBack({
                userId: id,
                message: req.body.message,
                imageUrl: req.body.imageUrl,
            })
            await feedback.save()

            res.status(201).json({status: true, message:"Feedback submitted successfully"})
        } catch (error) {
            res.status(500).json({status: false, message: error.message})
        }
    },

    getUserById: async (req, res) => {
        const id = req.params.id;
        try {
            const user = await User.findById(id);

            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }

            res.status(200).json(user);
        } catch (error) {
            res.status(500).json({ message: 'Server error', error: error.message });
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

            if(user.userType == 'Driver'){
                await admin.messaging().subscribeToTopic(user.fcm, "delivery");
            }

            await user.save();
            return res.status(200).json({ status: true, message: 'FCM token updated successfully' });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
     }
}