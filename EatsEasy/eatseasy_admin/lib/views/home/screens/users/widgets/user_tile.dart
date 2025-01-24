import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/common/verification_modal.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/users_model.dart';
import 'package:get/get.dart';

import '../user_page.dart';

class UserTile extends StatelessWidget {
  const UserTile(
      {super.key,
      required this.context,
      required this.user,
      required this.index});

  final BuildContext context;
  final User user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => UserDetailsPage(user: user,));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: 55,
        width: width,
        decoration: BoxDecoration(
            color: kOffWhite, borderRadius: BorderRadius.circular(9.r)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.profile),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: user.username,
                    style: appStyle(10, kGray, FontWeight.w500),
                  ),
                  ReusableText(
                    text: user.email,
                    style: appStyle(9, kGray, FontWeight.normal),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 70,
                height: 20,
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Center(
                  child: ReusableText(
                      text: user.userType,
                      style: appStyle(11, kLightWhite, FontWeight.w400)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void doNothing(BuildContext context) {
    showVerificationSheet(context);
  }
}
