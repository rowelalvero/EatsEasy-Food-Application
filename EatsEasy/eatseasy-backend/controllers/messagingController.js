const admin = require('firebase-admin')

module.exports = {
    sendPushNotification: async (req, res) => {
        const { deviceToken, messageBody, data, title } = req.body;

        const message = {
            notification: {
                title: title,
                body: messageBody
            },
            data: data,
            token: deviceToken
        }
        
        try {
            const response = await admin.messaging().send(message);
            return res.status(200).json({ status: true, message: response });
        } catch (error) {
            return res.status(500).json({ status: false, message: error });
        }
    }
}