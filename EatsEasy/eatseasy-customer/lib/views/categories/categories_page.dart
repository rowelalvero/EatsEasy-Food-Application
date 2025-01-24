  import 'package:flutter/material.dart';
  import 'package:flutter_hooks/flutter_hooks.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:eatseasy/common/app_style.dart';
  import 'package:eatseasy/common/back_ground_container.dart';
  import 'package:eatseasy/common/not_found.dart';
  import 'package:eatseasy/common/reusable_text.dart';
  import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
  import 'package:eatseasy/constants/constants.dart';
  import 'package:eatseasy/hooks/fetchFoodByCategory.dart';
  import 'package:eatseasy/models/categories.dart';
  import 'package:eatseasy/models/foods.dart';
  import 'package:eatseasy/views/food/food_page.dart';
  import 'package:eatseasy/views/home/widgets/food_tile.dart';
  import 'package:get/get.dart';
  import 'package:loading_animation_widget/loading_animation_widget.dart';

  class CategoriesPage extends HookWidget {
    const CategoriesPage({super.key, required this.category});

    final Categories category;

    @override
    Widget build(BuildContext context) {
      final hookResult = useFetchFoodByCategory(category.id, "41007428");
      final foods = hookResult.data;
      final isLoading = hookResult.isLoading;
      if (hookResult.isLoading) {
        return Center(child: LoadingAnimationWidget.waveDots(
          color: kPrimary,
          size: 35
        ));
      }

      if (hookResult.error != null) {
        return NotFoundPage();
      }

      if (hookResult.data == null) {
        return Center(child: Text('No data available'));
      }
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: kOffWhite,
          title: ReusableText(
              text: category.title, style: appStyle(20, kDark, FontWeight.w400),),
        ),

        body: Center(
          child: BackGroundContainer(
              child: isLoading
                  ? const FoodsListShimmer()
                  : Container(
                padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
              )),
        ),
      );
    }
  }
