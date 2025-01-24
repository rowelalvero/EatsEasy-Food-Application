import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/custom_btn.dart';
import 'package:eatseasy_admin/common/custom_container.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginRedirection extends StatelessWidget {
  const LoginRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kLightWhite,
        elevation: 0.3,
        title: ReusableText(
            text: "Please login to access this page", style: appStyle(12, kDark, FontWeight.w500)),
      ),
      body: Center(
        child: SizedBox(width: 640, child: BackGroundContainer(
            child: Column(
              children: [
                Container(
                  width: width,
                  height: hieght / 2,
                  color: Colors.white,
                  child: Image.asset(
                    'assets/images/frontImage.png',
                    width: width,
                    height: hieght / 2,
                  ),/*LottieBuilder.asset(
                    "assets/anime/delivery.json",
                    width: width,
                    height: hieght / 2,
                  ),*/
                ),
                CustomButton(
                    onTap: () {
                      Get.to(() => const Login());
                    },
                    color: kPrimary,
                    btnHieght: 40.h,
                    btnWidth: width - 20.w,
                    text: "L O G I N")
              ],
            )),)
      ),
    );
  }
}
