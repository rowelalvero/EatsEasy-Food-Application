import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/app_style.dart';
import '../../common/reusable_text.dart';
import '../../constants/constants.dart';
import '../../models/order_model.dart';
import '../home/screens/cashout/widgets/cashout_update_page.dart';

class OrderDetailsPage extends HookWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Order order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: "Order Details",
          style: appStyle(20, kGray, FontWeight.w600),
        ),
      ),
      body: Center(child: BackGroundContainer(child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*ReusableText(
                    text: "${order.}",
                    style: appStyle(16, kDark, FontWeight.w600)),*/
                const SizedBox(height: 10,),
                RowText(first: "Order Id: ", second: order.id),
                RowText(first: "Order date: ", second: order.orderDate),
                RowText(first: "Payment method: ", second: order.paymentMethod),
                RowText(first: "Payment status: ", second: order.paymentStatus),
                RowText(first: "Recipient Id: ", second: order.userId),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                        text: "Restaurant address: ",
                        style: appStyle(11, kDark , FontWeight.w500)
                    ),
                    Expanded(  // Use Expanded to allow the text to take up available space
                      child: Text(
                        order.restaurantAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // Truncate long text with ellipsis
                        style: appStyle(11, kGray, FontWeight.w400),
                      ),
                    ),
                  ],
                ),

                RowText(first: "Sub total: ", second: "Php ${order.grandTotal.toStringAsFixed(2)}"),
                RowText(first: "Delivery fee: ", second: 'Php ${order.deliveryFee.toStringAsFixed(2)}'),
                RowText(first: "Total: ", second: 'Php ${order.grandTotal.toStringAsFixed(2)}'),

                const SizedBox(height: 10,),
                ReusableText(
                    text: "Order Items",
                    style: appStyle(16, kDark, FontWeight.w600)),
                const SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: order.orderItems.map((item) {
                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          height: 90.h,
                          width: width,
                          decoration: const BoxDecoration(
                            color: kOffWhite,
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),

                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  child: SizedBox(
                                    height: 75.h,
                                    width: 70.h,
                                    child: Image.network(
                                      item.foodId.imageUrl[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6.h),
                                    ReusableText(
                                      text: item.foodId.title,
                                      style: appStyle(11, kGray, FontWeight.w500),
                                    ),
                                    SizedBox(height: 6.h),
                                    SizedBox(
                                      height: 15.h,
                                      child: Row(
                                        children: item.customAdditives.entries.map((entry) {
                                          String key = entry.key;
                                          var additive = entry.value;

                                          // Handle case for Toppings which might be a list
                                          if (additive is List) {
                                            additive = additive.join(', '); // Join list items into a string
                                          } else {
                                            additive ??= "Unknown";
                                          }

                                          // Format the display text as "Key: Additive"
                                          String displayText = "$key: $additive";
                                          return Container(
                                            margin: EdgeInsets.only(right: 5.h),
                                            decoration: BoxDecoration(
                                              color: kPrimary,
                                              borderRadius: BorderRadius.all(Radius.circular(15.r)),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child: ReusableText(
                                                  text: displayText,
                                                  style: appStyle(12, kLightWhite, FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                                      margin: EdgeInsets.only(right: 2.w),
                                      decoration: BoxDecoration(
                                          color: kSecondary,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: ReusableText(
                                        text: "Qty: ${item.quantity}",
                                        style: appStyle(12, kWhite, FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),),)
    );
  }
}
