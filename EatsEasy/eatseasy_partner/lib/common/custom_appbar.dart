import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/login_controller.dart';
import 'package:eatseasy_partner/controllers/restaurant_controller.dart';
import 'package:eatseasy_partner/controllers/updates_controllers/new_orders_controller.dart';
import 'package:eatseasy_partner/controllers/updates_controllers/picked_controller.dart';
import 'package:eatseasy_partner/controllers/updates_controllers/ready_for_pick_up_controller.dart';
import 'package:eatseasy_partner/views/profile/profile_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../views/auth/login_page.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    super.key,
    this.type,
    this.title,
    this.heading,
    this.onTap,
    this.onRestaurantIdNull,
  });

  final bool? type;
  final String? title;
  final String? heading;
  final void Function()? onTap;
  final void Function()? onRestaurantIdNull;

  Stream<Map<String, dynamic>> restaurantStream(String restaurantId) {
    DatabaseReference restaurantRef = FirebaseDatabase.instance.ref(restaurantId);
    return restaurantRef.onValue.map((event) {
      final restaurantData = event.snapshot.value as Map<dynamic, dynamic>;
      return Map<String, dynamic>.from(restaurantData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final restaurantController = Get.put(RestaurantController());
    final outForDeliveryController = Get.put(ReadyForPickUpController());
    final pickedController = Get.put(PickedController());
    final newOrderController = Get.put(NewOrdersController());
    final controller = Get.put(LoginController());
    bool? status = box.read('status');
    String? id = box.read('restaurantId');

    // Check if the restaurantId is null and navigate to LoginPage
    if (id == null) {
      if (onRestaurantIdNull != null) {
        onRestaurantIdNull!();
      }
      // Navigate to LoginPage if restaurantId is null
      Get.offAll(() => const Login());
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: kRed, size: 40),
            SizedBox(height: 10.h),
            Text(
              "You did not set up the restaurant or it is not approved yet.",
              style: TextStyle(
                color: kRed,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    restaurantController.restaurant = controller.getRestaurantData(id);
    restaurantController.setStatus = status ?? false;

    return IgnorePointer(
      ignoring: id == null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        color: kOffWhite,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: id != null
                          ? () {
                        Get.to(() => const ProfilePage());
                      }
                          : null,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: kTertiary,
                        backgroundImage: NetworkImage(
                          restaurantController.restaurant?.logoUrl ?? profile,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: heading ??
                                restaurantController.restaurant?.title ??
                                '',
                            style: appStyle(13, kSecondary, FontWeight.w600),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: ReusableText(
                              text: title ??
                                  restaurantController.restaurant?.coords
                                      .address ??
                                  '',
                              style: appStyle(11, kGray, FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: id != null ? onTap : null,
                  child: Obx(
                        () => SvgPicture.asset(
                      restaurantController.status
                          ? 'assets/icons/open_sign.svg'
                          : 'assets/icons/closed_sign.svg',
                      height: 35.h,
                      width: 35.w,
                    ),
                  ),
                ),
              ],
            ),
            type != true
                ? Positioned(
              top: 45.h,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  AntDesign.closecircle,
                  color: kRed,
                  size: 18,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  String profile =
      'https://d326fntlu7tb1e.cloudfront.net/uploads/51530ae8-32b8-4a04-89b3-17f40a2f4cc1-avatar.png';
}
