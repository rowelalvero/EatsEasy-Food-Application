import 'package:flutter/material.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, this.color, this.onTap, this.btnWidth, this.radius, this.btnHieght});

  final String text;
  final Color? color;
  final double? btnWidth;
  final double? btnHieght;
  final double? radius;
  final void Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: btnWidth ?? width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 14.0),
          backgroundColor: color ?? kSecondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius??12),
          ),
          elevation: 2.0,
        ),
        child: Text(text, style: appStyle(14,  kLightWhite, FontWeight.w500)),),
    );
  }
}
