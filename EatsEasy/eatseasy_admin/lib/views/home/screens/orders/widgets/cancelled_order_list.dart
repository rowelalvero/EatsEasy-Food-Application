import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/hooks/fetch_orders.dart';
import 'package:eatseasy_admin/views/home/screens/orders/widgets/order_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/app_style.dart';
import '../../../../../common/reusable_text.dart';
import '../../../../../constants/constants.dart';

class CancelledOrders extends HookWidget {
  const CancelledOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch all cancelled orders at once (no pagination)
    final data = fetchOrders(1, 1000, "Cancelled"); // Fetch a larger limit for all cancelled orders
    final orders = data.orders;
    final isLoading = data.isLoading;
    final error = data.error;
    final refetch = data.refetch;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    if (orders == null || orders.isEmpty) {
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
              text: "No cancelled orders found.",
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
      return Center(
        child: Text(error.message),
      );
    }

    // Display the list of all cancelled orders without pagination
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: RefreshIndicator(
        color: kPrimary,
        onRefresh: () async {
          // Trigger the refetch to reload the orders
          await refetch!();
        },
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderTile(order: order);
          },
        ),
      ),
    );
  }
}
