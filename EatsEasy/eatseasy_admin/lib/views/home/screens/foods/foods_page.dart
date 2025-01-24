import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/heading_titles_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/screens/foods/foods_tab.dart';
import 'package:eatseasy_admin/views/home/screens/foods/widgets/available_foods_list.dart';
import 'package:eatseasy_admin/views/home/screens/foods/widgets/sold_out_food_list.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          const HeadingTitlesWidget(
            title: "Foods",
          ),
         
          FoodsTab(tabController: _tabController),
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
                        AvailableFoodlist(),
                        SoldOutFoodlist()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
