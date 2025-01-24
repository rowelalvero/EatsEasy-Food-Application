const router = require('express').Router();
const payoutController = require('../controllers/payoutController');

const {verifyAdmin} = require('../middleware/verifyToken');

router.get("/", payoutController.getPayouts);
router.get('/:restaurantId/withdrawals-stats', payoutController.getRestaurantWithdrawalsStats);
router.put("/",verifyAdmin, payoutController.updatePayoutStatus);
router.delete("/:id",verifyAdmin, payoutController.deletePayout);
router.post("/",verifyAdmin, payoutController.createPayout);

module.exports = router;
