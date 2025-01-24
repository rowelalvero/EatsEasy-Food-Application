import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/constants/constants.dart';

// ignore: must_be_immutable
class CustomContainer extends StatelessWidget {
  CustomContainer({
    super.key,
    this.containerContent,
  });

  Widget? containerContent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height ,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.r),
              bottomRight: Radius.circular(0.r)),
          child: Container(
            width: width,
            color: kOffWhite,
            child: SingleChildScrollView(child: containerContent),
          ),
        ));
  }
}
