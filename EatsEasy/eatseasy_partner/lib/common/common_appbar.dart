import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:get/get.dart';
import 'app_style.dart';

CommonAppBar({String? titleText,List<DropdownButton>? appBarActions, Container? appBarChild}){
  return AppBar(
    iconTheme: const IconThemeData(
      color: kWhite,
    ),
    elevation: 0,
    centerTitle: true,
    leading:appBarChild!=null?null: InkWell(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: kDark,
        )),

    title:appBarChild?? ReusableText(
        text: titleText!,
        style: appStyle(kFontSizeH4, kDark, FontWeight.w500)),
    backgroundColor: kOffWhite,
    actions: appBarActions,
  );
}