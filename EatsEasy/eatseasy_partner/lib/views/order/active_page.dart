// ignore_for_file: unrelated_type_equality_checks, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/common_appbar.dart';
import 'package:eatseasy_partner/common/custom_btn.dart';
import 'package:eatseasy_partner/common/divida.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/common/row_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/order_controller.dart';
import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:eatseasy_partner/views/home/widgets/order_tile.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  String image = "https://d326fntlu7tb1e.cloudfront.net/uploads/5c2a9ca8-eb07-400b-b8a6-2acfab2a9ee2-image001.webp";

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrdersController());

    return Scaffold(
      appBar: CommonAppBar(
          titleText: orderController.order!.orderStatus
      ),
      body: Center(
        child: BackGroundContainer(
          child: ListView(
            children: [
              Column(  // Changed ListView to Column
                children: [
                  SizedBox(height: 10.h),
                  OrderTile(order: orderController.order!, active: ""),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 19,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          color: kWhite,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.h),
                          RowText(first: "Order Status ", second: orderController.order!.orderStatus),
                          SizedBox(height: 5.h),
                          RowText(first: "Recipient", second: orderController.order!.deliveryAddress!.addressLine1),
                          RowText(first: "Date", second: orderController.order!.orderDate.toString()),
                          SizedBox(height: 5.h),
                          GestureDetector(
                            onTap: () {},
                            child: orderController.order!.userId == null ? Text("No user found") : RowText(
                                first: "Phone ", second: orderController.order!.userId!.phone),
                          ),
                          const Divida(),
                          SizedBox(height: 5.h),
                          Obx(
                                  () {
                                return orderController.isLoading
                                    ? Center(
                                  child: LoadingAnimationWidget.waveDots(
                                    color: kPrimary,
                                    size: 35,
                                  ),
                                )
                                    : orderController.order!.orderStatus == "Placed"
                                    ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return orderController.isLoadingAccept.value
                                          ? Center(
                                        child: LoadingAnimationWidget.waveDots(
                                          color: kPrimary,
                                          size: 35,
                                        ),
                                      )
                                          : CustomButton(
                                          onTap: () {
                                            orderController.isLoadingAccept.value = true;
                                            orderController.processOrder(orderController.order!.id, "Preparing");
                                            orderController.tabIndex = 1;
                                            // After processing, reset the loading state
                                            orderController.isLoadingAccept.value = false;
                                          },
                                          btnWidth: width / 3.5,
                                          radius: 9.r,
                                          color: kPrimary,
                                          text: "Accept"
                                      );
                                    }),
                                    const SizedBox(width: 20),
                                    Obx(() {
                                      return orderController.isLoadingDecline.value
                                          ? Center(
                                        child: LoadingAnimationWidget.waveDots(
                                          color: kRed,
                                          size: 35,
                                        ),
                                      )
                                          : CustomButton(
                                          onTap: () {
                                            orderController.isLoadingDecline.value = true;
                                            orderController.processOrder(
                                                orderController.order!.id, "Cancelled");
                                            orderController.tabIndex = 6;
                                            // After processing, reset the loading state
                                            orderController.isLoadingDecline.value = false;
                                          },
                                          color: kRed,
                                          radius: 9.r,
                                          btnWidth: width / 3.0,
                                          text: "Decline"
                                      );
                                    }),
                                  ],
                                )
                                    : const SizedBox.shrink();
                              }
                          ),
                          orderController.order!.orderStatus == "Preparing"
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              orderController.order!.deliveryOption == "Pick up"
                                  ? const SizedBox.shrink()
                                  : Obx(() {
                                return orderController.isLoadingPushToCouriers.value
                                    ? Center(
                                  child: LoadingAnimationWidget.waveDots(
                                    color: kSecondary,
                                    size: 35,
                                  ),
                                )
                                    : CustomButton(
                                    onTap: () {
                                      orderController.isLoadingPushToCouriers.value = true;
                                      orderController.processOrder(
                                          orderController.order!.id, "Ready");
                                      orderController.tabIndex = 2;
                                      // After processing, reset the loading state
                                      orderController.isLoadingPushToCouriers.value = false;
                                    },
                                    btnWidth: width / 3.0,
                                    radius: 9.r,
                                    color: kPrimary,
                                    text: "Push to Couriers"
                                );
                              }),
                              if (orderController.order!.deliveryOption == "Pick up") ...[
                                Obx(() {
                                  return orderController.isLoadingReady.value
                                      ? Center(
                                    child: LoadingAnimationWidget.waveDots(
                                      color: kSecondary,
                                      size: 35,
                                    ),
                                  )
                                      : CustomButton(
                                      onTap: () {
                                        orderController.isLoadingReady.value = true;
                                        orderController.processOrder(
                                            orderController.order!.id, "Ready");
                                        orderController.tabIndex = 2;
                                        // After processing, reset the loading state
                                        orderController.isLoadingReady.value = false;
                                      },
                                      btnWidth: width / 3.0,
                                      radius: 9.r,
                                      color: kPrimary,
                                      text: "Ready"
                                  );
                                }),
                                const SizedBox(width: 10),
                                Obx(() {
                                  return orderController.isLoadingManual.value
                                      ? Center(
                                    child: LoadingAnimationWidget.waveDots(
                                      color: kSecondary,
                                      size: 35,
                                    ),
                                  )
                                      : CustomButton(
                                      onTap: () {
                                        orderController.isLoadingManual.value = true;
                                        orderController.processOrder(
                                            orderController.order!.id, "Manual");
                                        orderController.tabIndex = 4;
                                        // After processing, reset the loading state
                                        orderController.isLoadingManual.value = false;
                                      },
                                      color: kSecondary,
                                      radius: 9.r,
                                      btnWidth: width / 3.0,
                                      text: "Self Delivery"
                                  );
                                }),
                              ],
                            ],
                          )
                              : const SizedBox.shrink(),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




