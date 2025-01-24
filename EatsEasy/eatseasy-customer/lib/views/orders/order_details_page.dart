import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/common/divida.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/notifications_controller.dart';
import 'package:eatseasy/views/orders/widgets/order_page_tile.dart';
import 'package:eatseasy/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());
    final message = ModalRoute.of(context)!.settings.arguments as NotificationResponse;

    print(" notifications page payload ${message.payload}");
    var orderData = jsonDecode(message.payload.toString());

    controller.getOrder(orderData['orderId']);

    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: ReusableText(
              text: 'Order Details Page',
              style: appStyle(20, kDark, FontWeight.w400),
            ),
          ),
          body: controller.loading == true
              ? const FoodsListShimmer()
              : Center(
                child: BackGroundContainer(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          width: width,
                          height: height / 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                            decoration: BoxDecoration(
                                color: kOffWhite,
                                borderRadius: BorderRadius.circular(12.r)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ReusableText(
                                        text: controller
                                            .order!.restaurantId!.title!,
                                        style:
                                            appStyle(20, kGray, FontWeight.bold)),
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: kTertiary,
                                      backgroundImage: NetworkImage(controller
                                          .order!.restaurantId!.logoUrl!),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                RowText(
                                    first: "Business Hours",
                                    second:
                                        controller.order!.restaurantId!.time!),
                                SizedBox(
                                  height: 5.h,
                                ),
                                const Divida(),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Table(
                                  children: [
                                    TableRow(children: [
                                      ReusableText(
                                          text: "Recipient",
                                          style: appStyle(
                                              11, kGray, FontWeight.w600)),
                                      ReusableText(
                                          text: controller.order!.deliveryAddress!
                                              .addressLine1!,
                                          style: appStyle(
                                              11, kGray, FontWeight.normal)),
                                    ]),
                                    TableRow(children: [
                                      ReusableText(
                                          text: "Restaurant",
                                          style: appStyle(
                                              11, kGray, FontWeight.w600)),
                                      ReusableText(
                                          text: controller.order!.restaurantId!
                                              .coords!.address!,
                                          style: appStyle(
                                              11, kGray, FontWeight.normal)),
                                    ]),
                                    TableRow(children: [
                                      ReusableText(
                                          text: "Order Number",
                                          style: appStyle(
                                              11, kGray, FontWeight.w600)),
                                      ReusableText(
                                          text: controller.order!.id!,
                                          style: appStyle(
                                              11, kGray, FontWeight.normal)),
                                    ]),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        OrderPageTile(
                          food: controller.order!.orderItems![0],
                          status: controller.order!.orderStatus!,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        //  controller.order!.orderStatus == 'Out_for_Delivery' ?
                        // Container(
                        //  // padding: EdgeInsets.symmetric(horizontal: 9.w),
                        //      margin: EdgeInsets.fromLTRB(8.w, 0.w, 8.w, 0),
                        //      decoration: BoxDecoration(
                        //          color: kSecondaryLight,
                        //          borderRadius: BorderRadius.circular(30.r)),
                        //  child: Row(
                        //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //    children: [
                        //       CircleAvatar(
                        //                radius: 16,
                        //                backgroundColor: kTertiary,
                        //                backgroundImage:
                        //                    NetworkImage(controller.order!.driverId!.driver.profile),
                        //              ),
                        //      Padding(
                        //        padding: const EdgeInsets.all(8.0),
                        //        child: Row(
                        //          mainAxisAlignment: MainAxisAlignment.center,
                        //          crossAxisAlignment: CrossAxisAlignment.center,
                        //          children: [
                        //            const Icon(SimpleLineIcons.screen_smartphone, color: kGray, size: 14),
                        //
                        //            SizedBox(width: 5.w,),
                        //            ReusableText(text: items.driverId!.driver.phone, style: appStyle(13, kGray, FontWeight.w400)),
                        //          ],
                        //        ),
                        //      ),
                        //    ],
                        //  ),
                        // ): const SizedBox.shrink()
                      ],
                    ),
                  ),
              ),
        ));
  }
}
