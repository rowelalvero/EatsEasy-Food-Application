import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/hooks/fetch_users.dart';
import 'package:eatseasy_admin/models/users_model.dart';
import 'package:eatseasy_admin/views/home/screens/users/widgets/user_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/app_style.dart';
import '../../../../../common/reusable_text.dart';
import '../../../../../constants/constants.dart';

class VerifiedUsersList extends HookWidget {
  const VerifiedUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all verified users at once (no pagination)
    final data = fetchUsers(true, 1, 1000); // Fetch a larger limit for all verified users
    final users = data.users;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;

    // Show shimmer animation while loading
    if (isLoading) {
      return const FoodsListShimmer();
    }

    // Show error message if there's any issue with fetching data
    if (error != null) {
      return const Center(
        child: Text("An error occurred"),
      );
    }

    // Show empty state if no users are found
    if (users == null || users.isEmpty) {
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
              text: "No users found.",
              style: appStyle(14, kGray, FontWeight.normal),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Trigger a refresh to check for cancelled orders
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

    // Wrap the ListView with RefreshIndicator
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: RefreshIndicator(
        color: kPrimary,  // Color of the refresh indicator
        onRefresh: () async {
          // Trigger the refetch to reload the users when pulled
          await refetch!();
        },
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            User user = users[index];
            return UserTile(
              context: context,
              user: user,
              index: index,
            );
          },
        ),
      ),
    );
  }
}
