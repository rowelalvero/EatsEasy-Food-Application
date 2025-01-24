import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/custom_btn.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/status_controller.dart';
import 'package:eatseasy_admin/models/restaurant_data.dart';
import 'package:get/get.dart';

class StatusButtons extends StatelessWidget {
  const StatusButtons({
    super.key,
    required this.restaurant,
    required this.refetch,
  });

  final Data? restaurant;
  final Function? refetch;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatusController());

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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (restaurant!.verification == "Pending" || restaurant!.verification == "Rejected")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.updateStatus(restaurant!.id, "Verified", refetch!);
                    },
                    text: "Accept",
                    color: kPrimary,
                    radius: 0,
                  ),
                ),
              if (restaurant!.verification == "Pending")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.updateStatus(restaurant!.id, "Rejected", refetch!);
                    },
                    text: "Reject",
                    color: kRed,
                    radius: 0,
                  ),
                ),
              if (restaurant!.verification == "Verified")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.updateStatus(restaurant!.id, "Rejected", refetch!);
                    },
                    text: "Disable",
                    color: kGray,
                    radius: 0,
                  ),
                ),
              if (restaurant!.verification == "Verified")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.deleteRestaurant(restaurant!.id, restaurant!.owner);
                    },
                    text: "Delete",
                    color: kRed,
                    radius: 0,
                  ),
                ),
              if (restaurant!.verification == "Rejected")
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      controller.deleteRestaurant(restaurant!.id, restaurant!.owner);
                    },
                    text: "Delete",
                    color: kRed,
                    radius: 0,
                  ),
                ),
            ],
          )

        ],
      ),
    );
  }
}
