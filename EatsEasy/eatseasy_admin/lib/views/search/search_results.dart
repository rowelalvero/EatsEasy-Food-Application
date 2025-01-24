import 'package:flutter/material.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/controllers/search_results_controller.dart';
import 'package:eatseasy_admin/views/search/widgets/restaurant_tile.dart';
import 'package:get/get.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RestaurantSearchController());

    return Obx(() {
      if (controller.isLoading) {
        return const FoodsListShimmer();
      }

      if (controller.apiError != null) {
        return Center(
          child: Text(controller.apiError!.message),
        );
      }

      if (controller.searchResults == null) {
        return const Center(
          child: Text("No restaurants found"),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: List.generate(controller.searchResults!.length, (index) {
            final restaurant = controller.searchResults![index];
            return RestaurantTile(restaurant: restaurant);
          }),
        ),
      );
    });
  }
}
