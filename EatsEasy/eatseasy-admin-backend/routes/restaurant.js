const router = require('express').Router();
const restaurantController = require('../controllers/restaurantController');
const {verifyAdmin} = require('../middleware/verifyToken');


router.get("/byId/:id", restaurantController.getRestaurantById);
router.get("/search/:search", restaurantController.searchRestaurants);
router.get("/", restaurantController.getRestaurants);
router.delete("/:id", restaurantController.deleteRestaurant);
router.put("/status/:id",verifyAdmin, restaurantController.changeStatus);
router.get("/total-earnings", restaurantController.getTotalEarnings);

module.exports = router;