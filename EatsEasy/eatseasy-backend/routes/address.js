const router = require("express").Router();
const addressController = require("../controllers/addressController");
const { verifyTokenAndAuthorization, verifyAdmin } = require("../middlewares/verifyToken");
const { getDirections } = require("../controllers/addressController"); // Import the new getDirections method

// UPADATE USER
router.post("/", verifyTokenAndAuthorization, addressController.createAddress);

// DELETE USER
router.delete("/:id", verifyTokenAndAuthorization, addressController.deleteAddress);

// GET USER
router.get("/default", verifyTokenAndAuthorization, addressController.getDefaultAddress);

// GET ALL ADDRESSES FOR USER
router.get("/all", verifyTokenAndAuthorization, addressController.getUserAddresses);

// UPDATE ADDRESS
router.put("/:id", verifyTokenAndAuthorization, addressController.updateAddress);

// SET DEFAULT ADDRESS
router.patch("/default/:address", verifyTokenAndAuthorization, addressController.setDefaultAddress);

// NEW ROUTE: GET DIRECTIONS FROM GOOGLE MAPS API (PROXY)
router.post("/directions", getDirections); // Add the new route here

router.post("/getPolyline", addressController.getPolyline);

router.post("/search-places", addressController.searchPlaces);

router.post("/get-place-detail", addressController.getPlaceDetail);

router.post("/reverse-geocode", addressController.reverseGeocode);

module.exports = router;
