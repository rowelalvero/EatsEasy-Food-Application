const router = require('express').Router();
const foodController = require('../controllers/foodController');
const {verifyVendor} = require('../middleware/verifyToken');



router.get("/:id", foodController.getFoodById);

router.get("/restaurant-foods/:id", foodController.getFoodsByRestaurant);


router.get("/:category", foodController.getFoodsByCategory);

router.get("/", foodController.getFoods);






module.exports = router;