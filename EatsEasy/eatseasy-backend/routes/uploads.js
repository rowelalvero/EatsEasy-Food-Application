const router = require("express").Router();
const imageUploadsController = require("../controllers/imageUploadsController");
const multer = require("multer");
const upload = multer({
    storage: multer.memoryStorage() // Use memory storage for incoming files
  });

router.post("/",upload.single('image'), imageUploadsController.uploadImage);

module.exports = router;