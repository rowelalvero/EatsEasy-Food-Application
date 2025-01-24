import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/driver_controller.dart';
import 'package:eatseasy_rider/controllers/location_controller.dart';
import 'package:eatseasy_rider/hooks/fetchOrders.dart';
import 'package:eatseasy_rider/models/ready_orders.dart';
import 'package:eatseasy_rider/views/home/widgets/order_tile.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';

class PendingOrders extends HookWidget {
  const PendingOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverController());
    final hookResult = useFetchClientOrders();
    List<ReadyOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;
    final getLoc = Get.find<UserLocationController>();

    return Obx(() {
      if (getLoc.currentLocation.latitude == 0.0 || getLoc.currentLocation.longitude == 0.0) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.threeArchedCircle(
                color: kPrimary,
                size: 35,
              ),
              const SizedBox(height: 20),
              const Text(
                "Fetching location...",
                style: TextStyle(fontSize: 16, color: kGray),
              ),
            ],
          ),
        );
      }

      if (orders == null) {
        return const FoodsListShimmer();
      }

      controller.setOnStatusChangeCallback(refetch);

      return Scaffold(
        backgroundColor: kLightWhite,
        body: RefreshIndicator(
          color: kPrimary,
          onRefresh: () async {
            refetch();
          },
          child: isLoading
              ? const FoodsListShimmer()
              : orders.isEmpty
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
                  text: "You're all caught up! No new orders at the moment.",
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
              : CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      ReadyOrders order = orders[i];
                      if (order.deliveryOption == "Pick up") {
                        return null;
                      }

                      return OrderTile(
                        order: order,
                        active: 'ready',
                      );
                    },
                    childCount: orders.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
