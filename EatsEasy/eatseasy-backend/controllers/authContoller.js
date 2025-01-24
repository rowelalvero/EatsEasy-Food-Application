const User = require("../models/User");
const CryptoJS = require("crypto-js");
const jwt = require("jsonwebtoken");
const admin = require('firebase-admin')
const generateOtp = require('../utils/otp_generator');
const sendVerificationEmail = require('../utils/email_verification');
const sendNotification = require('../utils/sendNotification');

module.exports = {
    createUser: async (req, res) => {

        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        if (!emailRegex.test(req.body.email)) {
            return res.status(400).json({ status: false, message: "Invalid email format" });
        }

        // Validate password length
        const minPasswordLength = 8; // You can adjust the minimum length
        if (req.body.password.length < minPasswordLength) {
            return res.status(400).json({ status: false, message: "Password should be at least " + minPasswordLength + " characters long" });
        }

        try {
            // Check if email already exists
            const emailExist = await User.findOne({ email: req.body.email });
            if (emailExist) {
                return res.status(400).json({ status: false, message: "Email already exists" });
            }

            // Ensure phoneVerification is true
            if (!req.body.phoneVerification) {
                return res.status(400).json({
                    status: false,
                    message: "Phone verification is required to complete registration",
                });
            }

            const otp = generateOtp();

            const newUser = new User({
                username: req.body.username,
                email: req.body.email,
                validIdUrl: req.body.validIdUrl,
                proofOfResidenceUrl: req.body.proofOfResidenceUrl,
                userType: 'Client',
                fcm: req.body.fcm,
                otp: otp.toString(),
                phone: req.body.phone,
                phoneVerification: req.body.phoneVerification,
                password: CryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString(),
            });
            await sendVerificationEmail(req.body.email, otp);
            await newUser.save();

            sendNotification(
            req.body.fcm,
            "EatsEasy Registration",
            `The verification code has been sent to ${req.body.email}`,
            { type: "account_verification" }
            )

            res.status(201).json({ status: true, message: 'User created successfully' })
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    loginUser: async (req, res) => {

        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        if (!emailRegex.test(req.body.email)) {
            return res.status(400).json({ status: false, message: "Invalid email format" });
        }

        // Validate password length
        const minPasswordLength = 8; // You can adjust the minimum length
        if (req.body.password.length < minPasswordLength) {
            return res.status(400).json({ status: false, message: "Password should be at least " + minPasswordLength + " characters long" });
        }

        try {
            const user = await User.findOne({ email: req.body.email }, { __v: 0, createdAt: 0, updatedAt: 0 });
            if (!user) {
                return res.status(401).json({ status: false, message: "User not found, check your email address" })
            }

            const decrytedpass = CryptoJS.AES.decrypt(user.password, process.env.SECRET);
            const depassword = decrytedpass.toString(CryptoJS.enc.Utf8);
            if (depassword !== req.body.password) {
                return res.status(401).json({ status: false, message: "Wrong password" })
            }
            const userToken = jwt.sign({
                id: user._id, userType: user.userType, email: user.email, fcm: user.fcm,
            }, process.env.JWT_SEC,
                { expiresIn: "21d" });


            const { password,otp, ...others } = user._doc;

            res.status(200).json({ ...others, userToken });

        } catch (error) {
            res.status(500).json({ status: false, error: error.message });
        }
    },


}
