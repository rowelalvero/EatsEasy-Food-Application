import 'package:eatseasy/models/foods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/cart_controller.dart';
import 'package:eatseasy/models/user_cart.dart';
import 'package:get/get.dart';

import '../../../hooks/fetchCart.dart';
import '../../entrypoint.dart';
import '../../food/food_page.dart';

class CartTile extends HookWidget {
  const CartTile({
    super.key,
    required this.item,
    required this.refetch,
    required this.food,
    
  });
  final UserCart item;
  final VoidCallback refetch;
  final Food food;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final hookResult = useFetchCart();
    final items = hookResult.data ?? [];
    return GestureDetector(
      onTap: () {
        Get.to(() => FoodPage(food: food, quantity: item.quantity, refetch: refetch, customAdditives: item.customAdditives));
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 80,
            decoration: const BoxDecoration(
                color: kLightWhite,
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
                            item.productId.imageUrl[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.only(left: 6, bottom: 2),
                            color: kGray.withOpacity(0.6),
                            height: 16,
                            width: 85,
                            child: RatingBarIndicator(
                              rating: item.productId.rating!,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 15.0,
                              direction: Axis.horizontal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ReusableText(
                          text: item.productId.title,
                          style: appStyle(11, kDark, FontWeight.w400),
                        ),
                        const SizedBox(height: 10),
                        ReusableText(
                          text: "Delivery time: ${item.productId.restaurant}",
                          style: appStyle(9, kGray, FontWeight.w400),
                        ),
                        ReusableText(
                          text: "Quantity: ${item.quantity}",
                          style: appStyle(9, kGray, FontWeight.w400),
                        ),
                        /*Row(
                          children: [
                            ReusableText(
                              text: "Quantity: ",
                              style: appStyle(9, kGray, FontWeight.w400),
                            ),
                            // Decrement Button
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                size: 16,
                                color: kPrimary,
                              ),
                              onPressed: () async {
                                await controller.decrementProductQuantity(item.productId.id);
                                refetch();
                              },
                            ),
                            Text(
                              "${item.quantity}",
                              style: appStyle(10, kDark, FontWeight.w500),
                            ),
                            // Increment Button
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                size: 16,
                                color: kPrimary,
                              ),
                              onPressed: () async {
                                await controller.incrementProductQuantity(item.productId.id);
                                refetch();
                              },
                            ),
                          ],
                        ),*/
                        SizedBox(
                          height: 18,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: item.customAdditives.length,
                            itemBuilder: (context, i) {
                              String key = item.customAdditives.keys.elementAt(i);
                              var additive = item.customAdditives[key];
                              additive = additive is List ? additive.join(', ') : additive ?? "Unknown";

                              return Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: const BoxDecoration(
                                  color: kSecondaryLight,
                                  borderRadius: BorderRadius.all(Radius.circular(9)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ReusableText(
                                    text: "$key: $additive",
                                    style: appStyle(8, kGray, FontWeight.w400),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
          ),
          Positioned(
            right: 10,
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
                  text: "Php ${item.totalPrice.toStringAsFixed(2)}",
                  style: appStyle(12, kLightWhite, FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
              right: 95,
              top: 6,
              child: Container(
                width: 19.h,
                height: 19.h,
                decoration: const BoxDecoration(
                    color: kSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () async {
                    await controller.removeFormCart(item.id, refetch: refetch);
                    Get.snackbar("Product removed",
                        "The product was removed from cart successfully",
                        icon: const Icon(Icons.add_alert));
                  },
                  child: const Center(
                    child: Icon(
                      MaterialCommunityIcons.delete,
                      size: 15,
                      color: kLightWhite,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
