import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../common/app_style.dart';
import '../../common/back_ground_container.dart';
import '../../common/custom_btn.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../controllers/change_password_controller.dart';
import '../../controllers/email_verification_controller.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final changePasswordController = Get.put(ChangePasswordController());
    final emailVerificationController = Get.put(EmailVerificationController());
    final box = GetStorage();
    String email = box.read('email');
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: BackGroundContainer(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0), child: ListView(children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  Image.asset(
                    'assets/images/welcomeImage.png',
                    height: height / 3,
                    width: width,
                  ),
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
                      changePasswordController.email = email;
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
                      await emailVerificationController.sendVerificationEmail(email);
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
                      await changePasswordController.verifyEmail();
                    },
                    color: kPrimary,
                    text: "Verify Account",
                    btnHieght: 40.h,
                  ))
                ]),)
            )
        ));
  }
}
