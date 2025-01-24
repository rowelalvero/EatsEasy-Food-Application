import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/hooks/fetch_restaurants.dart';
import 'package:eatseasy_admin/views/home/screens/restaurant/widgets/restaurant_tile.dart';

class VerifiedRestaurants extends HookWidget {
  const VerifiedRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final data = fetchRestaurants("Verified", 1, 5);
    final restaurants = data.restaurants;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    if (restaurants!.isEmpty) {
      return const Center(
        child: Text("No restaurants found"),
      );
    }

    if (error != null) {
      return const Center(
        child: Text("An error occurred"),
      );
    }

    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return RestaurantTile(restaurant: restaurant);
      },
    );
  }
}
