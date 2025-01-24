const User = require("../models/User");
const CryptoJS = require('crypto-js');
const jwt = require('jsonwebtoken');
const generateOtp = require('../utils/otp_generator');
const sendMail = require("../utils/smtp_function");

module.exports = {
    createUser : async(req, res) => {
        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

        if(!emailRegex.test(req.body.email)){
            return res.status(400).json({status: false, message: "Email is not valid"});
        }

        const minPasswordLength = 8;

        if(req.body.password < minPasswordLength){
            return res.status(400).json({status: false, message: "Password should be at least " + minPasswordLength + " characters long"});
        }

        try {
            const emailExists = await User.findOne({email: req.body.email});

            if(emailExists){
                return res.status(400).json({status: false, message: "Email already exists"});
            }

            // GENERATE OTP
            const otp = generateOtp();

            const newUser = new User({
                username: req.body.username,
                email: req.body.email,
                userType: "Client",
                password: CryptoJS.AES.encrypt(req.body.password, process.env.SECRET).toString(),
                otp: otp
            })

            // SAVE USER
           await newUser.save(); 
            
           // SEND OTP TO EMAIL
           sendMail(newUser.email, newUser.username, newUser.otp);

           res.status(201).json({status: true, message: "User successfully created."}); 
        } catch (error) {
          res.status(500).json({status: false, message: error.message})  
        }
    },
    
    loginUser : async(req, res) => {

        // VALIDATE EMAIL (REGEX)
        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

        if(!emailRegex.test(req.body.email)){
            return res.status(400).json({status: false, message: "Email is not valid"});
        }

        const minPasswordLength = 8;

        if(req.body.password < minPasswordLength){
            return res.status(400).json({status: false, message: "Password should be at least " + minPasswordLength + " characters long"});
        }
        

        try {
            const user = await User.findOne({email: req.body.email});
            console.log(user);
            if(!user){
                return res.status(400).json({status: false, message: "User not found"});
            }

            if(user.userType !== 'Admin'){
                return res.status(400).json({status: false, message: "You must be an admin to login"});
            }

            // const decryptedPassword = CryptoJS.AES.decrypt(user.password, process.env.SECRET);
            // console.log(decryptedPassword);
            // const depassword = decryptedPassword.toString(CryptoJS.enc.Utf8);
            // console.log("decript ", depassword);
            // console.log("passed pass ", req.body.password);
            // if(depassword !== req.body.password){
            //     return res.status(400).json({status: false, message: "Wrong Password"}); 
            // }

            const decrytedpass = CryptoJS.AES.decrypt(user.password, process.env.SECRET);
            const depassword = decrytedpass.toString(CryptoJS.enc.Utf8);
            if (depassword !== req.body.password) {
                return res.status(401).json({ status: false, message: "Wrong password" })
            }

            const userToken = jwt.sign({
                id: user._id,
                userType: user.userType,
                email:  user.email,
            }, process.env.JWT_SECRET, {expiresIn: "21d"});

            const {password,createdAt,updatedAt, __v, otp, ...others} = user._doc;

            res.status(200).json({...others, userToken});
      
        } catch (error) {
           res.status(500).json({status: false, message: error.message}); 
        }
    },
}