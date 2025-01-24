const router = require("express").Router();
const messagingController = require('../controllers/messagingController');

router.post("/", messagingController.sendPushNotification);

module.exports = router;