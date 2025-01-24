const mongoose = require('mongoose');
const generateOtp = require('../utils/otp_generator')
const restaurantSchema = new mongoose.Schema({
    title: {type: String , required: true},
    time: {type: String , required: true},
    ownerName: {type: String},
    phoneVerification: { type: Boolean, default: false},
    phoneNumber: {type: String},
    imageUrl: {type: String , required: true},
    image1Url: {type: String},
    image2Url: {type: String},
    foods: {type: Array , default: []},
    pickup: {type: Boolean , default: true},
    delivery: {type: Boolean, default: true},
    owner: {type: String , required: true},
    isAvailable: {type: Boolean , default: false},
    code: {type: String , required: true},
    logoUrl: {type: String , required: true},
    rating: {
        type: Number,
        min: 0,
        max: 5,
        default: 0
    },
    ratingCount: {type: String, default: "0"},
    verification: {type: String ,default: "Pending", enum: ["Pending", "Verified", "Rejected"]},
    verificationMessage: {type: String, default: "Please allow up to 24 hours for your verification to be processed. You will receive an email once your verification is complete."},
    coords: {
        id: {type: String, default: generateOtp() },
        latitude: {type: Number , required: true},
        longitude: {type: Number , required: true},
        latitudeDelta:{type: Number , default: 0.0122},
        longitudeDelta: {type: Number , default: 0.0221},
        address: {type: String , required: true},
        title: {type: String , required: true},
    },
    earnings: {type: Number, default: 0.00}
});

const Restaurant = mongoose.model('Restaurant', restaurantSchema);

module.exports = Restaurant;
