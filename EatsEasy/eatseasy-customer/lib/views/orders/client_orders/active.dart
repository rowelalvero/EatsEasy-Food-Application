import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchOrders.dart';
import 'package:eatseasy/models/client_orders.dart';
import 'package:eatseasy/views/orders/widgets/client_order_tile.dart';
import 'package:get/get.dart';

import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../../controllers/updates_controllers/picked_controller.dart';

class ActiveOrders extends HookWidget {
  const ActiveOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PickedController());
    final hookResult = useFetchClientOrders('orderStatus', 'Out_for_Delivery');
    List<ClientOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    controller.setOnStatusChangeCallback(refetch);

    return isLoading
        ? const FoodsListShimmer()
        : orders!.isEmpty
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
            text: "You're all caught up! No active orders to deliver right now.",
            style: appStyle(14, kGray, FontWeight.normal),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Trigger a refresh to check for new active orders
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
        : RefreshIndicator(
      color: kPrimary,
      onRefresh: () async {
        // Trigger the hook to refetch the data
        refetch();
      },
      child: Container(
        height: height / 1.3,
        width: width,
        color: kLightWhite,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w),
          itemCount: orders.length,
          itemBuilder: (context, i) {
            ClientOrders order = orders[i];
            return ClientOrderTile(order: order);
          },
        ),
      ),
    );
  }
}
