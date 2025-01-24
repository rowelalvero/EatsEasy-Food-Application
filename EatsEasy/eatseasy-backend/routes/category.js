const router = require("express").Router();
const categoryController = require("../controllers/categoryController");


// UPADATE category
router.put("/:id", categoryController.updateCategory);

router.post("/", categoryController.createCategory);

// DELETE category
router.delete("/:id", categoryController.deleteCategory);

// DELETE category
router.post("/image/:id", categoryController.patchCategoryImage);

// GET category
router.get("/", categoryController.getAllCategories);

// GET category
router.get("/random", categoryController.getRandomCategories);

module.exports = router