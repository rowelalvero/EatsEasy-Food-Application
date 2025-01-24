import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_partner/hooks/fetchFoods.dart';
import 'package:eatseasy_partner/models/foods.dart';
import 'package:eatseasy_partner/views/food/food_page.dart';
import 'package:eatseasy_partner/views/home/widgets/empty_page.dart';
import 'package:eatseasy_partner/views/home/widgets/food_tile.dart';
import 'package:get/get.dart';

import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../../constants/constants.dart';

class FoodList extends HookWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchFood();
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    return Container(
      padding: const EdgeInsets.only(left: 12, top: 10, right: 12),
      height: 190.h,
      child: RefreshIndicator(
        color: kPrimary, // Set the color for the refresh indicator
        onRefresh: () async {
          refetch(); // Trigger the refetch when pull-to-refresh is invoked
        },
        child: foods!.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no_content.png',
                height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
                width: MediaQuery.of(context).size.width * 0.5,   // 50% of screen width
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              ReusableText(
                text: "No food items available.",
                style: appStyle(14, kGray, FontWeight.normal),
              ),
              ReusableText(
                text: "You can always add your menus!",
                style: appStyle(14, kGray, FontWeight.normal),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  refetch(); // Manually trigger the refetch
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Refresh Orders",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            Food food = foods[index];
            return CategoryFoodTile(
              onTap: () {
                Get.to(() => FoodPage(food: food)); // Navigate to food detail page
              },
              food: food,
            );
          },
        ),
      ),
    );
  }
}
