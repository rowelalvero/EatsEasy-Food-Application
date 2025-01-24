import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/custom_app_bar.dart';
import 'package:eatseasy_rider/common/custom_container.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/common/row_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/order_controller.dart';
import 'package:eatseasy_rider/views/entrypoint.dart';
import 'package:get/get.dart';

class DeliveredPage extends StatelessWidget {
  const DeliveredPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    return Scaffold(
        appBar: CommonAppBar(titleText: "Delivered"),
        body: Center(
          child: BackGroundContainer(
            child: SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/delivery.png',
                  height: height / 3,
                  width: width,
                ),
                const SizedBox(
                  height: 20 ,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ReusableText(
                      text: "Order Delivered",
                      style: appStyle(20, kDark, FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.all(12 ),
                  padding: EdgeInsets.all(8 ),
                  height: 100,
                  decoration: BoxDecoration(
                    color: kLightWhite,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      RowText(
                        first: "Order ID",
                        second: controller.order!.id,
                        color: kDark,
                      ),
                      RowText(
                          first: "Payment method.",
                          second: controller.order!.paymentMethod == "STRIPE" ? "Wallet" : "COD",
                          color: kDark),
                      /*RowText(
                          first: "Recipient No.",
                          second: controller.order!.userId.phone,
                          color: kDark),*/
                      /*const RowText(
                          first: "Rating", second: '⭐ 5.0', color: kDark),*/
                      RowText(
                          first: "Earnings",
                          second: "Php ${controller.order!.deliveryFee}",
                          color: kDark),
                    ],
                  ),
                )
              ],
            ),),
          ),
        ));
  }
}
