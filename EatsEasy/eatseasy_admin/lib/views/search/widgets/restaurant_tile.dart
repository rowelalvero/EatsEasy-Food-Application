// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/search_model.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({super.key, required this.restaurant});

  final SearchModel restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Get.to(() =>  RestaurantPage(restaurant: restaurant));
        },
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              height: 65.h,
              width: width,
              decoration: BoxDecoration(
                  color: kOffWhite, borderRadius: BorderRadius.circular(9.r)),
              child: Container(
                padding: EdgeInsets.all(4.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25.r)),
                      child: SizedBox(
                        width: 50.w,
                        height: 50.h,
                        child: Image.network(
                          restaurant.logoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          text: restaurant.title,
                          style: appStyle(11, kDark, FontWeight.w400),
                        ),
                        ReusableText(
                          text: "Delivery time: ${restaurant.time}",
                          style: appStyle(11, kGray, FontWeight.w400),
                        ),
                        SizedBox(
                          width: width * 0.65,
                          child: Text(
                            restaurant.coords.address,
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(9, kGray, FontWeight.w400),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 5.w,
              top: 6.h,
              child: Container(
                width: 60.w,
                height: 19.h,
                decoration: BoxDecoration(
                    color:
                        restaurant.isAvailable || restaurant.isAvailable == null
                            ? kPrimary
                            : kSecondaryLight,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Center(
                  child: ReusableText(
                      text: restaurant.isAvailable == true ||
                              restaurant.isAvailable == null
                          ? "Open"
                          : "Closed",
                      style: appStyle(12, kLightWhite, FontWeight.w600)),
                ),
              ),
            )
          ],
        ));
  }
}
