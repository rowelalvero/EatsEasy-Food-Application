import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/location_controller.dart';
import 'package:eatseasy_partner/controllers/order_controller.dart';
import 'package:eatseasy_partner/models/distance_time.dart';
import 'package:eatseasy_partner/models/ready_orders.dart';
import 'package:eatseasy_partner/views/order/active_page.dart';
import 'package:get/get.dart';

class OrderTile extends StatefulWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.active,
  });

  final ReadyOrders order;
  final String? active;

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  late UserLocationController location;
  late OrdersController controller;
  DistanceTime? distanceTime1;
  DistanceTime? distanceTime2;
  double distanceToRestaurant = 0.0;
  double distanceFromRestaurantToClient = 0.0;

  @override
  void initState() {
    super.initState();
    location = Get.put(UserLocationController());
    controller = Get.put(OrdersController());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        controller.order = widget.order;
        controller.setDistance = distanceToRestaurant + distanceFromRestaurantToClient;
        Get.to(() => const ActivePage());
      },
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 19,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display order items dynamically
              ...widget.order.orderItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kOffWhite,
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: SizedBox(
                          height: 75,
                          width: 85,// Adaptive width
                          child: Image.network(
                            item.foodId.imageUrl[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: item.foodId.title,
                              style: appStyle(kFontSizeBodySmall, kGray, FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: item.customAdditives.entries.map((entry) {
                                  String displayText = "${entry.key}: ${entry.value}";
                                  return Container(
                                    margin: const EdgeInsets.only(right: 4), // Add margin between items
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: const BoxDecoration(
                                      color: kPrimary,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: ReusableText(
                                      text: displayText,
                                      style: appStyle(12, kLightWhite, FontWeight.w400),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: kSecondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ReusableText(
                                text: "Qty: ${item.quantity}",
                                style: appStyle(12, kWhite, FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              // Additional order details
              OrderRowText(text: "🍲 Order : ${widget.order.id}", screenWidth: screenWidth),
              OrderRowText(text: "🏠 ${widget.order.deliveryAddress!.addressLine1}", screenWidth: screenWidth),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildStatusContainer(widget.order.paymentStatus == 'Completed'
                      ? "Paid"
                      : widget.order.paymentStatus == 'Refunded'
                      ? "Refunded"
                      :  "COD",
                      widget.order.paymentStatus == 'Completed' ? kPrimary : kSecondary),
                  _buildStatusContainer(widget.order.deliveryDate!,
                      widget.order.deliveryDate == 'Today' ? kPrimary : kSecondary),
                  _buildStatusContainer("${widget.order.deliveryOption}", kSecondary),
                  _buildStatusContainer("Php ${widget.order.orderTotal?.toStringAsFixed(0)}", Colors.lightGreen),
                  _buildStatusContainer("⏰ 25 min", kWhite, textColor: kGray),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusContainer(String text, Color bgColor, {Color textColor = kWhite}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      margin: EdgeInsets.only(right: 2.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ReusableText(
        text: text,
        style: appStyle(12, textColor, FontWeight.w400),
      ),
    );
  }
}

class OrderRowText extends StatelessWidget {
  OrderRowText({super.key, required this.text, required this.screenWidth});

  final String text;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.6, // Adaptive width for landscape
      child: ReusableText(
        text: text,
        style: appStyle(kFontSizeSubtext, kGray, FontWeight.w400),
      ),
    );
  }
}
