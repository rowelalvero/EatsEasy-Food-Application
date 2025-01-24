
import 'package:eatseasy_admin/views/home/screens/Rates/widgets/rates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/heading_titles_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/search/search_page.dart';
import 'package:get/get.dart';

import 'rates_tab.dart';

class RatesPage extends StatefulWidget {
  const RatesPage({super.key});

  @override
  State<RatesPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<RatesPage>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 1,
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.h,
            ),
            HeadingTitlesWidget(
              onTap: () {
                Get.to(() => const SearchPage());
              },
              title: "Rates",
            ),
            SizedBox(
              height: 10.h,
            ),
            EarningsTab(tabController: _tabController),
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
                    borderRadius: BorderRadius.circular(10.r
                    ),
                    child: Container(
                      color: kOffWhite,
                      height: hieght * 0.57,
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Rates(),
                          //Charts(),
                          //RejectedRestaurants()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
