import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/location_controller.dart';
import 'package:eatseasy/controllers/login_controller.dart';
import 'package:get/get.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final location = Get.put(UserLocationController());
    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:4.h),
                  child: Text(location.country, style: appStyle(12, kDark, FontWeight.normal)),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Icon(
                    SimpleLineIcons.settings,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
