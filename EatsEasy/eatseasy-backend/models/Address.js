const mongoose = require('mongoose');

const addressSchema = new mongoose.Schema({
    addressName: { type: String, required: true },
    userId: { type: String, required: true },
    addressLine1: { type: String, required: true },
    postalCode: { type: String, required: true },
    default: { type: Boolean, default: false },
    deliveryInstructions: String,
    latitude: {type: Number, required: true},
    longitude: {type: Number, required: true}
});

module.exports = mongoose.model('Address', addressSchema);
