/*
// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/common/divida.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/address_controller.dart';
import 'package:eatseasy/controllers/order_controller.dart';
import 'package:eatseasy/hooks/fetchDefaultAddress.dart';
import 'package:eatseasy/models/distance_time.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/models/order_item.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:eatseasy/services/distance.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:eatseasy/views/orders/payment.dart';
import 'package:eatseasy/views/orders/widgets/order_tile.dart';
import 'package:eatseasy/views/profile/add_new_place.dart';
import 'package:eatseasy/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class OrderPage extends HookWidget {
  OrderPage(
      {super.key,
      required this.item,
      required this.restaurant,
      required this.food});

  final OrderItem item;
  final Restaurants restaurant;
  final Food food;

  final TextEditingController _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    final orderController = Get.put(OrderController());
    final hookResult = useFetchDefault(context, false);

    final distanceTime = useState<DistanceTime?>(null);
    final totalTime = useState<double>(30);
    final grandPrice = useState<double>(0);
    final totalAmount = useState<num>(0);

    RxBool _isLoading = false.obs;

    setLoading(bool newValue) {
      _isLoading.value = newValue;
    }

    Future<void> fetchDistance() async {
      Distance distanceCalculator = Distance();
      distanceTime.value = await distanceCalculator.calculateDistanceDurationPrice(
        controller.defaultAddress!.latitude,
        controller.defaultAddress!.longitude,
        restaurant.coords.latitude,
        restaurant.coords.longitude,
        35,
        pricePkm,
      );
    }

    useEffect(() {
      num newTotalAmount = 0;

      fetchDistance().then((_) {
        if (distanceTime.value != null) {
          totalTime.value += distanceTime.value!.time;

          totalAmount.value = newTotalAmount; // Update state with new total
          grandPrice.value = double.parse(item.price) + distanceTime.value!.price;

        } else {
          // Handle null distanceTime, e.g., set a default value
          totalAmount.value = newTotalAmount;
          grandPrice.value = totalAmount.value.toDouble(); // Assuming no additional price
        }
      });

      return null; // Effect cleanup not needed
    }, [distanceTime]);

    return Obx(() => orderController.paymentUrl.contains("https")
        ? const PaymentWebView()
        : Scaffold(
            backgroundColor: kOffWhite,
            appBar: AppBar(
              backgroundColor: kOffWhite,
              elevation: 0,
              centerTitle: true,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(CupertinoIcons.back)),
              title: Center(
                child: Text(
                  "Order Details",
                  style: appStyle(14, kDark, FontWeight.w500),
                ),
              ),
            ),
            body: BackGroundContainer(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  OrderTile(food: food),
                  Container(
                    width: width,
                    height: height / 2.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReusableText(
                                  text: restaurant.title!,
                                  style: appStyle(20, kGray, FontWeight.bold)),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: kTertiary,
                                backgroundImage:
                                    NetworkImage(restaurant.imageUrl!),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RowText(
                              first: "Business Hours", second: restaurant.time),
                          SizedBox(
                            height: 5,
                          ),
                          const Divida(),
                          RowText(
                            first: "Distance To Restaurant",
                            second: distanceTime.value != null
                                ? "${distanceTime.value!.distance.toStringAsFixed(2)} km"
                                : "Loading...",
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RowText(
                            first: "Delivery fee",
                            second: distanceTime.value != null
                                ? "\$ ${distanceTime.value!.price.toStringAsFixed(2)}"
                                : "Loading...",
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RowText(
                              first: "Estimated Delivery Time",
                              second: distanceTime.value != null
                                  ? "${"${totalTime.value.toStringAsFixed(0)} - ${(totalTime.value + distanceTime.value!.time).toStringAsFixed(0)}" } mins."
                                  : "Loading..."
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RowText(
                              first: "Subtotal", second: "\$ ${item.price}"),
                          SizedBox(
                            height: 5,
                          ),
                          RowText(
                              first: "Total",
                              second: "\$ ${grandPrice.value.toStringAsFixed(2)}"),
                          SizedBox(
                            height: 10,
                          ),
                          const Divida(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.3,
                                child: ReusableText(
                                    text: "Recipient",
                                    style:
                                        appStyle(10, kGray, FontWeight.w500)),
                              ),
                              SizedBox(
                                width: width * 0.585,
                                child: Text(
                                    controller.userAddress ??
                                        "Provide an address to proceed ordering",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style:
                                        appStyle(10, kGray, FontWeight.w400)),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: RowText(
                                first: "Phone ",
                                second: _phone.text.isEmpty
                                    ? "Tap to add a phone number before ordering"
                                    : _phone.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  controller.defaultAddress == null
                      ? CustomButton(
                          onTap: () {
                            Get.to(() => const AddNewPlace());
                          },
                          radius: 9,
                          color: kPrimary,
                          btnWidth: width * 0.95,
                          btnHieght: 34,
                          text: "Add Default Address",
                        )
                      : orderController.isLoading
                          ? LoadingAnimationWidget.waveDots(
                              color: kPrimary,
                              size: 35
                            )
                          : CustomButton(
                              onTap: () {
                                if (distanceTime.value!.distance > 10.0) {
                                  Get.snackbar(
                                      colorText: kDark,
                                      backgroundColor: kOffWhite,
                                      "Distance Alert",
                                      "You are too far from the restaurant, please order from a restaurant closer to you ");
                                  return;
                                } else {
                                  Order order = Order(
                                      userId: controller.defaultAddress!.userId,
                                      orderItems: [item],
                                      orderTotal: item.price,
                                      restaurantAddress:
                                          restaurant.coords.address,
                                      restaurantCoords: [
                                        restaurant.coords.latitude,
                                        restaurant.coords.longitude
                                      ],
                                      recipientCoords: [
                                        controller.defaultAddress!.latitude,
                                        controller.defaultAddress!.longitude
                                      ],
                                      deliveryFee:distanceTime.value!.price.toStringAsFixed(2),
                                      grandTotal: grandPrice.value.toStringAsFixed(0),
                                      deliveryAddress:controller.defaultAddress!.id,
                                      paymentMethod: "STRIPE",
                                      restaurantId: restaurant.id!,
                                      deliveryOption: '');

                                  String orderData = orderToJson(order);

                                  orderController.order = order;

                                  orderController.createOrder(orderData, order);
                                }
                              },
                              radius: 9,
                              color: kPrimary,
                              btnWidth: width * 0.95,
                              btnHieght: 44,
                              text: "P R O C E E D  T O  P A Y M E N T",
                            ),
                ],
              ),
            )));
  }
}
*/
