import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/constants/constants.dart';

class BackGroundContainer extends StatelessWidget {
  const BackGroundContainer({
    super.key, required this.child, this.color,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // Adjust to fit 90% of screen width
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20.r), // Responsive radius using flutter_screenutil
        ),
      ),
      child: child,
    );
  }
}
