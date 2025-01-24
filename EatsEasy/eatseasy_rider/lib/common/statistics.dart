import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/constant_controller.dart';
import 'app_style.dart';
class Statistics extends StatelessWidget {
  const Statistics({
    super.key,
    required this.totalDeliveries,
    required this.cancelledDeliveries,
    required this.activeDeliveries,
    required this.revenueTotal,
  });

  final int totalDeliveries;
  final int cancelledDeliveries;
  final int activeDeliveries;
  final double revenueTotal;

  @override
  Widget build(BuildContext context) {
    final ConstantController controller = Get.put(ConstantController());
    controller.getConstants();
    return Container(
      margin: EdgeInsets.only(top: 0 ),
      decoration: const BoxDecoration(
        color: kWhite,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 12),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ReusableText(
                          text: totalDeliveries.toString(),
                          style: appStyle(18, kGray, FontWeight.w600),
                        ),
                        ReusableText(
                          text: "Total Orders",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(width: 20), // Spacing between columns
                    Column(
                      children: [
                        ReusableText(
                          text: activeDeliveries.toString(),
                          style: appStyle(18, kGray, FontWeight.w600),
                        ),
                        ReusableText(
                          text: "Processing Orders",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        ReusableText(
                          text: cancelledDeliveries.toString(),
                          style: appStyle(18, kGray, FontWeight.w600),
                        ),
                        ReusableText(
                          text: "Cancelled Orders",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text("₱", style: TextStyle(fontSize: 18),),
                            ReusableText(
                              text: revenueTotal.toStringAsFixed(2),
                              style: appStyle(18, kGray, FontWeight.w600),
                            ),
                          ],
                        ),
                        ReusableText(
                          text: "Total Revenue",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10 ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ReusableText(
                          text: 0.toString(),
                          style: appStyle(18, kGray, FontWeight.w600),
                        ),
                        ReusableText(
                          text: "Total Deliveries",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        ReusableText(
                          text: 0.toString(),
                          style: appStyle(18, kGray, FontWeight.w600),
                        ),
                        ReusableText(
                          text: "Delivery Revenue",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text("₱", style: TextStyle(fontSize: 18),),
                            ReusableText(
                              text: (revenueTotal * controller.constants.value.driverBaseRate).toStringAsFixed(2),
                              style: appStyle(18, kGray, FontWeight.w600),
                            ),
                          ],
                        ),
                        ReusableText(
                          text: "Commission Total",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text("₱", style: TextStyle(fontSize: 18),),
                            ReusableText(
                              text: (revenueTotal - revenueTotal * controller.constants.value.driverBaseRate).toStringAsFixed(2),
                              style: appStyle(18, kGray, FontWeight.w600),
                            ),
                          ],
                        ),
                        ReusableText(
                          text: "Withdrawable",
                          style: appStyle(14, kGray, FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

