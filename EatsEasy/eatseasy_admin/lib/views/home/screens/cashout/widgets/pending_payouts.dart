import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/hooks/fetch_payouts.dart';
import 'package:eatseasy_admin/models/payouts_model.dart';
import 'package:eatseasy_admin/views/home/screens/cashout/widgets/payout_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/app_style.dart';
import '../../../../../common/reusable_text.dart';
import '../../../../../constants/constants.dart';

class PendingPayouts extends HookWidget {
  const PendingPayouts({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all pending payouts (remove pagination logic)
    final data = fetchPayouts('pending');
    final payouts = data.payouts;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    if (payouts == null || payouts.isEmpty) {
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
              text: "No pending payouts found.",
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

    if (error != null) {
      return const Center(
        child: Text("An error occurred"),
      );
    }

    // Display all pending payouts in a ListView
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: RefreshIndicator(
        color: kPrimary,  // Color of the refresh indicator
        onRefresh: () async {
          // Trigger the refetch to reload the payouts when pulled
          await refetch!();
        },
        child: ListView.builder(
          itemCount: payouts.length,
          itemBuilder: (context, index) {
            final payout = payouts[index];
            return PayoutTile(payout: payout, refetch: refetch);
          },
        ),
      ),
    );
  }
}
