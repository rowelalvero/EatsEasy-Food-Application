const admin = require('firebase-admin');

async function sendPushNotificationToTopic( data) {
    const message = {
        notification: {
            title: '🚚 A new order ready for delivery',
            body: `If you are closer to the restaurant pick up the order and complete the task`
        },
        topic: 'delivery',
        data: data
    };

    try {
        const response = await admin.messaging().send(message);
        console.log('Successfully sent message:', response);
    } catch (error) {
        console.error('Error sending message:', error);
    }
}

module.exports = sendPushNotificationToTopic;