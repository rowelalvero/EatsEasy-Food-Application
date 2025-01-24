import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/views/home/widgets/food_widget.dart';
import 'package:eatseasy/common/shimmers/nearby_shimmer.dart';
import 'package:eatseasy/hooks/fetchFoods.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/views/food/food_page.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../constants/uidata.dart';
import '../../../controllers/address_controller.dart';

class FoodList extends HookWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());

    // Fetching foods data
    final hookResult = useFetchFood();
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    final refetch = hookResult.refetch;

    if (isLoading) {
      return const NearbyShimmer();
    }

    if (error != null) {
      return Center(child: Text('Error: ${error.toString()}'));
    }

    if (foods == null || foods.isEmpty) {
      return const Center(child: Text('No foods available'));
    }

    return Container(
      padding: const EdgeInsets.only(left: 12, top: 10),
      height: 180.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(foods.length, (index) {
            Food food = foods[index];

            return FoodWidget(
              onTap: () {
                if (food.isAvailable == true) {
                  Get.to(() => FoodPage(food: food));
                } else {
                  Get.snackbar(
                    "Item unavailable",
                    "Please come and check later",
                    icon: const Icon(Icons.add_alert),
                  );
                }
              },
              image: food.imageUrl[0],
              title: food.title,
              price: food.price.toStringAsFixed(2),
              time: food.time!,
            );
          }),
        ),
      ),
    );
  }
}
