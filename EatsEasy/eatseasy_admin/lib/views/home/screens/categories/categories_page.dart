import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/heading_titles_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/screens/categories/add_categories.dart';
import 'package:eatseasy_admin/views/home/screens/categories/widgets/category_list.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          HeadingTitlesWidget(
            title: "Categories",
            onTap: () {
              Get.to(() => const AddCategories());
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: hieght * 0.57,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: kLightWhite,
                    height: hieght * 0.57,
                    child: const CategoryList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
