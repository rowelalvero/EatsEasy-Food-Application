import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/catergory_controller.dart';
import 'package:eatseasy/hooks/fetchCategory.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/views/food/food_page.dart';
import 'package:eatseasy/views/home/widgets/food_tile.dart';
import 'package:get/get.dart';

class CategoryFoodList extends HookWidget {
  const CategoryFoodList({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final hookResult =
        useFetchCategory(categoryController.categoryValue, "41007428");
    final foods = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    
    return isLoading
        ? const FoodsListShimmer()
        : Container(
            padding: EdgeInsets.only(left: 12.w, top: 10.h, right: 12.w),
            height: height,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  Food food = foods[index];
                  return CategoryFoodTile(
                    food: food,
                    onTap: () {
                      Get.to(
                          () => FoodPage(
                                food: food,
                              ));
                    },
                  );
                }),
          );
  }
}
