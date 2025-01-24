import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/controllers/status_controller.dart';
import 'package:eatseasy_admin/hooks/fetch_restaurants.dart';
import 'package:eatseasy_admin/views/home/screens/restaurant/widgets/restaurant_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/app_style.dart';
import '../../../../../common/reusable_text.dart';
import '../../../../../constants/constants.dart';

class RejectedRestaurants extends HookWidget {
  const RejectedRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatusController());

    // Fetch all rejected restaurants at once (no pagination)
    final data = fetchRestaurants("Rejected", 1, 1000); // Adjust limit as necessary
    final restaurants = data.restaurants;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;
    controller.setData(data.refetch!);

    if (isLoading) {
      return const FoodsListShimmer();
    }

    if (restaurants!.isEmpty) {
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
              text: "No rejected restaurants found.",
              style: appStyle(14, kGray, FontWeight.normal),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Trigger a refresh to check for rejected restaurants
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

    // Wrap the ListView with RefreshIndicator to enable pull-to-refresh
    return RefreshIndicator(
      color: kPrimary,
      onRefresh: () async {
        // Trigger the refetch to reload the restaurant data
        await refetch!();
      },
      child: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          print("Rejected Restaurant: ${restaurant.title}");
          return RestaurantTile(restaurant: restaurant);
        },
      ),
    );
  }
}
