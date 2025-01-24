const router = require('express').Router();
const driversController = require('../controllers/driversControllers');

const {verifyAdmin} = require('../middleware/verifyToken');

router.get("/", driversController.getDrivers);
router.put("/",verifyAdmin, driversController.updateStatus);
router.get("/orders",verifyAdmin, driversController.getDriverOrders);

module.exports = router;
