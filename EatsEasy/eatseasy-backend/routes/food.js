const router = require("express").Router();
const foodController = require("../controllers/foodController");
const {verifyTokenAndAuthorization, verifyVendor}= require("../middlewares/verifyToken")


// UPADATE category
router.get('/restaurant-foods/:id', foodController.getFoodList)

router.post("/", verifyVendor , foodController.addFood);

router.put("/:id", verifyVendor , foodController.updateFoodById);

router.post("/tags/:id", foodController.addFoodTag);

router.post("/type/:id", foodController.addFoodType);

router.get("/:id", foodController.getFoodById);

router.get("/search/:food", foodController.searchFoods);

router.get("/categories/:category/:code", foodController.getFoodsByCategoryAndCode);

router.get("/:category/:code", foodController.getRandomFoodsByCategoryAndCode);

router.delete("/:id", foodController.deleteFoodById);

router.patch("/:id", foodController.foodAvailability);

router.get("/recommendation/:code", foodController.getRandomFoodsByCode);

router.get("/randoms", foodController.getRandomFoods);


module.exports = router