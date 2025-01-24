import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/views/cart/widgets/restaurant_cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/hooks/fetchCart.dart';
import 'package:eatseasy/models/user_cart.dart';
import 'package:eatseasy/views/auth/widgets/login_redirect.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/login_controller.dart';
import '../../hooks/fetchAllNearbyRestaurants.dart';
import '../../hooks/fetchDefaultAddress.dart';
import '../../models/login_response.dart';
import '../../models/restaurants.dart';
import '../entrypoint.dart';

class RestaurantCartPage extends HookWidget {
  const RestaurantCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final token = box.read('token');
    final controller = Get.put(LoginController());
    LoginResponse? user;
    if (token != null) {
      user = controller.getUserData();
      useFetchDefault(context, false);
    }

    final hookResult = useFetchCart();
    final items = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    final refetch = hookResult.refetch;

    final restaurantHookResult = useFetchAllRestaurants("1400");
    final restaurants = restaurantHookResult.data ?? [];

    useEffect(() {
      refetch();
      return null;
    }, []);

    return token == null
        ? const LoginRedirection()
        : Scaffold(
      appBar: AppBar(
        backgroundColor: kLightWhite,
        elevation: 0.3,
        title: Center(
          child: ReusableText(
            text: "Cart",
            style: appStyle(20, kDark, FontWeight.w400),
          ),
        ),
      ),
      body: Center(
        child: BackGroundContainer(
          child: RefreshIndicator(
            color: kPrimary,
            onRefresh: () async {
              refetch();
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: isLoading
                  ? const Center(child: FoodsListShimmer())
                  : items.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_content.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    ReusableText(
                      text:
                      "Your cart is empty!",
                      style: appStyle(14, kGray, FontWeight.normal),
                    ),
                    ReusableText(
                      text:
                      "Discover delicious dishes and add them to your cart.",
                      style: appStyle(14, kGray, FontWeight.normal),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        // Redirect user to restaurant browsing or home page
                        Get.offAll(() => MainScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Browse Foods",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: restaurants.length,
                physics: const AlwaysScrollableScrollPhysics(), // Allows refresh indicator
                itemBuilder: (context, i) {
                  Restaurants restaurant = restaurants[i];
                  List<UserCart> matchingCarts = items.where((cart) => cart.restaurant == restaurant.id).toList();

                  if (matchingCarts.isNotEmpty) {
                    return RestaurantCartTile(
                      restaurant: restaurant,
                      user: user!,
                    );
                  }
                  return const SizedBox.shrink(); // Return empty widget if no match
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
