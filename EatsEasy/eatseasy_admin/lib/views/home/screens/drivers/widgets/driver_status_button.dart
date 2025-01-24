import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/custom_btn.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/driver_controller.dart';
import 'package:eatseasy_admin/models/driver_model.dart';
import 'package:get/get.dart';

class DriverStatusButtons extends StatelessWidget {
  const DriverStatusButtons({
    super.key,
    required this.driver,
    required this.refetch,
  });

  final DriverElement? driver;
  final Function? refetch;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: "Change Status",
              style: appStyle(13, kGray, FontWeight.w600)),
          SizedBox(
            height: 10.h,
          ),Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (driver!.verification == "Pending" || driver!.verification == "Rejected")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.updateStatus(driver!.id, "Verified", refetch!);
                    },
                    text: "Accept",
                    color: kPrimary,
                    radius: 0,
                  ),
                ),
              if (driver!.verification == "Pending")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.updateStatus(driver!.id, "Rejected", refetch!);
                    },
                    text: "Reject",
                    color: kRed,
                    radius: 0,
                  ),
                ),
              if (driver!.verification == "Verified")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.updateStatus(driver!.id, "Rejected", refetch!);
                    },
                    text: "Disable",
                    color: kGray,
                    radius: 0,
                  ),
                ),
              if (driver!.verification == "Verified")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      // controller.deleteRestaurant(driver!.id, driver!.driver.id);
                    },
                    text: "Delete",
                    color: kRed,
                    radius: 0,
                  ),
                ),
              if (driver!.verification == "Rejected")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      // controller.deleteRestaurant(driver!.id, driver!.driver.id);
                    },
                    text: "Delete",
                    color: kRed,
                    radius: 0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
