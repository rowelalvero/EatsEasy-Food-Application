const Driver = require('../models/Driver');
const User = require('../models/User');
const Order = require("../models/Orders");
const mongoose = require('mongoose');


module.exports = {
    registerDriver: async (req, res) => {
        const userId = req.user.id;
        const newDriver = new Driver({
            driver: userId,
            vehicleType: req.body.vehicleType,
            phone: req.body.phone,
            vehicleNumber: req.body.vehicleNumber,
            vehicleName: req.body.vehicleName,
            vehicleNumber: req.body.vehicleNumber,
            licenseNumber: req.body.licenseNumber,
            licenseExpireDate: req.body.licenseExpireDate,
            driverLicenseUrl: req.body.driverLicenseUrl,
            nbiClearanceUrl: req.body.nbiClearanceUrl,
            currentLocation: {
                latitude: req.body.latitude,
                longitude: req.body.longitude
            },
            profileImage: req.body.profileImage,
        });

        try {
            await newDriver.save();
            await User.findByIdAndUpdate(
                userId,
                { userType: "Driver" },
                { new: true, runValidators: true });
            res.status(201).json({ status: true, message: 'Driver successfully added',});
        } catch (error) {
            res.status(500).json({ status: false, message: error.message, });
        }
    },    

    getDriverDetails: async (req, res) => {
        const driverId = req.user.id;
    
        try {
            const driver = await Driver.find({driver: driverId})
            if (driver) {
                res.status(200).json(driver[0]);
            } else {
                res.status(404).json({ status: false, message: 'Driver not found' });
            }
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    topUpWallet: async (req, res) => {
        const driverId = req.params.id; // Assuming the user ID comes from a verified token
        const { amount, paymentMethod } = req.body;

        try {
            const driver = await Driver.findById(driverId);
            if (!driver) {
                return res.status(404).json({ status: false, message: 'Driver not found' });
            }

            // Create a new wallet transaction
            const newTransaction = {
                amount: amount,
                paymentMethod: paymentMethod,
            };

            // Update the driver wallet balance and add the transaction
            driver.walletTransactions.push(newTransaction);
            driver.walletBalance += amount; // Update the wallet balance

            const data = { messageType: "pay" };
                // Send notification if FCM token exists
                /*if (user.fcm || user.fcm !== null || user.fcm !== "") {
                   sendNotification(
                     user.fcm,
                     'Top-up successful',
                     data,
                     `An amount of Php ${amount} has been added to your wallet.`
                   );
                }*/

            // Save the updated driver document
            await driver.save();

            res.status(200).json({ status: true, message: 'Wallet top-up successful', driver });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    withdraw: async (req, res) => {
        const driverId = req.params.id; // Get the driver ID from the request parameters
        const { amount } = req.body; // Get the withdrawal amount from the request body

        try {
            const driver = await Driver.findById(driverId);
            if (!driver) {
                return res.status(404).json({ status: false, message: 'Driver not found' });
            }

            // Check if the withdrawal amount is valid
            if (amount <= 0) {
                return res.status(400).json({ status: false, message: 'Amount must be greater than zero' });
            }
            if (amount > driver.walletBalance) {
                return res.status(400).json({ status: false, message: 'Insufficient balance' });
            }

            // Deduct the amount from the driver's wallet balance
            driver.walletBalance -= amount;

            // Create a new wallet transaction for the withdrawal
            const withdrawalTransaction = {
                amount: -amount, // Negative amount to indicate a withdrawal
                paymentMethod: 'Withdrawal', // You can adjust this as necessary
                date: new Date() // Optional: record the date of the transaction
            };

            // Add the withdrawal transaction to the driver's wallet transactions
            driver.walletTransactions.push(withdrawalTransaction);

            const data = { messageType: "pay" };
            // Send notification if FCM token exists
                if (user.fcm || user.fcm !== null || user.fcm !== "") {
                   sendNotification(
                     user.fcm,
                     data,
                     'Withdraw successful',
                     `An amount of Php ${amount} has been deducted from your wallet.`
                   );
                }

            // Save the updated driver document
            await driver.save();

            res.status(200).json({ status: true, message: 'Withdrawal successful', driver });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    updateDriverDetails: async (req, res) => {
        const driverId  = req.params.id;
    
        try {
            const updatedDriver = await Driver.findByIdAndUpdate(driverId, req.body, { new: true });
            if (updatedDriver) {
                res.status(200).json({ status: true, message: 'Driver details updated successfully' });
            } else {
                res.status(404).json({ status: false, message: 'Driver not found' });
            }
        } catch (error) {
            res.status(500).json(error);
        }
    },

    updateDriverLocation: async (req, res) => {
        const driverId = req.params.id;
        const { latitude, longitude } = req.body;

        try {
            const updatedDriver = await Driver.findByIdAndUpdate(
                driverId,
                {
                    'currentLocation.latitude': latitude,
                    'currentLocation.longitude': longitude
                },
                { new: true }
            );
            if (updatedDriver) {
                res.status(200).json({ status: true, message: 'Driver location updated successfully', driver: updatedDriver });
            } else {
                res.status(404).json({ status: false, message: 'Driver not found' });
            }
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    deleteDriver: async (req, res) => {
        const driverId = req.params.id;
    
        try {
            await Driver.findByIdAndDelete(driverId);
            res.status(200).json({ status: true, message: 'Driver deleted successfully' });
        } catch (error) {
            res.status(500).json(error);
        }
    },

    setDriverAvailability: async (req, res) => {
        const driverId  = req.params.id;
    
        try {
            const driver = await Driver.findById(driverId);
            if (!driver) {
                res.status(404).json({ status: false, message: 'Driver not found' });
                return;
            }
    
            // Toggle the availability
            driver.isAvailable = !driver.isAvailable;
            await driver.save();
    
            res.status(200).json({ status: true, message: `Driver is now ${driver.isAvailable ? 'available' : 'unavailable'}`, data: driver });
        } catch (error) {
            res.status(500).json(error);
        }
    },

    getDriversEarning: async (req, res) => {
        const driverId = req.params.id.trim();
        console.log("Driver ID:", driverId);
    
        try {
            // Validate driver ID
            const driver = await Driver.findById(driverId);
            console.log("Driver:", driver);
    
            if (!driver) {
                return res.status(404).json({ status: false, message: 'Driver not found' });
            }
    
            // Aggregate monthly earnings
            const monthlyEarnings = await Order.aggregate([
                { $match: { driverId: new mongoose.Types.ObjectId(driverId), orderStatus: 'Delivered' } },
                {
                    $group: {
                        _id: { year: { $year: "$orderDate" }, month: { $month: "$orderDate" } },
                        totalEarnings: { $sum: '$deliveryFee' }
                    }
                },
                { $project: { _id: 0, year: "$_id.year", month: "$_id.month", totalEarnings: 1 } },
            ]);
    
            // Aggregate weekly earnings
            const weeklyEarnings = await Order.aggregate([
                { $match: { driverId: new mongoose.Types.ObjectId(driverId), orderStatus: 'Delivered' } },
                {
                    $group: {
                        _id: { year: { $year: "$orderDate" }, week: { $week: "$orderDate" } },
                        totalEarnings: { $sum: '$deliveryFee' }
                    }
                },
                { $project: { _id: 0, year: "$_id.year", week: "$_id.week", totalEarnings: 1 } },
            ]);
    
            // Aggregate daily earnings
            const dailyEarnings = await Order.aggregate([
                { $match: { driverId: new mongoose.Types.ObjectId(driverId), orderStatus: 'Delivered' } },
                {
                    $group: {
                        _id: { year: { $year: "$orderDate" }, month: { $month: "$orderDate" }, day: { $dayOfMonth: "$orderDate" } },
                        totalEarnings: { $sum: '$deliveryFee' }
                    }
                },
                { $project: { _id: 0, year: "$_id.year", month: "$_id.month", day: "$_id.day", totalEarnings: 1 } },
            ]);
    
            return res.status(200).json({ status: true, monthlyEarnings, weeklyEarnings, dailyEarnings });
        } catch (error) {
            console.error("Error:", error);
            return res.status(500).json({ status: false, message: error.message });
        }
    }
    
}