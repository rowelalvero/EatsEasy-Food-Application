import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/pagination.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/drivers_page_controller.dart';
import 'package:eatseasy_admin/hooks/fetch_drivers.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/widgets/driver_tile.dart';
import 'package:get/get.dart';

import '../../../../../common/app_style.dart';
import '../../../../../common/reusable_text.dart';

class RejectedDrivers extends HookWidget {
  const RejectedDrivers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriversPagesController());
    final data = fetchDrivers("Rejected");

    final drivers = data.drivers;
    final isLoading = data.isLoading;
    final refetch = data.refetch;
    final totalPages = data.totalPages;
    final currentPage = data.currentPage;
    final error = data.error;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    if (error != null) {
      return Center(
        child: Text(error.message),
      );
    }

    if (drivers != null && drivers.isEmpty) {
      return Center(
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
              text: "No rejected drivers found.",
              style: appStyle(14, kGray, FontWeight.normal),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Trigger a refresh to check for cancelled orders
                refetch!();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (drivers == null) {
      return const Center(
        child: Text("Error fetching driver information"),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: SizedBox(
        height: hieght * 0.52,
        child: RefreshIndicator(
          color: kPrimary,
          onRefresh: () async {
            // Trigger the refetch to reload the driver data
            await refetch!();
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: hieght * 0.42,
                child: ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return DriverTile(driver: driver, refetch: refetch);
                  },
                ),
              ),
              Pagination(
                currentPage: currentPage,
                refetch: refetch,
                totalPages: totalPages,
                onPageChanged: (int value) {
                  controller.rejected = value + 1;
                  refetch!();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
