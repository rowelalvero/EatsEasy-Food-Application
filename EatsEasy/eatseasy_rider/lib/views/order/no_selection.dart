import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/custom_container.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';

class NoSelection extends StatelessWidget {
  const NoSelection({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          backgroundColor: kOffWhite,
          elevation: 0,
          
        ),
        body: Center(
          child: BackGroundContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/delivery.png',
                  height: height / 3,
                  width: width,
                ),
                SizedBox(
                  height: 20 ,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ReusableText(
                      text: "No selected orders",
                      style: appStyle(20, kDark, FontWeight.bold)),
                ),
                
              ],
            ),
          ),
        ));
  }
}
