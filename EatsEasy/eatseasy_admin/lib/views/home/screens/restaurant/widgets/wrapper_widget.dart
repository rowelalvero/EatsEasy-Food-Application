import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/pagination.dart';
import 'package:eatseasy_admin/constants/constants.dart';

class WrapperWidget extends StatelessWidget {
  const WrapperWidget({
    super.key,
    required this.currentPage,
    required this.refetch,
    required this.totalPages,
    required this.children,
    this.onPageChanged,
  });

  final int currentPage;
  final Function? refetch;
  final int totalPages;
  final void Function(int)? onPageChanged;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: SizedBox(
        height: hieght * 0.57,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: hieght * 0.54,
              child: ListView(children: children ?? []),
            ),
            Pagination(
              currentPage: currentPage,
              refetch: refetch,
              totalPages: totalPages,
              onPageChanged: onPageChanged,
            )
          ],
        ),
      ),
    );
  }
}
