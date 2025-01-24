import 'package:eatseasy/models/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/search_controller.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/views/food/widgets/food_tile.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../home/widgets/restaurant_tile.dart';

class RestoSearchResults extends StatelessWidget {
  const RestoSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(FoodSearchController());
    return Container(
      color: searchController.restaurantSearchResults!.isEmpty|| searchController.restaurantSearchResults == null ? kLightWhite : Colors.white,
      padding:  EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
      height: height,
      child: searchController.restaurantSearchResults!.isNotEmpty ? ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          itemCount: searchController.restaurantSearchResults!.length,
          itemBuilder: (context, index) {
            Restaurants resto = searchController.restaurantSearchResults![index];
            return RestaurantTile(restaurant: resto);
          }): Padding(
        padding:  EdgeInsets.only(bottom:180.0.h),
        child: LottieBuilder.asset("assets/anime/delivery.json", width: width, height: height/2,),
      ),
    );
  }
}
