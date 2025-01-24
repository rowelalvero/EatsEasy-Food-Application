// routes/constantRoutes.js

const router = require('express').Router();
const constantController = require('../controllers/constantController');

// GET: Retrieve the commissionRate and driverBaseRate
router.get('/', constantController.getConstants);

module.exports = router;
