import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/driver_controller.dart';
import 'package:eatseasy_rider/controllers/login_controller.dart';
import 'package:eatseasy_rider/views/auth/login_page.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final driverController = Get.put(DriverController());
    final controller = Get.put(LoginController());
    driverController.driver = controller.getDriverData();
    return Scaffold(
        body: Center(child: BackGroundContainer(child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 200.h, 24.w, 0),
              child: ListView(
                children: [
                  Image.asset(
                    'assets/images/welcomeImage.png',
                    height: height / 3,
                    width: width,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                          text: "Status: ${driverController.driver!.verification }",
                          style: appStyle(14, kGray, FontWeight.bold)),

                      GestureDetector(
                        onTap: () {
                          Get.to(
                                () => const Login(),
                          );
                        },
                        child: ReusableText(
                            text: "Try Login",
                            style: appStyle(14, kTertiary, FontWeight.bold)),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10.h,
                  ),

                  driverController.driver!.verification == 'Pending'
                      ?
                  SizedBox(
                    width: width * 0.8,
                    child: Text(
                      "Please allow up to 3-5 days for your verification to be processed. You will receive an email once your verification is complete.",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: kGray,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  )
                      :
                  SizedBox(
                    width: width * 0.8,
                    child: Text(
                      "Your application is rejected. Please provide a valid requirements and try again.",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: kGray,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            )),),)
    );
  }
}
