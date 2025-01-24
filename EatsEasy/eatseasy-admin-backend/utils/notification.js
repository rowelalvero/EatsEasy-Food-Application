const admin = require('firebase-admin')


async function sendPushNotification(deviceToken, messageBody, title, data = {}) {
    if (!deviceToken) {
        console.log('Error: Device token is required.');
        return;
    }

    // Ensure `data` is always an object
    if (typeof data !== 'object' || data === null) {
        console.error('Invalid data payload: Must be a non-null object.');
        return;
    }

    const message = {
        notification: {
            title: title,
            body: messageBody
        },
        data: data,
        token: deviceToken
    };

    try {
        await admin.messaging().send(message);
        console.log('Push notification sent successfully.');
    } catch (error) {
        console.error('Error sending message:', error);
    }
}



module.exports = sendPushNotification;