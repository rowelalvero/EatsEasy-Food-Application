// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/restaurants.dart';
import 'package:eatseasy_admin/views/restaurant/restaurant_page.dart';
import 'package:get/get.dart';


class RestaurantTile extends StatelessWidget {
  const RestaurantTile({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(() =>  RestaurantDetailsPage(restaurantId: restaurant.id));
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
                        width: 50,
                        height: 50,
                        child: Image.network(
                          restaurant.logoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
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
                          Flexible(
                            child: Text(
                              restaurant.coords.address,
                              overflow: TextOverflow.ellipsis,
                              style: appStyle(9, kGray, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

              ),
            ),
            Positioned(
              right: 5,
              top: 6,
              child: Container(
                width: 60,
                height: 19,
                decoration: BoxDecoration(
                    color:
                        restaurant.isAvailable || restaurant.isAvailable == null
                            ? kPrimary
                            : kSecondaryLight,
                    borderRadius: BorderRadius.circular(10)),
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
