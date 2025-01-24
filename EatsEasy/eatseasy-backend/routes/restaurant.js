const router = require("express").Router();
const restaurantController = require("../controllers/restaurantController");
const { verifyTokenAndAuthorization, verifyVendor } = require("../middlewares/verifyToken");


// CREATE RESTAURANT
router.post("/",verifyTokenAndAuthorization,  restaurantController.addRestaurant);
router.put("/:id", verifyVendor, restaurantController.updateRestaurantImages);
router.put("/updateRestaurant/:id", verifyVendor, restaurantController.updateRestaurant);
router.post("/messagesByRes", restaurantController.sendMessages);
router.get("/profile", verifyVendor, restaurantController.getRestaurantByOwner);
// Sevices availability
router.patch("/:id",verifyVendor, restaurantController.serviceAvailability);
// GET RESTAURANT BY ID
router.get("/:code", restaurantController.getRandomRestaurants);

// GET RESTAURANT BY ID
router.get("/all/:code", restaurantController.getAllRandomRestaurants);
// // GET ALL RESTAURANT
router.get("/byId/:id", restaurantController.getRestaurant);
router.get("/statistics/:id", restaurantController.getStats);
router.post("/payout",verifyVendor, restaurantController.createPayout);
router.get("/search/:key", restaurantController.searchRestaurants);

module.exports = router