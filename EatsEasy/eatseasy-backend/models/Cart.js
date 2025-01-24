const mongoose = require('mongoose');

const cartSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
    productId: { type: mongoose.Schema.Types.ObjectId, ref: "Food" },
    additives: { type: Array },
    instructions: { type: String, default: '' },
    totalPrice: { type: Number, required: true },
    quantity: { type: Number, required: true },
    prepTime: { type: String, default: '' },
    restaurant: { type: mongoose.Schema.Types.ObjectId, ref: "Restaurant" },
    customAdditives: { type: Map, of: mongoose.Schema.Types.Mixed }, // Update here
});

module.exports = mongoose.model('Cart', cartSchema);
