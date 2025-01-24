import 'package:eatseasy/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/custom_container.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/views/orders/client_orders/active.dart';
import 'package:eatseasy/views/orders/client_orders/cancelled.dart';
import 'package:eatseasy/views/orders/client_orders/delivered.dart';
import 'package:eatseasy/views/orders/client_orders/paid.dart';
import 'package:eatseasy/views/orders/client_orders/pending.dart';
import 'package:eatseasy/views/orders/client_orders/preparing.dart';
import 'package:get_storage/get_storage.dart';

class ClientOrderPage extends StatefulHookWidget {
  const ClientOrderPage({Key? key}) : super(key: key);

  @override
  _ClientOrderPageState createState() => _ClientOrderPageState();
}

class _ClientOrderPageState extends State<ClientOrderPage>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 6,
    vsync: this,
  );
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kLightWhite,
          elevation: 0,
          title: ReusableText(
            text: "My orders",
            style: appStyle(20, kDark, FontWeight.w400),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Container(
                height: 25.h,
                width: width,
                decoration: BoxDecoration(
                  color: kLightWhite,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                 child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  labelPadding: EdgeInsets.zero,
                  labelColor: Colors.white,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelStyle: appStyle(12, kLightWhite, FontWeight.normal),
                  unselectedLabelColor: Colors.grey.withOpacity(0.7),
                  tabs:  <Widget>[
                    Tab(
                      child: Container(
                        margin:const EdgeInsets.symmetric(horizontal: 5),
                        width:MediaQuery.of(context).size.width/6,
                        //margin: EdgeInsets.only(left: 20, right: 20),
                        height: 25,
                        child: const Center(child: Text("Pending")),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),

                        width:MediaQuery.of(context).size.width/6,
                        //margin: EdgeInsets.only(left: 20, right: 20),
                        height: 25,
                        child: const Center(child: Text("Paid")),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width:MediaQuery.of(context).size.width/6,
                        //margin: EdgeInsets.only(left: 20, right: 20),
                        height: 25,
                        child: const Center(child: Text("Preparing")),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width:MediaQuery.of(context).size.width/6,
                        //margin: EdgeInsets.only(left: 20, right: 20),
                        height: 25,
                        child: const Center(child: Text("Delivering")),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin:const EdgeInsets.symmetric(horizontal: 5),
                        width:MediaQuery.of(context).size.width/6,
                        //margin: EdgeInsets.only(left: 20, right: 20),
                        height: 25,
                        child: const Center(child: Text("Delivered")),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin:const EdgeInsets.symmetric(horizontal: 5),
                        width:MediaQuery.of(context).size.width/6,
                        //margin: EdgeInsets.only(left: 20, right: 20),
                        height: 25,
                        child: const Center(child: Text("Canceled")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: BackGroundContainer(
            child: SizedBox(
              height: height,
              child: TabBarView(controller: _tabController, children: const [
                PendingOrders(),
                PaidOrders(),
                PreparingOrders(),
                ActiveOrders(),
                DeliveredOrders(),
                CancelledOrders(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class TabTitle extends StatelessWidget {
  const TabTitle({
    super.key, required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 25,
      child:  Center(child: Text(title)),
    );
  }
}
