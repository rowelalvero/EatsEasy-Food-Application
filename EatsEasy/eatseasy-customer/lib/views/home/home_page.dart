import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/views/home/widgets/restaurant_opt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/custom_appbar.dart';
import 'package:eatseasy/common/custom_container.dart';
import 'package:eatseasy/common/heading.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/catergory_controller.dart';
import 'package:eatseasy/views/home/all_nearby_restaurants.dart';
import 'package:eatseasy/views/home/fastest_foods_page.dart';
import 'package:eatseasy/views/home/recommendations.dart';
import 'package:eatseasy/views/home/widgets/categories_list.dart';
import 'package:eatseasy/views/home/widgets/category_foodlist.dart';
import 'package:eatseasy/views/home/widgets/food_list.dart';
import 'package:eatseasy/views/home/widgets/nearby_restaurants.dart';
import 'package:get/get.dart';

import '../entrypoint.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final reloadTrigger = useState(0);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(130.h),
          child: const CustomAppBar()
      ),
      body: Center(
        child: BackGroundContainer(
            child: RefreshIndicator(
              color: kPrimary,
              onRefresh: () async {
                //Get.off(() =>  const MainScreen());
              },
              child: ListView(
                padding: EdgeInsets.zero, // Ensure no padding for ListView
                children: [
                  const CategoriesWidget(),
                  Obx(
                        () => categoryController.categoryValue == ''
                        ? Column(
                      children: [
                        /*HomeHeading(
                      heading: "Pick Restaurants",
                      restaurant: true,
                    ),
                        const RestaurantOptions(),*/
                        HomeHeading(
                          heading: "Nearby Restaurants",
                          onTap: () {
                            Get.to(() => const AllNearbyRestaurants());
                          },
                        ),
                        const NearbyRestaurants(),
                        HomeHeading(
                          heading: "Try Something New",
                          onTap: () {
                            Get.to(() => const Recommendations());
                          },
                        ),
                        const FoodList(),
                        HomeHeading(
                          heading: "Fastest food closer to you",
                          onTap: () {
                            Get.to(() => const FastestFoods());
                          },
                        ),
                        const FoodList(),
                        SizedBox(height: 20,)
                      ],
                    )
                        : Column(
                      children: [
                        HomeHeading(
                          heading: "Explore ${categoryController.titleValue} Category",
                          restaurant: true,
                        ),
                        const CategoryFoodList(),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
