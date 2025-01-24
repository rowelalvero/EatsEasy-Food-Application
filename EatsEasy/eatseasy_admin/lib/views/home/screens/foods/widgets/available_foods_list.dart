import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/hooks/fetch_foods.dart';
import 'package:eatseasy_admin/models/foods.dart';
import 'package:eatseasy_admin/views/home/screens/foods/widgets/food_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/app_style.dart';
import '../../../../../common/reusable_text.dart';
import '../../../../../constants/constants.dart';

class AvailableFoodlist extends HookWidget {
  const AvailableFoodlist({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all available foods at once (no pagination)
    final data = fetchFood(1, 1000, true); // Fetch a larger limit for all available foods
    final foods = data.foods;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    if (foods == null) {
      return Center(
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
              text: "No foods found.",
              style: appStyle(14, kGray, FontWeight.normal),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Trigger a refresh to check for cancelled orders
                refetch!();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return const Center(
        child: Text("An error occurred"),
      );
    }

    if (foods.isEmpty) {
      return Center(
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
              text: "No available foods found.",
              style: appStyle(14, kGray, FontWeight.normal),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Trigger a refresh to check for cancelled orders
                refetch!();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Display the list of all available foods without pagination
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: RefreshIndicator(
        color: kPrimary,  // Color of the refresh indicator
        onRefresh: () async {
          // Trigger the refetch to reload the foods when pulled
          await refetch!();
        },
        child: ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            Food food = foods[index];
            return FoodTile(food: food);
          },
        ),
      ),
    );
  }
}
