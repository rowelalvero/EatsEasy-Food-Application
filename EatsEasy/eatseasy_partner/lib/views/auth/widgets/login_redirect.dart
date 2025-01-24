import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/custom_btn.dart';
import 'package:eatseasy_partner/common/custom_container.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/views/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginRedirection extends StatelessWidget {
  const LoginRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
        elevation: 0.3,
        title: ReusableText(
            text: "Please login to access this page", style: appStyle(12, kDark, FontWeight.w500)),
      ),
      body: Center(
        child: SizedBox(width: 640, child: BackGroundContainer(child: ListView(
          children: [
            Image.asset(
              'assets/images/welcomeImage.png',
              height: hieght / 2.5,
              width: width,
            ),
            /*Container(
              width: width,
              height: hieght / 2,
              color: Colors.white,
              child: LottieBuilder.asset(
                "assets/anime/delivery.json",
                width: width,
                height: hieght / 2,
              ),
            ),*/
            CustomButton(
                onTap: () {
                  Get.to(() => const Login());
                },
                color: kPrimary,
                btnHieght: 40,
                btnWidth: width - 20,
                text: "L O G I N")
          ],
        ),)),
      ),
    );
  }
}
