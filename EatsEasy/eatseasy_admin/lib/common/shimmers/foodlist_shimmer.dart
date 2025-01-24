import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/shimmers/shimmer_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';

class FoodsListShimmer extends StatelessWidget {
  const FoodsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 10),
      height: hieght * 0.57,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          itemCount: 5,
          itemBuilder: (context, index) {
            return ShimmerWidget(
                shimmerWidth: width,
                shimmerHieght: 65.h,
                shimmerRadius: 12);
          }),
    );
  }
}
