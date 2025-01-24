const sendPushNotification = require("./sendNotification");


 function sendDeliveredOrder(token, orderId) {
    if (token || token !== null) {
        sendPushNotification(token, `Your order has been delivered`, {
            orderId: orderId.toString()
        }, "Order Delivered",)
    }
}

 function sendDeliveredOrderToRestaurant(token, orderId) {
    if (token && token !== null) {
        sendPushNotification(token, `Order ${orderId} has been delivered`, {
            orderId: orderId.toString()
        }, "Order Delivered")
    }
}

 function sendOrderPickedUp(token, orderId) {
    if (token && token !== null) {
        sendPushNotification(token, `Your order has been picked up and is on its way`, {
            orderId: orderId.toString()
        }, "Order Picked Up")
    }
}

sendOrderPreparing = (token, orderId) => {
  if (token && token !== null) {
    sendPushNotification(token, `Your order is being prepared and will be ready soon`, { orderId: orderId.toString() }, "Order Preparing");
  }
};



 function sendOrderWaitingForCourier(token, orderId) {
    if (token && token !== null) {
        sendPushNotification(token, `Your order is waiting to be picked up by a courier`, {
            orderId: orderId.toString()
        }, "Order Waiting for Courier")
    }
}

function sendPayoutRequestNotification(token, amount, payoutId) {
    if (token) { 
        sendPushNotification(
            token,
            `There is a new payout request with ID ${payoutId} for the amount of ${amount}. Please review and process it.`,
            {
                payoutId: payoutId.toString()
            },
            "New Payout Request" // Notification title for admin
        );
    }
}


module.exports = {sendDeliveredOrder,sendPayoutRequestNotification, sendDeliveredOrderToRestaurant, sendOrderPickedUp, sendOrderPreparing, sendOrderWaitingForCourier}