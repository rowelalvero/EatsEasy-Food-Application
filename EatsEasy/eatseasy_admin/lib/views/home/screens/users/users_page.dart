import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/heading_titles_widget.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/screens/users/users_tab.dart';
import 'package:eatseasy_admin/views/home/screens/users/widgets/unverified_user_list.dart';
import 'package:eatseasy_admin/views/home/screens/users/widgets/verified_user_list.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
              title: "Clients",
            ),
            
            UsersTab(tabController: _tabController),
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
                      height: hieght * 0.57,
                      decoration: BoxDecoration(
                        color: kLightWhite,
                        border: Border.all(
                          color: kLightWhite,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          VerifiedUsersList(),
                          //UnVerifiedUsersList()
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
