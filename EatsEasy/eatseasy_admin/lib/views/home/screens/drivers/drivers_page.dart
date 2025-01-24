import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/heading_titles_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/drivers_tab.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/widgets/pending_drivers.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/widgets/rejected_drivers.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/widgets/verified_drivers.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              title: "Drivers",
            ),
            SizedBox(
              height: 10.h,
            ),
            DriversTab(tabController: _tabController),
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
                          PendingDrivers(),
                          VerifiedDrivers(),
                          RejectedDrivers(),
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
