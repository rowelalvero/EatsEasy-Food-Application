import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/hooks/fetchRestaurantOrders.dart';
import 'package:eatseasy_partner/models/ready_orders.dart';
import 'package:eatseasy_partner/views/home/widgets/empty_page.dart';
import 'package:eatseasy_partner/views/home/widgets/order_tile.dart';

import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';

class PreparingOrders extends HookWidget {
  const PreparingOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchPicked("preparing");
    List<ReadyOrders>? orders = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    return Container(
      height: hieght / 1.3,
      width: width,
      color: Colors.transparent,
      child: RefreshIndicator(
        color: kPrimary, // Set the color for the refresh indicator
        onRefresh: () async {
          refetch(); // Trigger the refetch when pull-to-refresh is invoked
        },
        child: orders!.isEmpty
            ? Center(
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
                text: "You're all caught up! No preparing orders right now.",
                style: appStyle(14, kGray, FontWeight.normal),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  refetch();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Refresh Orders",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w),
          itemCount: orders.length,
          itemBuilder: (context, i) {
            ReadyOrders order = orders[i];
            return OrderTile(order: order, active: 'active');
          },
        ),
      ),
    );
  }
}
