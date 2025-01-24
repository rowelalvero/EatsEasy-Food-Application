import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.keyboardType,
      this.validator,
      this.suffixIcon,
      this.obscureText,
      this.onEditingComplete, this.maxLines});

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool? obscureText;
  final int? maxLines;
  final void Function()? onEditingComplete;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.h),
      padding: EdgeInsets.only(left: 8.h),
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.3,
            color: kGray,
          ),
          borderRadius: BorderRadius.all(Radius.circular(9.r))),
      child: TextFormField(
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        onEditingComplete: onEditingComplete,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: appStyle(11, kGray, FontWeight.normal),
            border: InputBorder.none),
        controller: controller,
        cursorHeight: 20,
        style: appStyle(11, kDark, FontWeight.normal),
        validator: validator,
      ),
    );
  }
}
