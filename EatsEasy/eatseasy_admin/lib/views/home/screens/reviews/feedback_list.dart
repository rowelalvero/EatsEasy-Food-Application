import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/pagination.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/feedback_controller.dart';
import 'package:eatseasy_admin/hooks/fetch_feedback.dart';
import 'package:eatseasy_admin/views/home/screens/reviews/feed_viewer.dart';
import 'package:get/get.dart';

import '../../../../common/reusable_text.dart';

class FeedbackList extends HookWidget {
  const FeedbackList({super.key});

  @override
  Widget build(BuildContext context) {
    final pagination = Get.put(FeedbackController());
    final data = fetchFeedback();
    final feeds = data.feeds;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;
    final totalPages = data.totalPages;
    final currentPage = data.currentPage;
    pagination.setData(data.refetch!);

    // Show shimmer loading while fetching data
    if (isLoading) {
      return const FoodsListShimmer();
    }

    // Show error if no feedback found or error occurs
    if (feeds!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_content.png',
              height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
              width: MediaQuery.of(context).size.width * 0.5,   // 50% of screen width
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            ReusableText(
              text: "No feedbacks found.",
              style: appStyle(14, kGray, FontWeight.normal),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Trigger a refresh to reload feedback data
                refetch!();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show error message if there was a problem with the data
    if (error != null) {
      return const Center(
        child: Text("An error occurred"),
      );
    }

    // Wrap the ListView with RefreshIndicator to enable pull-to-refresh
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        color: kLightWhite,
        height: hieght * 0.57, // Adjust container height accordingly
        child: RefreshIndicator(
          color: kPrimary,  // Color of the refresh indicator
          onRefresh: () async {
            // Trigger refetch on pull-to-refresh
            await refetch!();
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: hieght * 0.56, // Adjust ListView height
                child: ListView(
                  children: List.generate(feeds.length, (index) {
                    final feed = feeds[index];
                    return Container(
                      margin: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: kOffWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      height: 80,
                      child: ListTile(
                        onTap: () {
                          Get.to(() => FeedViewer(
                            feed: feed,
                          ));
                        },
                        leading: Image.network(feed.imageUrl),
                        title: Text(feed.userId,
                            style: appStyle(10, kGray, FontWeight.normal)),
                        subtitle: Text(feed.message,
                            style: appStyle(10, kGray, FontWeight.normal)),
                      ),
                    );
                  }),
                ),
              ),
              Pagination(
                currentPage: currentPage,
                refetch: refetch,
                totalPages: totalPages,
                onPageChanged: (int value) {
                  pagination.available = value + 1;
                  refetch!();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
