import 'package:eatseasy_admin/controllers/add_category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/categories.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../add_categories.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.refetch,
  });

  final Category category;
  final VoidCallback refetch;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddCategoryController());

    return SingleChildScrollView(
      child: RefreshIndicator(
          onRefresh: () async {
            // Trigger refetch when the user pulls down to refresh
            refetch();
          },
          child: controller.isLoading ? Center(
            child: LoadingAnimationWidget.waveDots(
              color: kPrimary,
              size: 35,
            ),
          ) : Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: kPrimary.withOpacity(0.4),
                          child: Image.network(
                            category.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        ReusableText(
                          text: category.title,
                          style: appStyle(12, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: kGray),
                          onPressed: () async {
                            // Call the updateCategory function with new data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCategories(isEdit: true, category: category), // Pass update if needed
                              ),
                            );
                            refetch();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: kRed),
                          onPressed: () async {

                            await controller.deleteCategory(category.id);
                            refetch();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}

