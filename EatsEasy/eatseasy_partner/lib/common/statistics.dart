import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:get/get.dart';

import '../controllers/constant_controller.dart';

class Statistics extends StatelessWidget {
  const Statistics({
    super.key,
    required this.ordersTotal,
    required this.cancelledOrders,
    required this.processingOrders,
    required this.revenueTotal,
  });

  final int ordersTotal;
  final int cancelledOrders;
  final int processingOrders;
  final double revenueTotal;

  @override
  Widget build(BuildContext context) {
    final ConstantController controller = Get.put(ConstantController());
    controller.getConstants();
    print(controller.constants.value.commissionRate);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: ordersTotal.toString(),
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Total Orders",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: processingOrders.toString(),
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Processing Orders",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: cancelledOrders.toString(),
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Cancelled Orders",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: "Php ${revenueTotal.toStringAsFixed(2).toString()}",
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Total Revenue",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: ordersTotal.toString(),
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Total Orders",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: processingOrders.toString(),
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Delivery Revenue",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: "Php ${(revenueTotal * (controller.constants.value.commissionRate / 100)).toStringAsFixed(2)}",
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Deducted amount",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text: "Php ${(revenueTotal-revenueTotal * (controller.constants.value.commissionRate / 100)).toStringAsFixed(2).toString()}",
                      style: appStyle(14, kGray, FontWeight.w600)),
                  ReusableText(
                      text: "Withdrawable",
                      style: appStyle(10, kGray, FontWeight.normal)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

