import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/constants/constants.dart';


class TilesWidget extends StatelessWidget {
  final String title;
  final IconData leading;
  final Function()? onTap;

  const TilesWidget({
    Key? key,
    required this.title,
    required this.leading,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        visualDensity: VisualDensity.compact,
        onTap: onTap,
        leading: Icon(leading, size: 20,),
        title: Text(
          title,
          style: appStyle(kFontSizeBodyRegular, kGray, FontWeight.normal),
        ),
        trailing:  const Icon(
                AntDesign.right,
                size: 16,
              )
            );
  }
}
