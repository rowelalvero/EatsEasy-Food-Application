import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchRecommendations.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/views/food/widgets/food_tile.dart';
import 'package:get/get.dart';

import '../../controllers/address_controller.dart';
import '../../hooks/fetchNearbyRestaurants.dart';
import '../../models/distance_time.dart';
import '../../models/restaurants.dart';
import '../../services/distance.dart';
import '../profile/saved_places.dart';

class FastestFoods extends HookWidget {
  const FastestFoods({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRecommendations("3023", true);
    final controller = Get.put(AddressController());

    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error; // Capture error if any
    final refetch = hookResult.refetch;

    final hookRestaurantResult = useFetchRestaurants();
    final restaurants = hookRestaurantResult.data;

    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        elevation: .4,
        centerTitle: true,
        backgroundColor: kLightWhite,
        title: ReusableText(
          text: "Fastest Food",
          style: appStyle(20, kDark, FontWeight.w400),
        ),
      ),
      body: RefreshIndicator(
        color: kPrimary,
        onRefresh: () async {
          refetch();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          height: height,
          child: isLoading
              ? const FoodsListShimmer()
              : error != null
              ? Center(child: Text('Error: ${error.toString()}'))
              : (foods == null || foods.isEmpty)
              ? const Center(child: Text('No fastest foods available'))
              : ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: foods.length, // Use the smaller length
            itemBuilder: (context, i) {
              Food food = foods[i];

              // Check if the default address is null
              if (controller.defaultAddress == null) {
                _showVerificationDialog(context);
                return SizedBox.shrink();  // Return empty widget until user takes action
              } else {
                return FoodTile(food: food);  // Return FoodTile if address is available
              }
            },
          ),
        ),
      ),
    );
  }
  // Function to show the popup
  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User has to press the button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Address Required"),
          content: const Text("Please add an address to continue."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();

                // Navigate to the SavedPlaces page
                Get.to(() => const SavedPlaces());
              },
              child: const Text("Go to Saved Places"),
            ),
          ],
        );
      },
    );
  }
}
