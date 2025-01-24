import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/hooks/fetchDriverOrders.dart';
import 'package:eatseasy_rider/models/ready_orders.dart';
import 'package:eatseasy_rider/views/home/widgets/order_tile.dart';

import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';

class AcceptedOrders extends HookWidget {
  const AcceptedOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchPicked("Picking");
    List<ReadyOrders>? orders = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    return Container(
      height: height,
      width: width,
      color: kLightWhite,
      child: RefreshIndicator(
          color: kPrimary,
          onRefresh: () async {
            refetch();
          },
          child: isLoading
          ? const FoodsListShimmer()
          : orders!.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_content.png',
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            ReusableText(
              text:
              "You're all set for now! There are no orders waiting to be picked up.",
              style: appStyle(14, kGray, FontWeight.normal),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: refetch, // Trigger a refresh of the orders
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
          padding: EdgeInsets.only(top: 10, left: 12, right: 12),
          itemCount: orders!.length,
          itemBuilder: (context, i) {
            ReadyOrders order = orders[i];
            return OrderTile(order: order, active: 'active');
          }))
    );
  }
}
