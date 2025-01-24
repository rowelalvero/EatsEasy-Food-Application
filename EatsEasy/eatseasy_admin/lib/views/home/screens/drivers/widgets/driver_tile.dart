// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/driver_model.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/widgets/driver_details.dart';
import 'package:get/get.dart';

class DriverTile extends StatelessWidget {
  const DriverTile({super.key, required this.driver, this.refetch});

  final DriverElement driver;
  final Function? refetch;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DriverDetails(
          id: driver.id,
          driver: driver,
          refetch: refetch!,
        ));
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 55,
            width: width,
            decoration: BoxDecoration(
                color: kOffWhite, borderRadius: BorderRadius.circular(9.r)),
            child: Container(
              padding: EdgeInsets.all(4.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        driver.profileImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(  // Wrap Column in Expanded
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ReusableText(
                            text: driver.driver.username!,
                            style: appStyle(11, kDark, FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          child: ReusableText(
                            text: "Vehicle Number : ${driver.vehicleNumber}",
                            style: appStyle(10, kGray, FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.65,
                          child: Text(
                            "Vehicle Type       : ${driver.vehicleType}",
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(10, kGray, FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 6,
            child: Container(
              width: 60,
              height: 19,
              decoration: BoxDecoration(
                  color: driver.isAvailable || driver.isAvailable == null
                      ? kPrimary
                      : kSecondaryLight,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: ReusableText(
                    text: driver.isAvailable == true || driver.isAvailable == null
                        ? "Active"
                        : "Inactive",
                    style: appStyle(12, kLightWhite, FontWeight.w600)),
              ),
            ),
          )
        ],
      ),
    );
  }

}
