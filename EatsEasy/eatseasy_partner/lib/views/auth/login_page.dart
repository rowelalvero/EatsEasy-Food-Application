import 'package:eatseasy_partner/views/auth/widgets/forgot_password.dart';
import 'package:eatseasy_partner/views/auth/widgets/phone_verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/custom_btn.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/login_controller.dart';
import 'package:eatseasy_partner/models/login_request.dart';
import 'package:eatseasy_partner/views/auth/registration.dart';
import 'package:eatseasy_partner/views/auth/widgets/email_textfield.dart';
import 'package:eatseasy_partner/views/auth/widgets/password_field.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../../common/reusable_text.dart';
import '../home/widgets/back_ground_container.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>  {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: kOffWhite,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(top: 5.w),
          height: 50.h,
          child: Text(
            "EatsEasy Partner",
            style: appStyle(24, kPrimary, FontWeight.bold),
          ),
        ),
      ),*/
      body: Center(child: SizedBox(width: 640, child: BackGroundContainer(child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 30.h,
          ),
          //Lottie.asset('assets/anime/delivery.json'),
          Image.asset(
            'assets/images/welcomeImage.png',
            height: hieght / 2.5,
            width: width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  //email
                  EmailTextField(
                    focusNode: _passwordFocusNode,
                    hintText: "Email",
                    textCapitalization: TextCapitalization.sentences,
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

                  PasswordField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                  ),

                  SizedBox(
                    height: 6.h,
                  ),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ForgotPasswordPage());
                        },
                        child: Text('Forgot password',
                            style: appStyle(
                                12, Colors.black, FontWeight.normal)),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 12.h,
                  ),
                  //TextButton(onPressed: () {_showVerificationSheet(context);}, child: Text("Verification")),
                  Obx(
                        () => controller.isLoading
                        ? Center(
                      child: LoadingAnimationWidget.waveDots(
                          color: kPrimary,
                          size: 35
                      ),)
                        : CustomButton(
                        btnHieght: 37,
                        color: kPrimary,
                        text: "L O G I N",
                        onTap: () {
                          LoginRequest model = LoginRequest(
                              email: _emailController.text,
                              password: _passwordController.text);

                          String authData = loginRequestToJson(model);

                          controller.loginFunc(authData, model);
                        }),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Don't have an account?",
                            style: appStyle(
                                12, Colors.black, FontWeight.normal)
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => const RegistrationPage()),
                          child: Text(
                            "Register",
                            style: appStyle(
                                12, kPrimary, FontWeight.normal),
                          ),
                        )]),
                ],
              ),
            ),
          )
        ],
      ),),),)
    );
  }
}
