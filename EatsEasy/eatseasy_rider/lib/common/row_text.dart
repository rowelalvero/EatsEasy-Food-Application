import 'package:flutter/material.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';

class RowText extends StatelessWidget {
  const RowText(
      {super.key, required this.first, required this.second, this.color});

  final String first;
  final String second;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(text: first, style: appStyle(kFontSizeBodySmall, color ?? kDark , FontWeight.w500)),
        ReusableText(
            text: second,
            style: appStyle(kFontSizeBodySmall, color ?? kDark, color != null ? FontWeight.w400 : FontWeight.w400))
      ],
    );
  }
}
