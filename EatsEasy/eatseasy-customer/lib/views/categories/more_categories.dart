import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchAllCategories.dart';
import 'package:eatseasy/models/categories.dart';
import 'package:eatseasy/views/categories/categories_page.dart';
import 'package:get/get.dart';

class AllCategories extends HookWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllCategories();
    final categories = hookResult.data;
    final isLoading = hookResult.isLoading;
    // final error = hookResult.error;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOffWhite,
        centerTitle: true,
        title: ReusableText(
            text: "Categories", style: appStyle(20, kDark, FontWeight.w400),),
      ),
      body: isLoading
          ? const FoodsListShimmer()
          : Center(
            child: BackGroundContainer(
              child: Container(
                  padding: const EdgeInsets.only(left: 12, top: 10),
                  height: height,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        Categories category = categories[index];
                        return ListTile(
                          onTap: () {
                            Get.to(() => CategoriesPage(category: category));
                          },
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: kGrayLight,
                            child: Image.network(
                              category.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                          title: ReusableText(
                              text: category.title,
                            style: appStyle(20, kDark, FontWeight.w400),),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kGray,
                            size: 15,
                          ),
                        );
                      }),
                ),
            ),
          ),
    );
  }
}
