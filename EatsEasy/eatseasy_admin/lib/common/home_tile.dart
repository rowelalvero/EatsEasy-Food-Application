import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.imagePath,
    required this.text,
    this.onTap,
  });

  final String imagePath;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Minimize the size of Column
        children: [
          SvgPicture.asset(
            fit: BoxFit.cover,
            imagePath,
            width: 30,
            height: 30,
          ),
          // Wrap the text in an Expanded widget
          Expanded(
            child: ReusableText(
              text: text,
              style: appStyle(8, kGray, FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
