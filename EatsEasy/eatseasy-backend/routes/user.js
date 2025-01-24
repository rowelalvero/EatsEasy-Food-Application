const router = require("express").Router();
const userController = require("../controllers/userController");
const {verifyTokenAndAuthorization, verifyAdmin}= require("../middlewares/verifyToken")

// UPADATE USER
router.put("/:userId", verifyTokenAndAuthorization, userController.updateUser);
router.post("/wallet/:id/topup", verifyTokenAndAuthorization, userController.topUpWallet);
router.post("/wallet/:id/withdraw", verifyTokenAndAuthorization, userController.withdraw);
router.put("/changePassword/:userEmail", userController.changePassword);
router.post('/find-user-by-email', userController.findUserByEmail);
router.post("/send-verification-email", userController.sendVerificationEmail);
router.get("/verify/:otp", userController.verifyAccount);
router.get("/verifyEmail/:otp/:email", userController.verifyEmail);
router.get("/customer_service", userController.getAdminNumber);
router.post("/feedback",verifyTokenAndAuthorization, userController.userFeedback);
router.get("/verify_phone/:phone",verifyTokenAndAuthorization, userController.verifyPhone);
router.delete("/" , verifyTokenAndAuthorization, userController.deleteUser);
router.get("/",verifyTokenAndAuthorization, userController.getUser);
router.put("/updateToken/:token",verifyTokenAndAuthorization, userController.updateFcm);
router.get("/byId/:id", userController.getUserById);

module.exports = router