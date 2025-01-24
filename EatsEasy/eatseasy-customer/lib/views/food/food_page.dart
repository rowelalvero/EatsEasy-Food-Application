import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatseasy/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/custom_textfield.dart';
import 'package:eatseasy/common/not_found.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/show_snack_bar.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/cart_controller.dart';
import 'package:eatseasy/controllers/contact_controller.dart';
import 'package:eatseasy/controllers/counter_controller.dart';
import 'package:eatseasy/controllers/food_controller.dart';
import 'package:eatseasy/hooks/fetchRestaurant.dart';
import 'package:eatseasy/models/cart_request.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/models/response_model.dart';
import 'package:eatseasy/views/auth/login_page.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:eatseasy/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../hooks/fetchCart.dart';
import '../../models/obs_custom_additives.dart';
import '../../models/restaurants.dart';

class FoodPage extends StatefulHookWidget {
  const FoodPage({
    super.key,
    required this.food,
    this.quantity,
    this.refetch,
    this.customAdditives
  });

  final Food food;
  final int? quantity;
  final VoidCallback? refetch;
  final Map<String, dynamic>? customAdditives;

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final foodController = Get.put(FoodController());
  final CounterController counterController = Get.put(CounterController());
  final ContactController _controller = Get.put(ContactController());
  final PageController _pageController = PageController();
  final TextEditingController _preferences = TextEditingController();
  final TextEditingController _counter = TextEditingController();
  final cartController = Get.put(CartController());

  @override
  void dispose() {
    _pageController.dispose();
    _preferences.dispose();
    _counter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.quantity != null) {
      _counter.text = widget.quantity.toString();
      counterController.count.value = widget.quantity!;
    } else {
      _counter.text = counterController.count.toString();
    }
  }

  Future<ResponseModel> loadData() async {
    return   _controller.asyncLoadSingleRestaurant();
  }

  void loadChatData ()async{
    ResponseModel response = await  loadData();
    if(response.isSuccess==false){
      showCustomSnackBar(response.message!);
    }
  }

  @override
  Widget build(BuildContext context)  {
    final box = GetStorage();
    final cartController = Get.put(CartController());
    foodController.loadCustomAdditives(widget.food.customAdditives);
    final hookResult = useFetchRestaurant(widget.food.restaurant);
    var restaurantData = hookResult.data;
    final load = hookResult.isLoading;
    late Restaurants? restaurant = restaurantData;

    final cartHookResult = useFetchCart();
    final items = cartHookResult.data ?? [];
    final isLoading = cartHookResult.isLoading;

    List<double> foodPriceList = [];
    List<int> foodQuantityList = [];

    RxBool isThisProductInCart = false.obs;

    if (load == false) {
      restaurantData = hookResult.data;

      if (restaurantData != null) {
        // Encoding to JSON string
        String jsonString = jsonEncode(restaurantData);

        // Decoding the JSON string back to Map
        Map<String, dynamic> resData = jsonDecode(jsonString);

        // Assigning the restaurant ID to the controller state
        _controller.state.restaurantId.value = resData["owner"];

        // Load chat data
        loadChatData();
      } else {
        print("restaurantData is null");
      }
    }
    print(widget.customAdditives);

    String? token = box.read('token');
    return load
        ? Center(
      child: SizedBox(
          width: 150,
          height: 150,
          child: LoadingAnimationWidget.threeArchedCircle(
              color: kSecondary,
              size: 35
          )
      ),
    )
        : Scaffold(
      body: Center(
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: height * 0.1,
                  top: height * 0.05
              ) ,
              child: BackGroundContainer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20.r),
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 230.h,
                                  child: PageView.builder(
                                      itemCount: widget.food.imageUrl.length,
                                      controller: _pageController,
                                      onPageChanged: (i) {
                                        foodController.currentPage(i);
                                      },
                                      itemBuilder: (context, i) {
                                        return Container(
                                          height: 230.h,
                                          width: width,
                                          color: kLightWhite,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: widget.food.imageUrl[i],
                                          ),
                                        );
                                      }),
                                ),
                                Positioned(
                                  bottom: 10,
                                  child: Obx(
                                        () => Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(
                                        widget.food.imageUrl.length,
                                            (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Container(
                                              margin: EdgeInsets.all(4.h),
                                              width:
                                              foodController.currentPage == index
                                                  ? 10
                                                  : 8,
                                              // ignore: unrelated_type_equality_checks
                                              height:
                                              foodController.currentPage == index
                                                  ? 10
                                                  : 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: foodController.currentPage ==
                                                    index
                                                    ? kSecondary
                                                    : kGrayLight,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 40.h,
                            left: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(
                                    Ionicons.chevron_back_circle,
                                    color: kPrimary,
                                    size: 38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              right: 15,
                              child: CustomButton(
                                  btnWidth: 95,
                                  radius: 30,
                                  color: kSecondary,
                                  onTap: () async {
                                    if(restaurantData==null){
                                      Get.to(
                                              () =>  const NotFoundPage(
                                            text: "Can not open restaurant page",
                                          ),
                                          arguments: {});
                                    }else{
                                      ResponseModel status = await _controller.goChat(restaurantData);

                                      if(status.isSuccess==false){
                                        showCustomSnackBar(status.message!, title: status.title!);
                                      }
                                    }
                                  },
                                  text: "Chat")
                          ),
                          Positioned(
                              bottom: 10,
                              right: 120,
                              child: CustomButton(
                                  btnWidth: 180,
                                  radius: 30,
                                  color: kPrimary,
                                  onTap: () {
                                    if(token==null){
                                      showCustomSnackBar("You are not logged in. Your distance measure is not correct", title: "Distance alert",);
                                    }
                                    Get.to(() => restaurantData == null
                                            ? const NotFoundPage(text: "Can not open restaurant page",)
                                            : RestaurantPage(restaurant: restaurantData)
                                    );
                                  },
                                  text: "Open Restaurant"
                              )
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                    text: widget.food.title,
                                    style: appStyle(18, kDark, FontWeight.w600)),
                                Obx(() => ReusableText(
                                    text: "Php ${((widget.food.price + foodController.additiveTotalCustom) * counterController.count.toDouble()).toStringAsFixed(2)}",
                                    style: appStyle(18, kPrimary, FontWeight.w600)),),

                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              widget.food.description,
                              maxLines: 8,
                              style: appStyle(10, kGray, FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.food.rating!,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kPrimary,
                                  ),
                                  itemCount: 5,
                                  itemSize: 15.0,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ReusableText(
                                    text: "${widget.food.ratingCount} ratings",
                                    style: appStyle(9, kGray, FontWeight.w500)),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              height: 15.h,
                              child: ListView.builder(
                                  itemCount: widget.food.foodTags.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    final tag = widget.food.foodTags[i];
                                    return Container(
                                      margin: EdgeInsets.only(right: 5.h),
                                      decoration: BoxDecoration(
                                          color: kPrimary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.r))),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: ReusableText(
                                              text: tag,
                                              style: appStyle(
                                                  8, kLightWhite, FontWeight.w400)),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "${widget.food.stocks} available orders",
                              maxLines: 8,
                              style: appStyle(10, kGray, FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),

                            // Adding a SizedBox with reduced height
                            ReusableText(
                              text: "Additives and Add-ons",
                              style: appStyle(18, kDark, FontWeight.w600),
                            ),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: foodController.customAdditivesList.length,
                              itemBuilder: (context, index) {
                                final question = foodController.customAdditivesList[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.grey, // Set the color of the border
                                      width: 0.4, // Set the width of the border
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ReusableText(
                                          text: question.text,
                                          style: appStyle(16, kDark, FontWeight.w600),
                                        ),
                                        if (question.selectionType == "Select at least" ||
                                            question.selectionType == "Select at most" ||
                                            question.selectionType == "Select exactly") ...[
                                          Text(
                                            '${question.selectionType} ${question.selectionNumber} options.',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                        if (question.required) ...[
                                          const Text(
                                            "Required",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    subtitle: _buildQuestionInput(question),
                                  ),
                                );
                              },
                            ),
                            ReusableText(
                                text: "Preferences",
                                style: appStyle(18, kDark, FontWeight.w600)),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              height: 64.h,
                              child: CustomTextField(
                                  controller: _preferences,
                                  hintText: "Add a note",
                                  maxLines: 3,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter a note";
                                    }
                                    return null;
                                  }),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ReusableText(
                                    text: "Quantity",
                                    style: appStyle(18, kDark, FontWeight.w600)),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          counterController.decrement();
                                          _counter.text = counterController.count.toString();
                                        },
                                        child: const Icon(
                                          AntDesign.minuscircleo,
                                          color: kPrimary,
                                        )
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),

                                    SizedBox(
                                      width: 47.w,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: _counter,
                                        cursorColor: kPrimary,
                                        onChanged: (value) {
                                          setState(() {
                                            counterController.count.value = int.parse(value);
                                          });
                                        },
                                        textAlign: TextAlign.center, // Aligns text to the center
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: kPrimary, width: 0.5),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: kPrimary, width: 0.5),
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          counterController.increment();
                                          _counter.text = counterController.count.toString();
                                        },
                                        child: const Icon(
                                          AntDesign.pluscircleo,
                                          color: kPrimary,
                                        )),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  )
              )
          )
      ),
      bottomSheet: Container(
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
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min, // Ensures the container takes only the space it needs
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50.h,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cartController.isLoading
                        ? Expanded(
                      child: Center(
                        child: LoadingAnimationWidget.waveDots(
                          color: kSecondary,
                          size: 35,
                        ),
                      ),
                    )
                        : Expanded(
                      child: Obx(() {
                        for (var cart in items) {
                          if (cart.productId.id == widget.food.id) {
                            isThisProductInCart.value = true;
                            foodPriceList.add(cart.totalPrice);
                            foodQuantityList.add(cart.quantity);
                          }
                        }

                        return ElevatedButton(
                          onPressed: () async {
                            cartController.setLoading = true;

                            if (token == null) {
                              Get.to(() => const Login());
                            } else {
                              bool hasMissingRequiredAdditives = false;

                              // Check if all required custom additives have been answered
                              for (var question in  foodController.customAdditivesList) {
                                if (question.required && foodController.userResponses[question.text] == null) {
                                  hasMissingRequiredAdditives = true;
                                  break;  // Exit the loop early if any required response is missing
                                }
                              }

                              if (hasMissingRequiredAdditives) {
                                Get.snackbar("Missing required additives", "Please answer all required additives before adding to cart.", icon: const Icon(Icons.warning));
                              } else {
                                if (isThisProductInCart.value) {
                                  await cartController.updateCustomAdditives(widget.food.id, foodController.userResponses);

                                  // Handle the quantity update logic
                                  if (counterController.count.toInt() > foodQuantityList.first) {
                                    await cartController.incrementProductQuantity(widget.food.id, counterController.count.toInt());
                                  } else if (counterController.count.toInt() < foodQuantityList.first) {
                                    await cartController.decrementProductQuantity(widget.food.id, counterController.count.toInt());
                                  }

                                  cartHookResult.refetch();
                                  widget.refetch?.call();

                                  // Show success Snackbar if the cart is updated
                                  if (!cartController.isSnackbarVisible) {
                                    Get.snackbar("Cart updated", "Your cart item has been updated.",
                                        icon: const Icon(Icons.check));
                                    cartController.isSnackbarVisible = true;
                                    Future.delayed(const Duration(seconds: 2), () {
                                      cartController.isSnackbarVisible = false;
                                    });
                                  }
                                } else {
                                  // Proceed with adding item to cart
                                  if (restaurant!.isAvailable) {
                                    if (widget.food.isAvailable == true || restaurant.isAvailable) {
                                      if ((counterController.count.value ?? 0) <= (widget.food.stocks ?? 0)) {
                                        if (_counter.text.isEmpty || counterController.count == '' || counterController.count.value == 0) {
                                          Get.snackbar("Please provide quantity",
                                              "Check your item quantity",
                                              icon: const Icon(Icons.add_alert));
                                        } else {
                                          double totalPrice = (widget.food.price + foodController.additiveTotalCustom) *
                                              counterController.count.toDouble();

                                          ToCart item = ToCart(
                                            productId: widget.food.id,
                                            instructions: _preferences.text,
                                            quantity: counterController.count.toInt(),
                                            totalPrice: totalPrice,
                                            prepTime: widget.food.time!,
                                            restaurant: widget.food.restaurant!,
                                            customAdditives: foodController.userResponses,
                                          );
                                          String cart = toCartToJson(item);

                                          await cartController.addToCart(cart);
                                          cartHookResult.refetch();
                                        }
                                      } else {
                                        Get.snackbar("Quantity exceeded the available stocks",
                                            "Please reduce the quantity of your items",
                                            icon: const Icon(Icons.add_alert));
                                      }
                                    } else {
                                      Get.snackbar("Item unavailable",
                                          "Please come and check later",
                                          icon: const Icon(Icons.add_alert));
                                    }
                                  } else {
                                    Get.snackbar("Restaurant is closed for now",
                                        "Please come and check later",
                                        icon: const Icon(Icons.add_alert));
                                  }
                                }
                              }
                              cartController.setLoading = false;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isThisProductInCart.value ? kPrimary : kGray,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            shadowColor: Colors.grey.withOpacity(0.3),
                          ),
                          child: isThisProductInCart.value
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Text("Cart", style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                                  const Text("       •       ", style: TextStyle(color: kWhite)),
                                  Text("${foodQuantityList.first.toString()} ${foodQuantityList.first == 1 ? "item" : "items"} ", style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Php ${foodPriceList.first.toStringAsFixed(2)}", style: const TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          )
                              : const Text("Add to cart", style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.w600)),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
  Widget _buildQuestionInput(ObsCustomAdditive question) {
    // Access the pre-existing value from customAdditives if it exists
    final customAdditiveValue = widget.customAdditives?[question.text];
    switch (question.type) {
      case 'Multiple Choice':
        return Column(
          children: question.options!.map((option) {
            final optionText = option['optionName'] as String;
            final optionPrice = option['price'] != null ? '(Php ${option['price']})' : '';

            return RadioListTile<String>(
              activeColor: kPrimary,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: Text('$optionText $optionPrice'),
              value: optionText,
              groupValue: foodController.userResponses[question.text] ?? customAdditiveValue,
              onChanged: (value) {
                setState(() {
                  foodController.userResponses[question.text] = value;
                  question.toggleChecked();
                  foodController.getTotalPriceCustomAdditives();
                });
              },
            );
          }).toList(),
        );
      case 'Checkbox':
        return Column(
          children: question.options!.map((option) {
            final optionText = option['optionName'] as String;
            final optionPrice = option['price'] != null ? '(Php ${option['price']})' : '';

            // Get the selected values from customAdditives if available
            final isChecked = (foodController.userResponses[question.text] ?? []).contains(optionText) ||
                (customAdditiveValue != null && customAdditiveValue.contains(optionText));

            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              activeColor: kPrimary,
              checkColor: Colors.white,
              controlAffinity: ListTileControlAffinity.leading,
              tristate: false,
              visualDensity: VisualDensity.compact,
              title: Text('$optionText $optionPrice'),
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  final currentSelections = foodController.userResponses[question.text] ?? [];
                  if (value == true) {
                    if (question.selectionType == 'Select at least' &&
                        currentSelections.length >= question.selectionNumber!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select at least ${question.selectionNumber} options.')),
                      );
                    } else if (question.selectionType == 'Select at most' &&
                        currentSelections.length >= question.selectionNumber!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You can select a maximum of ${question.selectionNumber} options.')),
                      );
                    } else if (question.selectionType == 'Select exactly' &&
                        currentSelections.length == question.selectionNumber!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You can select exactly ${question.selectionNumber} options.')),
                      );
                    } else {
                      foodController.userResponses[question.text] = [...currentSelections, optionText];
                    }
                  } else {
                    foodController.userResponses[question.text]?.remove(optionText);
                  }
                  question.toggleChecked();
                  foodController.getTotalPriceCustomAdditives();
                });
              },
            );
          }).toList(),
        );
      case 'Short Answer':
        return TextField(
          controller: TextEditingController(text: customAdditiveValue),
          onChanged: (value) {
            foodController.userResponses[question.text] = value;
          },
        );
      case 'Paragraph':
        return TextField(
          maxLines: 3,
          controller: TextEditingController(text: customAdditiveValue),
          onChanged: (value) {
            foodController.userResponses[question.text] = value;
          },
        );
      case 'Linear Scale':
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                question.maxScale!.toInt() - question.minScale!.toInt() + 1,
                    (index) => Text(
                  '${question.minScale!.toInt() + index}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            Slider(
              value: (foodController.userResponses[question.text] ?? customAdditiveValue ?? question.minScale ?? 1.0).toDouble(),
              min: question.minScale?.toDouble() ?? 1.0,
              max: question.maxScale?.toDouble() ?? 10.0,
              divisions: (question.maxScale! - question.minScale!).toInt(),
              label: (foodController.userResponses[question.text]?.toInt() ?? customAdditiveValue?.toInt() ?? 1).toString(),
              onChanged: (value) {
                setState(() {
                  foodController.userResponses[question.text] = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(question.minScaleLabel ?? ''),
                Text(question.maxScaleLabel ?? ''),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
