import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/custom_appbar.dart';
import 'package:eatseasy_rider/common/custom_container.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/views/home/driver_orders/active.dart';
import 'package:eatseasy_rider/views/home/driver_orders/delivered.dart';
import 'package:eatseasy_rider/views/home/driver_orders/pending.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import 'driver_orders/accepted.dart';

class HomePage extends StatefulHookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrdersController());
    _tabController.animateTo(orderController.tabIndex);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: const CustomAppBar(),
          elevation: 0,
          backgroundColor: kLightWhite,
        ),
        body: Center(
          child: BackGroundContainer(
            child: SizedBox(
              height: height,
              child: Column(  // Use Column instead of ListView
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 25,
                      width: width,
                      decoration: BoxDecoration(
                        color: kOffWhite,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        labelColor: Colors.white,
                        labelStyle:
                        appStyle(kFontSizeBodySmall, kLightWhite, FontWeight.normal),
                        unselectedLabelColor: Colors.grey.withOpacity(0.7),
                        tabs: const <Widget>[
                          Tab(text: "Ready"),
                          Tab(text: "Picking"),
                          Tab(text: "Delivering"),
                          Tab(text: "Delivered")
                        ],
                      ),
                    ),
                  ),
                  Expanded(  // Use Expanded here to make the TabBarView scrollable
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        PendingOrders(),
                        AcceptedOrders(),
                        ActiveOrders(),
                        DeliveredOrders()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

