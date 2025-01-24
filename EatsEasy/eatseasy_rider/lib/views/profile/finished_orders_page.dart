import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/custom_app_bar.dart';
import 'package:eatseasy_rider/common/custom_container.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/common/row_text.dart';
import 'package:eatseasy_rider/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/order_controller.dart';
import 'package:eatseasy_rider/hooks/fetchFinishedOrders.dart';
import 'package:eatseasy_rider/models/ready_orders.dart';
import 'package:eatseasy_rider/views/entrypoint.dart';
import 'package:eatseasy_rider/views/home/widgets/order_tile.dart';
import 'package:get/get.dart';

class FinishedOrdersPage extends HookWidget {
  const FinishedOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchClientFinishedOrders();
    List<ReadyOrders>? orders = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;

    return Scaffold(
      appBar: CommonAppBar(
        titleText: "My orders"
      ),
      body: Center(child: BackGroundContainer(child: Container(
        height: height / 1.3,
        width: width,
        color: kLightWhite,
        child: isLoading
            ? const FoodsListShimmer()
            : ListView.builder(
            padding: EdgeInsets.only(top: 10 , left: 12, right: 12),
            itemCount: orders!.length,
            itemBuilder: (context, i) {
              ReadyOrders order = orders[i];
              return OrderTile(order: order, active: null,);
            }),
      )),),
    );
  }
}
