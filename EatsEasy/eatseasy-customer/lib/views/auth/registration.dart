import 'package:eatseasy/common/back_ground_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/registration_controller.dart';
import 'package:eatseasy/models/registration.dart';
import 'package:eatseasy/views/auth/widgets/email_textfield.dart';
import 'package:eatseasy/views/auth/widgets/password_field.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../../common/reusable_text.dart';
import '../../controllers/Image_upload_controller.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _firstNameController = TextEditingController();
  late final TextEditingController _lastNameController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _confirmPassword =TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final imageUploader = Get.put(ImageUploadController());
  final FocusNode _passwordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isVerifying = false;
  bool isOtpVerified = false;
  String? verificationId;

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPassword.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final form = _loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _verifyPhone() async {
    setState(() {
      isVerifying = true;
    });

    if (kIsWeb) {
      // Web-specific OTP verification
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.snackbar('Success', 'Phone number verified');
          setState(() {
            verificationId = '';
            isVerifying = false;
            isOtpVerified = true;
            //controller.getUserData();
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Phone number verification failed');
          setState(() {
            isVerifying = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
            isVerifying = false;
          });
          Get.snackbar('OTP Sent', 'Please check your phone for the OTP');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
            isVerifying = false;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } else {
      // Mobile (Android/iOS) specific code
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.snackbar('Success', 'Phone number verified');
          setState(() {
            verificationId = '';
            isVerifying = false;
            isOtpVerified = true;
            //controller.getUserData();
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Phone number verification failed');
          setState(() {
            isVerifying = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
            isVerifying = false;
          });
          Get.snackbar('OTP Sent', 'Please check your phone for the OTP');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
            isVerifying = false;
          });
        },
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (verificationId == null || _otpController.text.isEmpty) return;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      Get.snackbar('Success', 'Phone number verified');
      setState(() {
        isOtpVerified = true;
      });
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  RxBool isPasswordLengthValid = false.obs;
  RxBool isPasswordUppercaseValid = false.obs;
  RxBool isPasswordLowercaseValid = false.obs;
  RxBool isPasswordNumberValid = false.obs;
  RxBool isPasswordMatch = false.obs;


  bool isPasswordValid(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    RegExp regExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regExp.hasMatch(password);
  }

  Color _getPasswordBorderColor(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

    if (password.isEmpty) {
      return Colors.grey; // Default border color for empty input
    } else if (!passwordRegex.hasMatch(password)) {
      return Colors.red; // Red border for invalid password
    } else {
      return Colors.green; // Green border for valid password
    }
  }

  Color _getConfirmPasswordBorderColor() {
    if (_isConfirmPasswordError) {
      return Colors.red; // Show red border if there's an error
    }
    return Colors.grey; // Default border color
  }


  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isConfirmPasswordError = false;


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Register",
          style: appStyle(24, kPrimary, FontWeight.bold),
        ),
      ),
      body: Center(child: SizedBox(width: 640, child: BackGroundContainer(child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 30.h,
          ),
          //Lottie.asset('assets/anime/delivery.json'),
          /*Image.asset(
            'assets/images/welcomeImage.png',
            height: height / 3,
            width: width,
          ),*/
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmailTextField(
                    focusNode: _passwordFocusNode,
                    hintText: "First name",
                    controller: _firstNameController,
                    prefixIcon: Icon(
                      CupertinoIcons.person,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  EmailTextField(
                    focusNode: _passwordFocusNode,
                    hintText: "Last name",
                    controller: _lastNameController,
                    prefixIcon: Icon(
                      CupertinoIcons.person,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          onChanged: (String value) {
                            setState(() {
                              isOtpVerified = false;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          style: appStyle(12, kDark, FontWeight.normal),
                          decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle: appStyle(16, kGray, FontWeight.normal),
                            prefixIcon: Icon(CupertinoIcons.phone, color: Theme.of(context).dividerColor, size: 20),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kGray, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kGray, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimary, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimary, width: 0.5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      isOtpVerified
                          ? const Row(
                        children: [
                          Text("Verified", style: TextStyle(color: Colors.lightGreen)),
                          Icon(Icons.check_circle, color: Colors.lightGreen),
                        ],
                      ): ElevatedButton(
                        onPressed: isVerifying ? null : _verifyPhone,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
                          backgroundColor: kSecondary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1.0,
                        ),
                        child: isVerifying
                            ? LoadingAnimationWidget.threeArchedCircle(
                          color: Colors.white,
                          size: 24,
                        )
                            : const Text('Verify'),
                      )
                    ],
                  ),
                  if (verificationId != null && !isOtpVerified) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter OTP",
                        prefixIcon: Icon(CupertinoIcons.lock, color: Theme.of(context).dividerColor, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _verifyOtp,
                        child: const Text('Verify OTP'),
                      ),
                    ),
                  ],

                  const SizedBox(
                    height: 15 ,
                  ),

                  EmailTextField(
                    focusNode: _passwordFocusNode,
                    hintText: "Email",
                    controller: _emailController,
                    prefixIcon: Icon(
                      CupertinoIcons.mail,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    cursorColor: kPrimary,
                    onChanged: (value) {
                      isPasswordLengthValid.value = value.length > 8;
                      isPasswordUppercaseValid.value = value.contains(RegExp(r'[A-Z]'));
                      isPasswordLowercaseValid.value = value.contains(RegExp(r'[a-z]'));
                      isPasswordNumberValid.value = value.contains(RegExp(r'[0-9]'));
                      setState(() {
                        isPasswordMatch.value = value == _confirmPassword.text;
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: _isPasswordVisible ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                      labelText: "Password",
                      prefixIcon: Icon(
                        CupertinoIcons.lock,
                        color: Theme.of(context).dividerColor,
                        size: 20.h,
                      ),
                      labelStyle: appStyle(16, kGray, FontWeight.normal),
                      isDense: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kGray, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _getPasswordBorderColor(_passwordController.text), width: 0.5,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(12))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _getPasswordBorderColor(_passwordController.text), width: 0.5,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(12))
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  if (_passwordController.text.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isPasswordLengthValid.value ? Icons.check_circle_rounded : Icons.do_disturb_on_rounded,
                              color: isPasswordLengthValid.value ? Colors.green : Colors.red,
                            ),
                            Text(
                              'Password must be more than 8 characters',
                              style: TextStyle(
                                color: isPasswordLengthValid.value ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              isPasswordUppercaseValid.value ? Icons.check_circle_rounded : Icons.do_disturb_on_rounded,
                              color: isPasswordUppercaseValid.value ? Colors.green : Colors.red,
                            ),
                            Text(
                              'Password must contain at least 1 uppercase letter',
                              style: TextStyle(
                                color: isPasswordUppercaseValid.value ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              isPasswordLowercaseValid.value ? Icons.check_circle_rounded : Icons.do_disturb_on_rounded,
                              color: isPasswordLowercaseValid.value ? Colors.green : Colors.red,
                            ),
                            Text(
                              'Password must contain at least 1 lowercase letter',
                              style: TextStyle(
                                color: isPasswordLowercaseValid.value ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              isPasswordNumberValid.value ? Icons.check_circle_rounded : Icons.do_disturb_on_rounded,
                              color: isPasswordNumberValid.value ? Colors.green : Colors.red,
                            ),
                            Text(
                              'Password must contain at least 1 number',
                              style: TextStyle(
                                color: isPasswordNumberValid.value ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],

                  SizedBox(
                    height: 15.h,
                  ),

                  TextField(
                    controller: _confirmPassword,
                    cursorColor: kPrimary,
                    obscureText: !_isConfirmPasswordVisible,
                    onChanged: (value) {
                      setState(() {
                        //isPasswordMatch.value = value == _passwordController.text;
                        _isConfirmPasswordError = false;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(
                        CupertinoIcons.lock,
                        color: Theme.of(context).dividerColor,
                        size: 20.h,
                      ),
                      labelStyle: appStyle(16, kGray, FontWeight.normal),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: _isConfirmPasswordVisible ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                      isDense: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kGray, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _getConfirmPasswordBorderColor(), width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _getConfirmPasswordBorderColor(), width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),
                  ReusableText(
                      text: "Upload documents",
                      style: appStyle(16, kDark, FontWeight.bold)),
                  ReusableText(
                    text:
                    "You are required fill all the details fully with the correct information",
                    style: appStyle(11, kGray, FontWeight.normal),
                  ),
                  ReusableText(
                    text:
                    "You can upload your picture of your house to be able track you house by our riders easily",
                    style: appStyle(11, kGray, FontWeight.normal),
                  ),
                  ReusableText(
                    text:
                    "Upload proof of residence e.g., Valid IDs, Electric/Water bill",
                    style: appStyle(11, kGray, FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          imageUploader.pickImage("validId");
                        },
                        child: Badge(
                          backgroundColor: Colors.transparent,

                          label: Obx(
                                () => imageUploader.validIdUrl.isNotEmpty
                                ? GestureDetector(
                              onTap: () {
                                imageUploader.validIdUrl = '';

                              },
                              child: const Icon(Icons.remove_circle, color: kRed),
                            ) : Container(),
                          ),

                          child: Container(
                              height: 120.h,
                              width: 180.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: kGrayLight),
                              ),
                              child: Obx(
                                    () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "validId"
                                    ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadingAnimationWidget.threeArchedCircle(
                                          color: kSecondary,
                                          size: 35
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                        style: appStyle(16, kDark, FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )
                                    : imageUploader.validIdUrl.isEmpty
                                    ? Center(
                                  child: Text(
                                    "Upload Valid ID",
                                    style:
                                    appStyle(16, kDark, FontWeight.w600),
                                  ),
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    imageUploader.validIdUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          imageUploader.pickImage("proofOfResidence");
                        },
                        child: Badge(
                          backgroundColor: Colors.transparent,

                          label: Obx(
                                () => imageUploader.proofOfResidenceUrl.isNotEmpty
                                ? GestureDetector(
                              onTap: () {
                                imageUploader.proofOfResidenceUrl = '';

                              },
                              child: const Icon(Icons.remove_circle, color: kRed),
                            ) : Container(),
                          ),

                          child: Container(
                              height: 120.h,
                              width: 180.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: kGrayLight),
                              ),
                              child: Obx(
                                    () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "proofOfResidence"
                                    ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadingAnimationWidget.threeArchedCircle(
                                          color: kSecondary,
                                          size: 35
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                        style: appStyle(16, kDark, FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )
                                    : imageUploader.proofOfResidenceUrl.isEmpty
                                    ? Center(
                                  child: Text(
                                    "Photo of your house",
                                    style:
                                    appStyle(16, kDark, FontWeight.w600),
                                  ),
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    imageUploader.proofOfResidenceUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Obx(
                        () => controller.isLoading
                        ? Center(
                        child: LoadingAnimationWidget.waveDots(
                            color: kPrimary,
                            size: 35
                        ))
                        : CustomButton(

                        btnHieght: 37,
                        color: kPrimary,
                        text: "R E G I S T E R",
                        onTap: () {
                          final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
                          if(_firstNameController.text.isNotEmpty &&
                              _lastNameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              imageUploader.validIdUrl.isNotEmpty &&
                              imageUploader.proofOfResidenceUrl.isNotEmpty
                          ) {
                            if (_passwordController.text != _confirmPassword.text) {
                              setState(() {
                                _isConfirmPasswordError = true;
                              });
                              // Show an error if confirm password doesn't match
                              Get.snackbar("Password Mismatch", "Confirm password does not match the entered password.");
                              return;
                            }
                            if (!passwordRegex.hasMatch(_passwordController.text)) {
                              // Show an error if the password doesn't meet the criteria
                              Get.snackbar("Invalid Password", "Password must be at least 8 characters long, include 1 uppercase letter, 1 lowercase letter, and 1 number.");
                              return;
                            }

                            Registration model = Registration(
                                username: '${_firstNameController.text} ${_lastNameController.text}',
                                email: _emailController.text,
                                password: _passwordController.text,
                                validIdUrl: imageUploader.validIdUrl,
                                proofOfResidenceUrl: imageUploader.proofOfResidenceUrl,
                                phone: _phoneController.text,
                                phoneVerification: isOtpVerified
                            );

                            String userdata = registrationToJson(model);

                            controller.registration(userdata);
                          } else {
                            // Show an error if any field is empty
                            Get.snackbar("Incomplete Information", "Please fill in all fields.");
                          }
                        }),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          )
        ],
      )),),),
    );
  }
}
