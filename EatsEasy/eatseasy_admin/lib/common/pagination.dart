import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';

class Pagination extends StatelessWidget {
  const Pagination({
    super.key,
    this.onTap,
    this.refetch,
    required this.totalPages,
    this.currentPage,
    this.onPageChanged,
  });

  final void Function()? onTap;
  final Function? refetch;
  final int totalPages;
  final int? currentPage;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(  // Wrap with Expanded to handle overflow
            child: SizedBox(
              height: 20,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: totalPages,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onPageChanged!(index);
                    },
                    child: Container(
                      height: 18,
                      width: 18.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: currentPage! - 1 == index ? kPrimary : kGrayLight,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Center(
                        child: ReusableText(
                          text: "${index + 1}",
                          style: appStyle(
                            11,
                            currentPage! - 1 == index ? kLightWhite : kGray,
                            FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

    );
  }
}
