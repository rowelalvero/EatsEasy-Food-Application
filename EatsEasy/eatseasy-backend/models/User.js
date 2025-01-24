const mongoose = require("mongoose");

const walletTransactionSchema = new mongoose.Schema({
    amount: { type: Number, required: true },
    paymentMethod: { type: String, required: true },
    transactionDate: { type: Date, default: Date.now }, // Optional field to log transaction date
});

const UserSchema = new mongoose.Schema(
    {
        username: { type: String, required: true },
        email: { type: String, required: true, unique: true },
        fcm: { type: String, required: true, default: "none" },
        otp: { type: String, required: true, default: "none" },
        verification: {type: Boolean, default: false},
        password: { type: String, required: true },
        phone: { type: String, required: false, default:"01234567890"},
        validIdUrl: { type: String, required: false},
        proofOfResidenceUrl: { type: String, required: false},
        phoneVerification: { type: Boolean, default: false},
        walletTransactions: [walletTransactionSchema], // Embeds the walletTransactionSchema for transactions
        walletBalance: { type: Number, default: 0 },
        address: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Address", 
            required: false
        },
        userType: { type: String, required: true, enum: ['Admin', 'Driver', 'Vendor', 'Client'] },
        profile: {
            type: String,
            require: true,
            default: "https://firebasestorage.googleapis.com/v0/b/eatseasy-49a0d.firebasestorage.app/o/images%2Fperson-icon.png?alt=media&token=61cd2a8c-5534-4556-8806-19c0e56fd33b"
        },

    }, { timestamps: true }
);
module.exports = mongoose.model("User", UserSchema)