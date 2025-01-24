const router = require('express').Router();
const feedController = require('../controllers/feedbackController');

router.get("/", feedController.getFeedback);


module.exports = router;
