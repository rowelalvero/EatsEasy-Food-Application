import 'package:eatseasy/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchAllNearbyRestaurants.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:eatseasy/views/home/widgets/restaurant_tile.dart';
import 'package:get/get.dart';

import '../../controllers/address_controller.dart';
import '../../models/distance_time.dart';
import '../../services/distance.dart';
import '../profile/saved_places.dart';

class AllNearbyRestaurants extends HookWidget {
  const AllNearbyRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllRestaurants("");
    final controller = Get.put(AddressController());
    final restaurants = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    final refetch = hookResult.refetch;
    DistanceTime? distanceTime;
    return Scaffold(
      backgroundColor: kLightWhite,
      appBar: AppBar(
        elevation: .4,
        backgroundColor: kLightWhite,
        centerTitle: true,
        /*actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.grid_view),
          ),
        ],*/
        title: ReusableText(
          text: "Nearby Restaurants",
          style: appStyle(20, kDark, FontWeight.w400),
        ),
      ),
      body: Center(child: BackGroundContainer(child:  RefreshIndicator(
        color: kPrimary,
        onRefresh: () async {
          refetch();
        },
        child: isLoading
            ? const FoodsListShimmer()
            : error != null
            ? Center(child: Text('Error: ${error.toString()}'))
            : (restaurants == null || restaurants.isEmpty)
            ? const Center(child: Text('No nearby restaurants found'))
            : ListView.builder(
          padding: EdgeInsets.symmetric(
              horizontal: 12.w, vertical: 10.h),
          itemCount: restaurants.length,
          itemBuilder: (context, i) {
            Restaurants restaurant = restaurants[i];

            if (controller.defaultAddress != null) {
              Distance distanceCalculator = Distance();
              distanceTime = distanceCalculator.calculateDistanceTimePrice(
                controller.defaultAddress!.latitude,
                controller.defaultAddress!.longitude,
                restaurant.coords.latitude,
                restaurant.coords.longitude,
                35,
                pricePkm,
              );
            }
            if (controller.defaultAddress == null) {
              _showVerificationDialog(context);
              return SizedBox.shrink();  // Return empty widget until user takes action
            } else {
              if (distanceTime != null && distanceTime!.distance <= 10.0) {
                return RestaurantTile(restaurant: restaurant);
              } else {
                return RestaurantTile(restaurant: restaurant);
              }// Return FoodTile if address is available
            }


          },
        ),
      ),),)
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
