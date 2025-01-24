import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/custom_container.dart';
import 'package:eatseasy_partner/constants/constants.dart';

class NoSelection extends StatelessWidget {
  const NoSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
        elevation: 0,
      ),
      body: Center(child: BackGroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/delivery.png',
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setHeight(200),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                "No selected orders",
                style: appStyle(20, kDark, FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
