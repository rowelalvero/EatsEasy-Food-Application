import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/search_controller.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/views/food/widgets/food_tile.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../common/app_style.dart';
import '../../common/reusable_text.dart';
import '../../hooks/fetchNearbyRestaurants.dart';
import '../../models/restaurants.dart';


class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(FoodSearchController());
    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.only(left: 12.w, right: 12.w),
        child: Column(
          children: [

            if (searchController.foodSearchResults!.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true, // Constrains the height of the ListView
                padding: EdgeInsets.zero,
                itemCount: searchController.foodSearchResults!.length,
                itemBuilder: (context, index) {
                  Food food = searchController.foodSearchResults![index];
                  return FoodTile(food: food);
                },
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_content.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    ReusableText(
                      text: "No results.",
                      style: appStyle(14, kGray, FontWeight.normal),
                    ),
                  ],
                ),
              ),
          ],
        ),
      )
    );
  }
}

