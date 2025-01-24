import 'package:flutter/material.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';

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
        Expanded(
          child: ReusableText(text: first, style: appStyle(kFontSizeBodySmall, color ?? kGray , FontWeight.w500)),
        ),
        Expanded(child: SizedBox(
          child: Text(
              second,
              style: appStyle(kFontSizeBodySmall, color ?? kGray, color != null ? FontWeight.w400 : FontWeight.w400)),
        ))
      ],
    );
  }
}
