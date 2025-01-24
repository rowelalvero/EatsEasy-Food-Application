// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/cached_image_loader.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/shimmers/categories_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/catergory_controller.dart';
import 'package:eatseasy/hooks/fetchCategories.dart';
import 'package:eatseasy/models/categories.dart';
import 'package:eatseasy/views/categories/more_categories.dart';
import 'package:get/get.dart';

class CategoriesWidget extends HookWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final hookResult = useFetchCategories();
    final categoryItems = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    return isLoading
        ? const CatergoriesShimmer()
        : Container(
            padding: const EdgeInsets.only(left: 12, top: 10),
            height: 80,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryItems.length,
                itemBuilder: (context, index) {
                  Categories category = categoryItems[index];
                  return GestureDetector(
                    onTap: () {
                      if (categoryController.categoryValue == category.id) {
                        categoryController.updateCategory = '';
                        categoryController.updateTitle = '';
                      } else if (category.value == 'more') {
                        Get.to(() => const AllCategories());
                      } else {
                        categoryController.updateCategory = category.id;
                        categoryController.updateTitle = category.title;
                      }
                    },
                    child: Obx(() => Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.only(top: 4),
                          width: 84.h,
                          height: 84.h,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: categoryController.categoryValue ==
                                          category.id
                                      ? kPrimary
                                      : kOffWhite,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 35,
                                child: CachedImageLoader(fit: BoxFit.cover, image: category.imageUrl, imageHeight: 35, imageWidth: 35,)
                              ),
                              ReusableText(
                                  text: category.title,
                                  style:
                                      appStyle(12, kDark, FontWeight.normal)),
                            ],
                          ),
                        )
                    ),
                  );
                }),
          );
  }
}
