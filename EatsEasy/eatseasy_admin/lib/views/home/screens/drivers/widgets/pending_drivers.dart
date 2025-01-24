import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/hooks/fetch_drivers.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/widgets/driver_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../common/app_style.dart';
import '../../../../../common/reusable_text.dart';
import '../../../../../constants/constants.dart';
import '../../../../../controllers/pagination/drivers_page_controller.dart';
import '../../restaurant/widgets/wrapper_widget.dart';

class PendingDrivers extends HookWidget {
  const PendingDrivers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriversPagesController());
    final data = fetchDrivers("Pending");

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
              text: "No pending drivers found.",
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

    // Wrap the ListView with RefreshIndicator to enable pull-to-refresh
    return RefreshIndicator(
      color: kPrimary,
      onRefresh: () async {
        // Trigger the refetch to reload the driver data
        await refetch!();
      },
      child: WrapperWidget(
        currentPage: currentPage,
        refetch: refetch,
        totalPages: totalPages,
        onPageChanged: (int value) {
          controller.pending = value + 1;
          refetch!();
        },
        children: List.generate(drivers.length, (index) {
          final driver = drivers[index];
          return DriverTile(driver: driver, refetch: refetch);
        }),
      ),
    );
  }
}
