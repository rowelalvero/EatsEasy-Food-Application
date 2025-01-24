const mongoose = require('mongoose');

const optionsSchema = new mongoose.Schema({
    optionName: { type: String, required: true },
    price: { type: String, required: true }
});

const customAdditivesSchema = new mongoose.Schema({
    id: { type: Number, required: true },
    text: { type: String, required: true },
    type: { type: String, required: false },
    options: { type: [optionsSchema], required: false }, // Array of options
    linearScale: { type: Number, required: false },
    minScale: { type: Number, required: false },
    maxScale: { type: Number, required: false },
    minScaleLabel: { type: String, required: false },
    maxScaleLabel: { type: String, required: false },
    required: { type: Boolean, default: false },
    selectionType: { type: String, required: false },
    selectionNumber: { type: Number, required: false },
    customErrorMessage: { type: String, required: false }
});

const foodSchema = new mongoose.Schema({
    title: { type: String, required: true },
    foodTags: {type: Array, required: true},
    foodType: {type: Array, required: true},
    code: {type: String, required: true},
    isAvailable: {type: Boolean , required: true, default: true},
    restaurant: { type: mongoose.Schema.Types.ObjectId, ref: "Restaurant" },
    rating: {
            type: Number,
            min: 0,
            max: 5,
            default: 0,
        },
    ratingCount: {type: String, default: "0"},
    description: { type: String, required: true },
    price: { type: Number, required: true },
    imageUrl: { type: Array, required: true },
    v: { type: Number, required: false },
    category: {type: String, required: true},
    time: { type: String, required: true },
    customAdditives: { type: [customAdditivesSchema], required: true } // Array of CustomAdditives subdocuments
});

// Create a Food model
const Food = mongoose.model('Food', foodSchema);

module.exports = Food;
