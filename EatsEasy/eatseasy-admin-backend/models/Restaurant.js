const mongoose = require('mongoose');

const RestaurantSchema = new mongoose.Schema({
    title: {type: String, required: true},
    time: {type: String, required: true},
    imageUrl: {type: String, required: true},
    foods: {type: Array, default: []},
    pickup: {type: Boolean, default: true},
    delivery: {type: Boolean, default: true},
    isAvailable: {type: Boolean, default: true},
    owner: {type: String, required: true},
    code: {type: String, required: true},
    logoUrl: {type: String, required: true},
    rating: {type: Number, min: 0, max: 5, default: 0},
    ratingCount: {type: String, default: "267"},
    verification: {type: String, default: "Pending", enum: ["Pending", "Verified", "Rejected"]},
    verificationMessage: {type: String, default: "Your restaurant is under review. We will notify you once it is verified."},
    coords: {
        id: {type: String },
        latitude: {type: Number, required: true},
        longitude: {type: Number, required: true},
        latitudeDelta: {type: Number, default: 0.0122},
        longitudeDelta: {type: Number,  default: 0.0122},
        address: {type: String, required: true},
        title: {type: String, required: true},
    },
    earnings:{type: Number, default: 0.00}
});

module.exports = mongoose.model('Restaurant', RestaurantSchema);