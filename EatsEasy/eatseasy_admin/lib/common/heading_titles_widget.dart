import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/home_controller.dart';
import 'package:get/get.dart';

class HeadingTitlesWidget extends StatelessWidget {
  const HeadingTitlesWidget({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right : 8.0),
              child: Obx(
                () => SvgPicture.asset(
                  controller.image.value,
                  width: 15.w,
                  height: 15.h,
                ),
              ),
            ),
            
            ReusableText(
                text: title, style: appStyle(14, kDark, FontWeight.bold)),
          ],
        ),
        title == "Restaurants" ? GestureDetector(
          onTap: onTap,
          child: const Icon(
            Ionicons.search_circle,
            size: 24,
            color: kPrimary,
          ),
        ): title == "Categories" ? GestureDetector(
          onTap: onTap,
          child: const Icon(
            Ionicons.add_circle,
            size: 24,
            color: kPrimary,
          ),
        ) : const SizedBox.shrink()
      ],
    );
  }
}
