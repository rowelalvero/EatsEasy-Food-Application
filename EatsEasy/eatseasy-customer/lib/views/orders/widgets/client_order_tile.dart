import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/entities/message.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/show_snack_bar.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/contact_controller.dart';
import 'package:eatseasy/hooks/fetchRestaurant.dart';
import 'package:eatseasy/models/client_orders.dart';
import 'package:eatseasy/models/response_model.dart';
import 'package:eatseasy/views/message/chat/view.dart';
import 'package:eatseasy/views/reviews/review_page.dart';
import 'package:get/get.dart';

import '../../restaurant/trackOrder.dart';
import '../track_order_page.dart';

class ClientOrderTile extends HookWidget {
  const ClientOrderTile({
    super.key,
    required this.order,
    this.isRating,

  });

  final ClientOrders order;
  final bool? isRating;
  Future<ResponseModel> loadData() async {

    //prepare the contact list for this user.
    //get the restaurant info from the firebase
    //get only one restaurant info
    return   Get.find<ContactController>().asyncLoadSingleRestaurant();
  }

  void loadChatData ()async{
    ResponseModel response = await  loadData();
    if(response.isSuccess==false){
      showCustomSnackBar(response.message!);
    }
  }
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRestaurant(order.restaurantId);
    var restaurantData ;//= hookResult.data;
    final load = hookResult.isLoading;

    if (load == false) {
      restaurantData = hookResult.data;

      if (restaurantData != null) {
        // Encoding to JSON string
        String jsonString = jsonEncode(restaurantData);


        // Decoding the JSON string back to Map
        Map<String, dynamic> resData = jsonDecode(jsonString);

        // Assigning the restaurant ID to the controller state
        Get.find<ContactController>().state.restaurantId.value = resData["owner"];

        // Load chat data
        loadChatData();
      } else {
        print("restaurantData is null");
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => TrackOrderPage(order: order));
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 80,
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
                    child: Stack(
                      children: [
                        SizedBox(
                            height: 75,
                            width: 85,
                            child: Image.network(
                              order.orderItems[0].foodId.imageUrl[0],
                              fit: BoxFit.cover,
                            )),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 6, bottom: 2),
                              color: kGray.withOpacity(0.6),
                              height: 16,
                              width: width,
                              child: RatingBarIndicator(
                                rating: double.tryParse(order.orderItems[0].foodId.rating.toString()) ?? 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text: order.orderItems[0].foodId.title,
                          style: appStyle(11, kDark, FontWeight.w400)),
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                          text:
                          "ID: ${order.id}",
                          style: appStyle(9, kGray, FontWeight.w400)),
                      const SizedBox(
                        height: 3,
                      ),
                      ReusableText(
                          text:
                          "Date: ${order.orderDate}",
                          style: appStyle(9, kGray, FontWeight.w400)),
                      const SizedBox(
                        height: 3,
                      ),
                      ReusableText(
                          text:
                          "Payment status: ${order.paymentStatus}",
                          style: appStyle(9, kGray, FontWeight.w400)),
                      const SizedBox(
                        height: 3,
                      ),

                      /*SizedBox(
                        height: 18,
                        width: width * 0.67,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: order.customAdditives.length,
                          itemBuilder: (context, i) {
                            // Get the key from the map
                            String key = order.customAdditives.keys.elementAt(i); // Access the key by index
                            var additive = order.customAdditives[key];

                            // Handle case for Toppings which might be a list
                            if (additive is List) {
                              additive = additive.join(', '); // Join list items into a string
                            } else {
                              additive ??= "Unknown";
                            }

                            // Format the display text as "Key: Additive"
                            String displayText = "$key: $additive";

                            return Container(
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                color: kSecondaryLight,
                                borderRadius: BorderRadius.all(Radius.circular(9)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ReusableText(
                                    text: displayText, // Use the formatted display text
                                    style: appStyle(8, kGray, FontWeight.w400),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),*/
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            top: 6,
            child: Container(
              width: 80,
              height: 19,
              decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: ReusableText(
                  text: "Php ${order.grandTotal.toStringAsFixed(2)}",
                  style: appStyle(12, kLightWhite, FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 20,
            child: Container(
              width: 60,
              height: 19,
              decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                      ResponseModel status = await Get.find<ContactController>().goChat(restaurantData);
                      if(status.isSuccess==false){
                        showCustomSnackBar(status.message!, title: status.title!);
                      }
                  },
                  child: ReusableText(
                    text: "Chat",
                    style: appStyle(12, kLightWhite, FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          /*Positioned(
              right: 80,
              top: 6,
              child: Container(
                width: 19,
                height: 19,
                decoration: const BoxDecoration(
                    color: kSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () {
                    
                  },
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.cart_plus,
                      size: 15,
                      color: kLightWhite,
                    ),
                  ),
                ),
              )
          )*/
        ],
      ),
    );
  }
}
