import 'package:eatseasy/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/custom_container.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/views/auth/login_page.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginRedirection extends StatelessWidget {
  const LoginRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightWhite,
        elevation: 0.3,
        title: ReusableText(
          text: "Please login to access this page", style: appStyle(20, kDark, FontWeight.w400),),
      ),
      body: Center(
        child: SizedBox(width: 640, child: BackGroundContainer(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    /*Container(
                      width: width,
                      height: height / 2,
                      color: Colors.white,
                      child: LottieBuilder.asset(
                        "assets/anime/delivery.json",
                        width: width,
                        height: height / 2,
                      ),
                    ),*/
                    Image.asset(
                      'assets/images/welcomeImage.png',
                      height: height / 3,
                      width: width,
                    ),
                    CustomButton(
                        onTap: () {
                          Get.to(() => const Login());
                        },
                        color: kPrimary,
                        btnHieght: 37.h,
                        text: "L O G I N"
                    )
                  ],
                ),
              )
            ],
          ),
        ),)
      ),
    );
  }
}
