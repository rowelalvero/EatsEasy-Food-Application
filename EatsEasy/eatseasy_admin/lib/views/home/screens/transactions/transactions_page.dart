import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/heading_titles_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/screens/transactions/transactions_tab.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:  Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          width: width,
          height: hieght * 0.57,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              const HeadingTitlesWidget(title: "Transactions",),
              SizedBox(
                height: 10.h,
              ),
              TransactionsTab(tabController: _tabController),
              SizedBox(
                height: 20.h,
              ),

              SizedBox(
                height: hieght* 0.48,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: kLightWhite,
                        height: hieght* 0.48,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              height: 200,
                              width: width,
                              color: Colors.transparent,
                            ),
                            Container(
                              height: 200,
                              width: width,
                              color: Colors.red,
                            ),
                            Container(
                              height: 200,
                              width: width,
                              color: Colors.red,
                            ),
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
