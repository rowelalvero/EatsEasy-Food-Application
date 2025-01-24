import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/models/login_response.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchCart.dart';
import 'package:eatseasy/models/user_cart.dart';
import 'package:eatseasy/views/auth/widgets/login_redirect.dart';
import 'package:eatseasy/views/cart/widgets/cart_tile.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../common/divida.dart';
import '../../controllers/address_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/order_controller.dart';
import '../../hooks/fetchFoods.dart';
import '../../models/distance_time.dart';
import '../../models/foods.dart';
import '../../models/order_item.dart';
import '../../services/distance.dart';
import '../entrypoint.dart';
import '../home/widgets/custom_btn.dart';
import '../orders/payment.dart';
import '../profile/profile_screen.dart';
import '../profile/saved_places.dart';
import '../profile/add_new_place.dart';
import '../restaurant/restaurants_page.dart'; // Import for using min function

class ItemCartPage extends HookWidget {
  const ItemCartPage({super.key, required this.restaurant, required this.user});
  final Restaurants restaurant;
  final LoginResponse user;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    final orderController = Get.put(OrderController());
    final location = Get.put(UserLocationController());
    late GoogleMapController mapController;
    final box = GetStorage();
    String? token = box.read('token');

    final hookResult = useFetchCart();
    final items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

// Fetching foods data
    final foodHookResult = useFetchFood();
    final foods = foodHookResult.data ?? [];

// Map food items by their IDs for quick lookup
    final Map<String, Food> foodMap = {for (var food in foods) food.id.toString(): food};

// Ensure matchingCarts is populated outside the builder
    List<OrderItem> matchingCarts = [];
    List<String> foodTimeList = [];

    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    LatLng me = LatLng(
      controller.defaultAddress!.latitude,
      controller.defaultAddress!.longitude,);

    final selectedDeliveryOption = useState<String>('Standard');
    String deliveryOption = selectedDeliveryOption.value;

    final selectedPaymentMethod = useState<String>('STRIPE');
    String paymentMethod = selectedPaymentMethod.value;

    final distanceTime = useState<DistanceTime?>(null);
    final standardDeliveryTime = useState<double>(0); // Initialize with base time
    final totalDeliveryOptionTime = useState<double>(0);

    final orderForLaterDelivery = useState<String>('Today');
    String deliveryDate = orderForLaterDelivery.value;
    /*final orderForLaterDeliveryDate = useState<String>('');
    final orderForLaterDeliveryTime = useState<String>('');*/

    final orderSubTotal = useState<num>(0);
    final totalDeliveryOptionPrice = useState<double>(0);
    final standardDeliveryPrice = useState<double>(0);
    final total = useState<double>(0);

    Future<void> selectDeliveryOption(String selectedDeliveryOption) async {
      if (selectedDeliveryOption == 'Priority') {
        totalDeliveryOptionTime.value = standardDeliveryTime.value - 10; // Priority reduces 10 mins
        totalDeliveryOptionPrice.value = standardDeliveryPrice.value + 20;
        total.value = orderSubTotal.value.toDouble() + totalDeliveryOptionPrice.value;
      } else if (selectedDeliveryOption == 'Saver') {
        totalDeliveryOptionTime.value = standardDeliveryTime.value + 15; // Saver adds 15 mins
        totalDeliveryOptionPrice.value = standardDeliveryPrice.value - 10;
        total.value = orderSubTotal.value.toDouble() + totalDeliveryOptionPrice.value;
      } else if (selectedDeliveryOption == 'Standard') {
        totalDeliveryOptionTime.value = standardDeliveryTime.value; // Standard, no change
        totalDeliveryOptionPrice.value = standardDeliveryPrice.value;
        total.value = orderSubTotal.value.toDouble() + totalDeliveryOptionPrice.value;
      } else {
        //totalDeliveryOptionTime.value = standardDeliveryTime.value + 15; // Saver adds 15 mins
        //orderForLaterDelivery.value = "${orderForLaterDeliveryDate.value}, ${orderForLaterDeliveryTime.value}";
        totalDeliveryOptionPrice.value = standardDeliveryPrice.value - 6;
        total.value = orderSubTotal.value.toDouble() + totalDeliveryOptionPrice.value;
      }
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
      num orderTotalAmount = 0;

      fetchDistance().then((_) {
        if (distanceTime.value != null) {
          standardDeliveryTime.value += distanceTime.value!.time;
          for (var cart in items) {
            if (cart.restaurant == restaurant.id) {
              orderTotalAmount += cart.totalPrice;
              foodTimeList.add(cart.prepTime);
            }
          }
          List<int> intList = foodTimeList.map(int.parse).toList();
          int highestNumber = 0; // Default value if list is empty
          if (intList.isNotEmpty) {
            highestNumber = intList.reduce((current, next) => current > next ? current : next);
          }
          standardDeliveryTime.value += highestNumber.toDouble();
          totalDeliveryOptionTime.value = standardDeliveryTime.value;

          orderSubTotal.value = orderTotalAmount; // Update state with new total
          standardDeliveryPrice.value = distanceTime.value!.price;
          totalDeliveryOptionPrice.value = standardDeliveryPrice.value;
          total.value = orderSubTotal.value.toDouble() + totalDeliveryOptionPrice.value;
        } else {
          // Handle null distanceTime, e.g., set a default value
          orderSubTotal.value = orderTotalAmount;
          total.value = orderSubTotal.value.toDouble(); // Assuming no additional price
        }
      });

      return null; // Effect cleanup not needed
    }, [items]);

    if (isLoading) {
      // If still loading, show a loading indicator or nothing
      return Scaffold(
          appBar: AppBar(
            backgroundColor: kLightWhite,
            elevation: 0.3,
            centerTitle: true,
            title: ReusableText(
              text: "Cart",
              style: appStyle(20, kDark, FontWeight.w400),
            ),
          ),
          body: const FoodsListShimmer() );// or any other loading widget
    }

    if (items.isEmpty) {
      // If items are empty after loading, navigate to the home screen
      Future.delayed(Duration.zero, () {
        Get.offAll(() => const MainScreen());
      });
      return const SizedBox.shrink(); // Return an empty widget to stop rendering the ListView
    }
    return token == null
        ? const LoginRedirection()
        : Scaffold(
      appBar: AppBar(
        backgroundColor: kLightWhite,
        elevation: 0.3,
        centerTitle: true,
        title: ReusableText(
          text: "Cart",
          style: appStyle(20, kDark, FontWeight.w400),
        ),
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.only(bottom: height * 0.2), child: BackGroundContainer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address Section
                      Row(
                        children: [
                          const Icon(
                            Entypo.location_pin,
                            color: kDark,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          ReusableText(
                              text: "Delivery Address",
                              style: appStyle(20, kDark, FontWeight.w400)),
                        ],
                      ),

                      Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(9)),
                                border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: 150,
                                      child: GoogleMap(
                                        onMapCreated: onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                          target: me,
                                          zoom: 16,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId('Me'),
                                            draggable: true,
                                            position: me,
                                          ),
                                        },
                                      ),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(controller.defaultAddress!.addressLine1,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(() => SavedPlaces(cartRefetch: refetch));
                                        },
                                        child: const Text('Edit'),
                                      ),
                                    ],
                                  )
                                ],)
                          )
                      ),

                      // Delivery Options Section
                      ReusableText(
                          text: "Delivery options",
                          style: appStyle(20, kDark, FontWeight.w400)),
                      const SizedBox(height: 8),
                      ReusableText(
                          text: "Distance from you: ${distanceTime.value != null
                              ? "${distanceTime.value!.distance.toStringAsFixed(2)} km"
                              : "Loading..."}",
                          style: appStyle(11, kDark, FontWeight.w400)),
                      const SizedBox(height: 8),

                      /*Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(9)),
                            border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                          ),
                          child: // Priority Option
                          RadioListTile(
                            activeColor: kPrimary,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text('Priority < ${standardDeliveryTime.value.toStringAsFixed(0)} mins'),
                                Text('Php ${(standardDeliveryPrice.value + 20).toStringAsFixed(2)}'),
                              ],
                            ),
                            subtitle: const Text('Shortest waiting time to get your order.'),
                            value: 'Priority',
                            groupValue: selectedDeliveryOption.value,
                            onChanged: (value) {
                              selectDeliveryOption(value!);
                              selectedDeliveryOption.value = value;
                            },
                          ),
                        ),
                      ),*/
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(9)),
                            border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                          ),
                          child: // Priority Option
                          // Standard Option
                          RadioListTile(
                            activeColor: kPrimary,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Standard • ${standardDeliveryTime.value.toStringAsFixed(0)} mins'),
                                Text('Php ${standardDeliveryPrice.value.toStringAsFixed(2)}'),
                              ],
                            ),
                            value: 'Standard',
                            groupValue: selectedDeliveryOption.value,
                            onChanged: (value) {
                              selectDeliveryOption(value!);
                              selectedDeliveryOption.value = value;
                            },
                          ),
                        ),
                      ),
                      /*standardDeliveryPrice.value > baseDeliveryFee ?
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(9)),
                            border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width

                          ),
                          child: // Priority Option
                          // Standard Option
                          RadioListTile(
                            activeColor: kPrimary,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Saver • ${(standardDeliveryTime.value + 15).toStringAsFixed(0)} mins'),
                                Text('Php ${(standardDeliveryPrice.value - 10).toStringAsFixed(2)}'),
                              ],
                            ),
                            value: 'Saver',
                            groupValue: selectedDeliveryOption.value,
                            onChanged: (value) {
                              selectDeliveryOption(value!);
                              selectedDeliveryOption.value = value;
                            },
                          ),
                        ),
                      ) : const SizedBox.shrink(),*/
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(9)),
                            border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                          ),
                          child: // Priority Option
                          // Standard Option
                          RadioListTile(
                            activeColor: kPrimary,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Order for later'),
                                Text('Php ${(standardDeliveryPrice.value + 6).toStringAsFixed(2)}'),
                              ],
                            ),
                            value: 'Order for later',
                            groupValue: selectedDeliveryOption.value,
                            onChanged: (value) async {
                              // Show the bottom sheet and wait for result
                              String? result = await showModalBottomSheet<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  DateTime selectedDate = DateTime.now();
                                  TimeOfDay selectedTime = TimeOfDay.now();

                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 20,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Select delivery day and time",
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 20),
                                            // Date Picker
                                            ElevatedButton(
                                              onPressed: () async {
                                                final DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime.now(),  // Prevents past dates
                                                  lastDate: DateTime(2100),
                                                );
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    selectedDate = pickedDate;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                "Selected Date: ${DateFormat('EEE, M/ d/ y').format(selectedDate)}",
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            // Time Picker
                                            ElevatedButton(
                                              onPressed: () async {
                                                final TimeOfDay? pickedTime = await showTimePicker(
                                                  context: context,
                                                  initialTime: selectedTime,
                                                );
                                                if (pickedTime != null) {
                                                  setState(() {
                                                    selectedTime = pickedTime;
                                                  });
                                                }
                                              },
                                              child: Text("Selected Time: ${selectedTime.format(context)}"),
                                            ),
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () {
                                                // Return the selected date and time as a result
                                                String selectedDateTime = '${DateFormat('EEE, M/ d').format(selectedDate)}, ${selectedTime.format(context)}';
                                                Navigator.pop(context, selectedDateTime);  // Pop with result
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );

                              // Once the modal is closed, process the returned result
                              if (result != null) {
                                orderForLaterDelivery.value = result;  // Store the result
                                selectedDeliveryOption.value = value!;
                              }
                            },

                          ),
                        ),
                      ),
                      restaurant.pickup == true ?
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(9)),
                            border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                          ),
                          child: // Priority Option
                          // Standard Option
                          RadioListTile(
                            activeColor: kPrimary,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Pick up'),
                                Text('Php ${(standardDeliveryPrice.value - 6 ).toStringAsFixed(2)}'),
                              ],
                            ),
                            value: 'Pick up',
                            groupValue: selectedDeliveryOption.value,
                            onChanged: (value) {
                              selectDeliveryOption(value!);
                              selectedDeliveryOption.value = value;
                            },
                          ),
                        ),
                      ) : const SizedBox.shrink(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(9)),
                      border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Entypo.list,
                              color: kDark,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            ReusableText(
                              text: "Order summary",
                              style: appStyle(20, kDark, FontWeight.w400),
                            ),
                          ],
                        ),

                        isLoading
                            ? const FoodsListShimmer()
                            : Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(9))),

                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            itemBuilder: (context, i) {
                              UserCart cart = items[i];

                              // Ensure both keys and IDs are strings
                              Food? matchedFood = foodMap[cart.productId.id.toString()];

                              // Check if both conditions are met: restaurant ID matches and food is found
                              if (cart.restaurant == restaurant.id && matchedFood != null) {
                                OrderItem orderItem = OrderItem(
                                  foodId: cart.productId.id,
                                  quantity: cart.quantity.toString(),
                                  price: cart.totalPrice.toStringAsFixed(2),
                                  instructions: cart.instructions,
                                  cartItemId: cart.id,
                                  customAdditives: cart.customAdditives,
                                );

                                matchingCarts.add(orderItem); // Add to the matchingCarts list

                                return CartTile(
                                  item: cart,
                                  food: matchedFood, // Pass the matched Food to CartTile
                                  refetch: refetch,
                                );
                              } else {
                                // Return empty widget if no match
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RowText(
                              first: "Estimated delivery time",
                              second:
                              orderForLaterDelivery.value != 'Today'
                                  ? orderForLaterDelivery.value
                                  : distanceTime.value != null
                                  ? "${"${totalDeliveryOptionTime.value.toStringAsFixed(0)} - ${(totalDeliveryOptionTime.value + distanceTime.value!.time).toStringAsFixed(0)}" } mins."
                                  : "Loading...",
                            ),
                            RowText(
                              first: "Delivery fee",
                              second: distanceTime.value != null
                                  ? "\Php ${totalDeliveryOptionPrice.value.toStringAsFixed(2)}"
                                  : "Loading...",
                            ),
                            RowText(
                              first: "Subtotal",
                              second: distanceTime.value != null
                                  ? "\Php ${orderSubTotal.value.toStringAsFixed(2)}"
                                  : "Loading...",
                            ),
                            const Divida(),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total: ",
                                  style: TextStyle(
                                    color: kDark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    isLoading
                                        ? Container()
                                        : Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text(
                                        total.value % 1 == 0
                                            ? " Php ${total.value.toStringAsFixed(0)}"
                                            : " Php ${total.value.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: kDark,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Rest of your widgets
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(9)),
                      border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Entypo.wallet,
                              color: kDark,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            ReusableText(
                              text: "Payment method",
                              style: appStyle(20, kDark, FontWeight.w400),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(9)),
                              border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                            ),
                            child: // Priority Option
                            // Standard Option
                            RadioListTile(
                              activeColor: kPrimary,
                              title: const Row(
                                children: [
                                  Icon(
                                    Entypo.wallet,
                                    color: kDark,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Wallet'),
                                ],
                              ),
                              value: 'STRIPE',
                              groupValue: selectedPaymentMethod.value,
                              onChanged: (value) {
                                //selectDeliveryOption(value!);
                                selectedPaymentMethod.value = value!;
                              },
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(9)),
                              border: Border.all(color: Colors.grey, width: 0.2),  // Add border line color and width
                            ),
                            child: // Priority Option
                            // Standard Option
                            RadioListTile(
                              activeColor: kPrimary,
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.money_rounded,
                                    color: kDark,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Cash on delivery'),
                                ],
                              ),
                              value: 'COD',
                              groupValue: selectedPaymentMethod.value,
                              onChanged: (value) {
                                //selectDeliveryOption(value!);
                                selectedPaymentMethod.value = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),),
      ),
      bottomSheet: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), // Adjust the radius value as needed
        child: BottomAppBar(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: const CircularNotchedRectangle(),
          height: height * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total: ",
                    style: TextStyle(
                      color: kDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      isLoading
                          ? Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: kPrimary,
                          size: 35,
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          total.value % 1 == 0
                              ? " Php ${total.value.toStringAsFixed(0)}"
                              : " Php ${total.value.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: kDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.defaultAddress == null
                          ? CustomButton(
                        onTap: () {
                          Get.to(() => const AddNewPlace());
                        },
                        radius: 9,
                        color: kPrimary,
                        btnWidth: width * 0.85,
                        btnHieght: 34.h,
                        text: "Add Default Address",
                      )
                          : orderController.isLoading
                          ? Center(
                        child: LoadingAnimationWidget.waveDots(
                            color: kPrimary,
                            size: 35
                        ),
                      )
                          : Expanded(
                        child: CustomButton(
                          onTap: () {
                            if(location.defaultAddress == null) {
                              _showVerificationSheet(context);
                            } else {
                              if (distanceTime.value!.distance > 10.0) {
                                Get.snackbar(
                                  "Distance Alert",
                                  "You are too far from the restaurant, please order from a restaurant closer to you ",
                                );
                                return;
                              } else {
                                print(paymentMethod);

                                Order order = Order(
                                    userId: controller.defaultAddress!.userId,
                                    orderItems: matchingCarts,
                                    orderTotal: orderSubTotal.value.toStringAsFixed(2),
                                    restaurantAddress: restaurant.coords.address,
                                    restaurantCoords: [
                                      restaurant.coords.latitude,
                                      restaurant.coords.longitude,
                                    ],
                                    recipientCoords: [
                                      controller.defaultAddress!.latitude,
                                      controller.defaultAddress!.longitude,
                                    ],
                                    deliveryFee: totalDeliveryOptionPrice.value.toStringAsFixed(2),
                                    deliveryDate: deliveryDate,
                                    grandTotal: total.value.toStringAsFixed(2),
                                    deliveryAddress: controller.defaultAddress!.id,
                                    paymentMethod: paymentMethod,
                                    restaurantId: restaurant.id!,
                                    deliveryOption: deliveryOption
                                );

                                String orderData = orderToJson(order);

                                orderController.order = order;

                                orderController.createOrder(orderData, order);
                              }
                            }
                          },
                          radius: 24,
                          color: kPrimary,
                          btnHieght: 50,
                          text: "Proceed to payment",
                        ),
                      ),
                    ],
                  ),

              )

            ],
          ),
        ),
      ),
    );
  }
  Future<dynamic> _showVerificationSheet(BuildContext context) {
    return showModalBottomSheet(
        enableDrag: false,
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        barrierColor: kGrayLight.withOpacity(0.2),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 700,
            width: width,
            decoration: const BoxDecoration(
              /*image: DecorationImage(
                    image: AssetImage(
                      "assets/images/restaurant_bk.png",
                    ),
                    fit: BoxFit.fill),*/
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ReusableText(
                      text: "Add Default Address",
                      style: appStyle(20, kPrimary, FontWeight.bold)),
                  SizedBox(
                      height: 300,
                      child: ListView.builder(
                          itemCount: reasonsToAddAddress.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              visualDensity: VisualDensity.compact,
                              minVerticalPadding: 0,
                              title: Text(
                                reasonsToAddAddress[index],
                                textAlign: TextAlign.justify,
                                style:
                                appStyle(12, kGray, FontWeight.normal),
                              ),
                              leading: const Icon(
                                Icons.check_circle_outline,
                                color: kPrimary,
                              ),
                            );
                          })),
                  SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                      onTap: () {
                        Get.to(() => const SavedPlaces());
                      },
                      btnHieght: 40,
                      text: "Proceed profile page"),
                ],
              ),
            ),
          );
        });
  }
}

