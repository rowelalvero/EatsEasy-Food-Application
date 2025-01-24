// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/heading_titles_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/screens/orders/orders_tab.dart';
import 'package:eatseasy_admin/views/home/screens/orders/widgets/accepted_order_list.dart';
import 'package:eatseasy_admin/views/home/screens/orders/widgets/cancelled_order_list.dart';
import 'package:eatseasy_admin/views/home/screens/orders/widgets/delivered_order_list.dart';
import 'package:eatseasy_admin/views/home/screens/orders/widgets/placed_order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            const HeadingTitlesWidget(
              title: "Orders",
            ),
            SizedBox(
              height: 10.h,
            ),
            OrdersTab(tabController: _tabController),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: hieght * 0.57,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: kLightWhite,
                      height: hieght * 0.57,
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          PlacedOrders(),
                          DeliveringOrders(),
                          DeliveredOrders(),
                          CancelledOrders()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
