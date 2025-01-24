const sendPushNotification = require("./notification_func");


 function sendPayoutNotification(token, amount, payoutId) {
    if (token || token !== null) {
        sendPushNotification(token, `Your payout of ${amount} has been processed. Check your bank balance. Thank you for working with us.`, {
            payoutId: payoutId.toString()
        }, "Payout Processed",)
    }
}

function sendPayoutFailedNotification(token, amount, payoutId) {
    if (token || token !== null) {
        sendPushNotification(token, `Your payout of ${amount} has failed. Please contact support for more information.`, {
            payoutId: payoutId.toString()
        }, "Payout Failed",)
    }
}

exports = {sendPayoutNotification, sendPayoutFailedNotification}

