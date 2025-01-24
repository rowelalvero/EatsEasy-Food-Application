const router = require('express').Router();
const orderController = require('../controllers/orderController');
const {verifyTokenAndAuthorization} = require('../middleware/verifyToken');


router.get("/", orderController.getUserOrders);

module.exports = router;