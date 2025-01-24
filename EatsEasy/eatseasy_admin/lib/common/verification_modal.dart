 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/custom_btn.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';

Future<dynamic> showVerificationSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxHeight: hieght*0.88.h,
        ),
        isScrollControlled: true,
        isDismissible: false,
        showDragHandle: true,
        builder: (BuildContext context) {
          return Container(
            height: hieght.h,
            width: width,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/restaurant_bk.png"),
                  fit: BoxFit.fill),
              color: kLightWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  ReusableText(
                      text: "Verify Your Phone Number",
                      style: appStyle(18, kPrimary, FontWeight.w600)),
                  SizedBox(
                      height: 250.h,
                      child: Container(),),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                    text: "Verify  Phone Number",
                    btnHieght: 35.h,
                    onTap: () {
                      
                    },
                  )
                ],
              ),
            ),
          );
        });
  }