import 'package:eatseasy/models/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/views/food/food_page.dart';
import 'package:get/get.dart';

class FoodTile extends StatelessWidget {
  const FoodTile({
    super.key,
    required this.food,
  });

  final Food food;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {
        if(food.isAvailable == true) {
          Get.to(() => FoodPage(food: food));
        } else if (food.isAvailable != true) {
          Get.snackbar("Item sold out...",
              "Please come and check later",
              icon: const Icon(Icons.add_alert));
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
            height: 80,
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
                              food.imageUrl[0],
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 6, bottom: 2),
                              color: kGray.withOpacity(0.6),
                              height: 16,
                              width: width,
                              child: RatingBarIndicator(
                                rating: double.tryParse(food.rating.toString()) ?? 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),

                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: food.title,
                          style: appStyle(11, kDark, FontWeight.w400)),
                      ReusableText(
                          text: "Delivery time: ${food.time} mins",
                          style: appStyle(9, kGray, FontWeight.w400)),
                      /*ReusableText(
                          text: "Category: ${food.isAvailable}",
                          style: appStyle(9, kGray, FontWeight.w400)),*/
                      const SizedBox(
                        height: 5,
                      ),
                      /*SizedBox(
                        height: 18,
                        width: width * 0.5,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: food.additives.length,
                            itemBuilder: (context, i) {
                              final addittives = food.additives[i];
                              return Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: const BoxDecoration(
                                    color: kSecondaryLight,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ReusableText(
                                        text: addittives.title,
                                        style: appStyle(
                                            8, kGray, FontWeight.w400)),
                                  ),
                                ),
                              );
                            }),
                      ),*/
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 6.h,
            child: Container(
              width: 80.h,
              height: 23.h,
              decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: ReusableText(
                  text: "Php ${food.price.toStringAsFixed(2)}",
                  style: appStyle(12, kLightWhite, FontWeight.bold),
                ),
              ),
            ),
          ),
          /*Positioned(
              right: 70.h,
              top: 6.h,
              child: Container(
                width: 23.w,
                height: 23.h,
                decoration:  BoxDecoration(
                    color: kSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(50.r))),
                child: GestureDetector(
                  onTap: () {
                   
                  },
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.cart_plus,
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
