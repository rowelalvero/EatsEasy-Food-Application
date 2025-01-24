import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/foods_controller.dart';
import 'package:eatseasy_partner/hooks/fetchAllCategories.dart';
import 'package:eatseasy_partner/models/categories.dart';
import 'package:get/get.dart';

class AllCategories extends HookWidget {
  const AllCategories({super.key, required this.next});

  final Function() next;

  @override
  Widget build(BuildContext context) {
    final foodsController = Get.put(FoodsController());
    final hookResult = useFetchAllCategories();
    final categories = hookResult.data;
    final isLoading = hookResult.isLoading;

    return isLoading
        ? const FoodsListShimmer()
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: "Pick Category",
                  style: appStyle(
                    kFontSizeBodyRegular,
                    kGray,
                    FontWeight.w600,
                  ),
                ),
                ReusableText(
                  text:
                  "You are required to pick a category for your food item",
                  style: appStyle(
                    kFontSizeSubtext,
                    kGray,
                    FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.only(top: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              Categories category = categories[index];
              return ListTile(
                onTap: () {
                  foodsController.category = category.id;
                  next();
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
                  style: appStyle(
                    kFontSizeBodySmall,
                    kGray,
                    FontWeight.normal,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kGray,
                  size: 15,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
