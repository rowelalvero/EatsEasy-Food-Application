import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchResturantMenu.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/views/food/widgets/food_tile.dart';

import '../../../models/restaurants.dart';

class RestaurantMenu extends HookWidget {
  const RestaurantMenu({
    super.key,
    required this.restaurant,
  });

  final Restaurants restaurant;
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchMenu(restaurant.id);
    final foods = hookResult.data??[];
    final isLoading = hookResult.isLoading;
   
    return Scaffold(
      backgroundColor: kLightWhite,
      body: isLoading
          ? const FoodsListShimmer()
          : Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              height: height * 0.7,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: foods.length,
                  itemBuilder: (context, i) {
                    Food food = foods[i];
                    return FoodTile(food: food);
                  }),
            ),
    );
  }
}
