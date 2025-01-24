// routes/constantRoutes.js

const router = require('express').Router();
const constantController = require('../controllers/constantController');
const {verifyAdmin} = require('../middleware/verifyToken');

// GET: Retrieve the commissionRate and driverBaseRate
router.get('/', constantController.getConstants);

// PUT: Update the commissionRate and driverBaseRate
router.put('/', verifyAdmin, constantController.updateConstants);

module.exports = router;
