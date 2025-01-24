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

class DeliveredOrders extends HookWidget {
  const DeliveredOrders({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    final hookResult = useFetchPicked("Delivered");
    List<ReadyOrders>? orders = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    return Container(
      height: height / 1.3,
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
             height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
             width: MediaQuery.of(context).size.width * 0.5,   // 50% of screen width
             fit: BoxFit.contain,
           ),
           const SizedBox(height: 16),
           ReusableText(
             text: "No orders delivered yet!",
             style: appStyle(14, kGray, FontWeight.normal),
           ),
           ReusableText(
             text: "You can see here your completed deliveries.",
             style: appStyle(14, kGray, FontWeight.normal),
           ),
           const SizedBox(height: 16),
           GestureDetector(
             onTap: () {
               // Trigger a refresh to check for delivered orders
               hookResult.refetch();
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
              padding: const EdgeInsets.only(top: 10 , left: 12, right: 12),
              itemCount: orders!.length,
              itemBuilder: (context, i) {
                ReadyOrders order = orders[i];
                return OrderTile(order: order, active: null,);
              }),
    ));
  }
}
