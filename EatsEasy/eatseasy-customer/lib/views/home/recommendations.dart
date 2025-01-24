import 'dart:math';

import 'package:eatseasy/common/back_ground_container.dart';
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

class Recommendations extends HookWidget {
  const Recommendations({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRecommendations("3023", true);
    final controller = Get.put(AddressController());
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    final refetch = hookResult.refetch;

    final hookRestaurantResult = useFetchRestaurants();
    final restaurants = hookRestaurantResult.data;

    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        elevation: .4,
        centerTitle: true,
        backgroundColor: kLightWhite,
        /*actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view),
          ),
        ],*/
        title: ReusableText(
          text: "Recommendations",
          style: appStyle(20, kDark, FontWeight.w400),
        ),
      ),
      body: Center(child: BackGroundContainer(child: RefreshIndicator(
        color: kPrimary,
        onRefresh: () async {
          // Trigger the refetch function to reload the recommendations
          refetch();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: isLoading
              ? const FoodsListShimmer()
              : error != null
              ? Center(child: Text('Error: ${error.toString()}'))
              : (foods == null || foods.isEmpty)
              ? const Center(child: Text('No recommendations available'))
              : ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: foods.length,
            itemBuilder: (context, i) {
              Food food = foods[i];
              /*Restaurants restaurant = restaurants[i];

              Distance distanceCalculator = Distance();
              DistanceTime distanceTime = distanceCalculator.calculateDistanceTimePrice(
                controller.defaultAddress!.latitude,
                controller.defaultAddress!.longitude,
                restaurant.coords.latitude,
                restaurant.coords.longitude,
                35,
                pricePkm,
              );

              if (distanceTime.distance > 10.0) {
                return SizedBox.shrink();
              }*/
              if (controller.defaultAddress == null) {
                _showVerificationDialog(context);
                return SizedBox.shrink();  // Return empty widget until user takes action
              } else {
                return FoodTile(food: food); // Return FoodTile if address is available
              }

            },
          ),
        ),
      )),),
    );
  }
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
