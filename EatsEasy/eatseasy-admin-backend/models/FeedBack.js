const mongoose = require("mongoose");

const FeedBackSchema = new mongoose.Schema({
        userId: { type: mongoose.Schema.Types.ObjectId, required: true},
        message: { type: String, required: true },
        imageUrl: { type: String, required: true },
    }, { timestamps: true }
);
module.exports = mongoose.model("Feedback", FeedBackSchema)