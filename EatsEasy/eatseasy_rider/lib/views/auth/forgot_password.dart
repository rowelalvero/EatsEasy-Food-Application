import 'package:eatseasy_rider/views/auth/widgets/email_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../common/app_style.dart';
import '../../common/back_ground_container.dart';
import '../../common/custom_btn.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../controllers/change_password_controller.dart';
import '../../controllers/email_verification_controller.dart';
import '../../controllers/registration_controller.dart';
import '../../models/change_password.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =TextEditingController();
  late final TextEditingController _confirmPassword =TextEditingController();
  final changePasswordController = Get.put(ChangePasswordController());
  final emailVerificationController = Get.put(EmailVerificationController());
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kOffWhite,
          elevation: 0,
          title: Container(
            padding: EdgeInsets.only(top: 5.w),
            height: 50.h,
            child: Text(
              "Forgot password",
              style: appStyle(24, kDark, FontWeight.normal),
            ),
          ),
        ),
        body: Center(
            child: BackGroundContainer(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  pageSnapping: false,
                  children: [
                    //Lottie.asset('assets/anime/delivery.json'),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15.h,
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
                              height: 20.h,
                            ),

                            Obx(
                                  () => emailVerificationController.isLoading
                                  ? Center(
                                child: LoadingAnimationWidget.waveDots(
                                    color: kPrimary,
                                    size: 35
                                ),)
                                  : CustomButton(
                                  btnHieght: 37.h,
                                  color: kPrimary,
                                  text: "Send email OTP",
                                  onTap: () async {

                                    if (_emailController.text.isNotEmpty) {

                                      await emailVerificationController.sendVerificationEmail(_emailController.text,
                                        next: () {
                                          _pageController.animateToPage(1,
                                              duration: const Duration(milliseconds: 400),
                                              curve: Curves.easeInOut);
                                        },
                                      );
                                      //await changePasswordController.changePassword(password, _emailController.text);
                                    } else {
                                      Get.snackbar("Invalid email", "Please check your email");
                                    }
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:
                        ListView(children: [
                          SizedBox(
                            height: 100.h,
                          ),
                          //Lottie.asset('assets/anime/delivery.json'),
                          SizedBox(
                            height: 30.h,
                          ),
                          ReusableText(
                              text: "Verify Your Account",
                              style: appStyle(20, kPrimary, FontWeight.bold)),
                          Text(
                              "Enter the code sent to your email, if you did not send receive the code, click resend",
                              style: appStyle(10, kGrayLight, FontWeight.normal)),
                          SizedBox(
                            height: 20.h,
                          ),
                          OTPTextField(
                            length: 6,
                            width: width,
                            fieldWidth: 50.h,
                            style: const TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onChanged: (pin) {},
                            onCompleted: (pin) {
                              changePasswordController.code = pin;
                              changePasswordController.email = _emailController.text;
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Obx(() => emailVerificationController.isLoading
                              ? Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: kSecondary,
                                size: 35
                            ),)
                              : CustomButton(
                            onTap: () async {
                              await emailVerificationController.sendVerificationEmail(_emailController.text);
                            },
                            color: kSecondary,
                            text: "Resend",
                            btnHieght: 40.h,
                          )),
                          SizedBox(
                            height: 15.h,
                          ),
                          Obx(() => changePasswordController.isLoading
                              ? Center(
                            child: LoadingAnimationWidget.waveDots(
                                color: kPrimary,
                                size: 35
                            ),)
                              : CustomButton(
                            onTap: () async {
                              await changePasswordController.verifyEmail(
                                next: () {
                                  _pageController.animateToPage(2,
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut);
                                },
                                back: () {
                                  _pageController.previousPage(
                                      duration:
                                      const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut);
                                },
                              );


                            },
                            color: kPrimary,
                            text: "Verify Account",
                            btnHieght: 40.h,
                          ))
                        ]
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          children: [
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
                                isDense: true,
                                labelStyle: appStyle(16, kGray, FontWeight.normal),
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
                              height: 20.h,
                            ),
                            Obx(
                                  () => changePasswordController.isLoading
                                  ? Center(
                                child: LoadingAnimationWidget.waveDots(
                                    color: kPrimary,
                                    size: 35
                                ),)
                                  : CustomButton(
                                btnHieght: 37.h,
                                color: kPrimary,
                                text: "Confirm",
                                onTap: () async {
                                  // Regular expression for password validation
                                  final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

                                  if (_emailController.text.isNotEmpty &&
                                      _passwordController.text.isNotEmpty &&
                                      _confirmPassword.text.isNotEmpty) {

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

                                    // If validations are passed, proceed with the API call
                                    ChangePassword model = ChangePassword(
                                      password: _passwordController.text,
                                      email: _emailController.text,
                                    );

                                    String password = changePasswordToJson(model);
                                    await changePasswordController.changePassword(password, _emailController.text);
                                  } else {
                                    // Show an error if any field is empty
                                    Get.snackbar("Incomplete Information", "Please fill in all fields.");
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}
