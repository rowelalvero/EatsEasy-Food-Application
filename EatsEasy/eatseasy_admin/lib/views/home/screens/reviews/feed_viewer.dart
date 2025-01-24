import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/feedback_model.dart';

class FeedViewer extends StatelessWidget {
  const FeedViewer({super.key, required this.feed});

  final Feedbackx feed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: BackGroundContainer(child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              feed.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: -10,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: EdgeInsets.all(4.h),
                  width: width,
                  height: 100.h,
                  color: kLightWhite,
                  child: Text(
                    feed.message,
                    maxLines: 8,
                    style: appStyle(12, kDark, FontWeight.normal),
                  ),
                ),
              ))
        ],
      ))),
    );
  }
}
