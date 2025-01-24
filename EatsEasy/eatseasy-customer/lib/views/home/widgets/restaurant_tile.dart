// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:eatseasy/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({
    super.key,
    required this.restaurant,
  });

  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (restaurant.isAvailable == true) {
          Get.to(() => RestaurantPage(restaurant: restaurant));
        } else {
          Get.snackbar("Restaurant is closed for now",
              "Please come back later",
              icon: const Icon(Icons.add_alert));
        }
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 70,
            width: width,
            decoration: const BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 75,
                          width: 85,
                          child: Image.network(
                            restaurant.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              padding:
                              const EdgeInsets.only(left: 6, bottom: 2),
                              color: kGray.withOpacity(0.6),
                              height: 16,
                              width: width,
                              child: RatingBarIndicator(
                                rating: restaurant.rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded( // Ensure the remaining space is distributed dynamically
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        ReusableText(
                          text: restaurant.title!,
                          style: appStyle(11, kDark, FontWeight.w400),
                        ),
                        ReusableText(
                          text: "Open hours: ${restaurant.time}",
                          style: appStyle(9, kGray, FontWeight.w400),
                        ),
                        Text(
                          restaurant.coords.address,
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          maxLines: 3, // Limit to one line
                          style: appStyle(9, kGray, FontWeight.w400),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),

            ),
          ),
          Positioned(
            right: 5,
            top: 6.h,
            child: Container(
              width: 60.h,
              height: 19.h,
              decoration: BoxDecoration(
                  color: restaurant.isAvailable == true ||
                          restaurant.isAvailable == null
                      ? kPrimary
                      : kGray,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: ReusableText(
                  text: restaurant.isAvailable == null ||
                          restaurant.isAvailable == true
                      ? "OPEN"
                      : "CLOSED",
                  style: appStyle(12, kLightWhite, FontWeight.bold),
                ),
              ),
            ),
          ),
          /*Positioned(
              right: 70.h,
              top: 6.h,
              child: Container(
                width: 19.h,
                height: 19.h,
                decoration: const BoxDecoration(
                    color: kSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () {},
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.shopping_outline,
                      size: 15,
                      color: kLightWhite,
                    ),
                  ),
                ),
              )
          )*/
        ],
      ),
    );
  }
}
