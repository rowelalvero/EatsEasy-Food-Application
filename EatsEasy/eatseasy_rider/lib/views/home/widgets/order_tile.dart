// ignore_for_file: unrelated_type_equality_checks, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/cached_network_image_container.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/location_controller.dart';
import 'package:eatseasy_rider/controllers/order_controller.dart';
import 'package:eatseasy_rider/models/distance_time.dart';
import 'package:eatseasy_rider/models/ready_orders.dart';
import 'package:eatseasy_rider/services/distance.dart';
import 'package:eatseasy_rider/views/order/delivered.dart';
import 'package:eatseasy_rider/views/order/ready_page.dart';
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
  OrderTileState createState() => OrderTileState();
}

class OrderTileState extends State<OrderTile> {
  DistanceTime? distanceTime1;
  DistanceTime? distanceTime2;
  final location = Get.find<UserLocationController>();

  @override
  void initState() {
    super.initState();
    fetchDistance1();
    fetchDistance2();
  }

  Future<void> fetchDistance1() async {
    Distance distanceCalculator = Distance();
    DistanceTime? distance = await distanceCalculator.calculateDistanceDurationPrice(
      location.currentLocation.latitude,
      location.currentLocation.longitude,
      widget.order.restaurantCoords[0],
      widget.order.restaurantCoords[1],
      35,
      pricePkm,
    );

    if (distance != null) {
      print('DistanceTime1: ${distance.distance}');
      if (mounted) {
        setState(() {
          distanceTime1 = distance;
        });
      }
    } else {
      print('Error: Distance calculation returned null');
    }
  }

  Future<void> fetchDistance2() async {
    Distance distanceCalculator = Distance();
    DistanceTime? distance = await distanceCalculator.calculateDistanceDurationPrice(
      widget.order.restaurantCoords[0],
      widget.order.restaurantCoords[1],
      widget.order.recipientCoords[0],
      widget.order.recipientCoords[1],
      35,
      pricePkm,
    );

    if (distance != null) {
      if (mounted) {
        setState(() {
          distanceTime2 = distance;
        });
      }
    } else {
      print('Error: Distance calculation returned null');
    }

  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    return GestureDetector(
      onTap: () {
        controller.order = widget.order;
        controller.setTotalDistance = distanceTime1!.distance + distanceTime2!.distance;
        controller.setTotalDistanceFromRestaurantToClient = distanceTime2!.distance;

        if (widget.order.orderStatus == "Delivered") {
          Get.to(() => const DeliveredPage());
        } else {
          Get.to(() => const ActivePage());
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: 100  * widget.order.orderItems.length + 65 ,  // Dynamically set height based on order items
        width: width,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.all(Radius.circular(12)),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 19,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.order.orderItems.map((item) {
                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        height: 90 ,
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
                                  height: 75 ,
                                  width: 70 ,
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
                                  SizedBox(height: 6 ),
                                  ReusableText(
                                    text: item.foodId.title,
                                    style: appStyle(kFontSizeBodySmall, kGray, FontWeight.w500),
                                  ),
                                  SizedBox(height: 6 ),
                                  /*SizedBox(
                                    height: 15 ,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
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
                                            margin: EdgeInsets.only(right: 5 ),
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
                                  ),*/

                                  SizedBox(height: 6 ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3),
                                    margin: EdgeInsets.only(right: 2),
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
              OrderRowText(
                  text: "📌 ${widget.order.restaurantId.coords.address}"),
              OrderRowText(
                  text: "🏠 ${widget.order.deliveryAddress.addressLine1}"),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        color: widget.order.paymentMethod == 'COD'
                            ? kSecondary
                            : kPrimary,
                        borderRadius: BorderRadius.circular(10)),
                    child: ReusableText(
                        text: widget.order.paymentMethod == 'COD'
                            ? "Cash on delivery"
                            : "Paid",
                        style: appStyle(11, const Color(0xFFFFFFFF), FontWeight.w400)),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        color: widget.active == 'ready'
                            ? kSecondary
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10)),
                    child: ReusableText(
                        text: distanceTime1 != null
                            ? "To 📌 ${distanceTime1!.distance.toStringAsFixed(2)} km"
                            : "Loading...",

                        style: appStyle(
                            10,
                            widget.active == 'ready'
                                ? const Color(0xFFFFFFFF)
                                : kGray,
                            FontWeight.w400)),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        color: widget.active == 'active'
                            ? kSecondary
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10)),
                    child: ReusableText(
                        text: distanceTime2 != null
                            ? "From 📌 To 🏠 ${distanceTime2!.distance.toStringAsFixed(2)} km"
                            : "Loading...",
                        style: appStyle(
                            10,
                            widget.active == 'active'
                                ? const Color(0xFFFFFFFF)
                                : kGray,
                            FontWeight.w400)),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10)),
                    child: ReusableText(
                        text: "Php ${widget.order.deliveryFee}",
                        style: appStyle(10, kGray, FontWeight.w400)),
                  ),
                  const SizedBox(width: 4),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: ReusableText(
                        text: distanceTime2 != null
                            ? "⏰ ${distanceTime2!.time.toStringAsFixed(0)} mins"
                            : "Loading...",

                        style: appStyle(10, kGray, FontWeight.w400)),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
      /*Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 90,
            width: width,
            decoration: const BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: SizedBox(
                      height: 85 ,
                      width: 80 ,
                      child: CachedNetworkImageContainer(
                        imagePath: widget.order.orderItems[0].foodId.imageUrl[0],
                        width: 85 ,
                        height: 80 ,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 6 ,
            child: Container(
              width: 60 ,
              height: 19 ,
              decoration: BoxDecoration(
                  color: widget.order.orderStatus == "Out_for_Delivery"
                      ? widget.order.orderStatus == "Delivered"
                      ? kPrimary
                      : kGray
                      : kGray.withOpacity(0.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  )),
              child: Center(
                child: ReusableText(
                  text: widget.order.orderStatus == "Out_for_Delivery"
                      ? "Active"
                      : widget.order.orderStatus == "Delivered"
                      ? "Delivered"
                      : widget.order.orderStatus == "Accepted"
                      ? "Accepted"
                      : "Pick Up",
                  style: appStyle(11, kLightWhite, FontWeight.w500),
                ),
              ),
            ),
          ),
          Positioned(
              right: 70 ,
              top: 6 ,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                child: SizedBox(
                  width: 19 ,
                  height: 19 ,
                  child: Image.network(widget.order.restaurantId.logoUrl,
                      fit: BoxFit.cover),
                ),
              ))
        ],
      ),*/
    );
  }
}

// ignore: must_be_immutable
class OrderRowText extends StatelessWidget {
  const OrderRowText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: ReusableText(
            text: text, style: appStyle(kFontSizeBodySmall, kGray, FontWeight.w400)));
  }
}
