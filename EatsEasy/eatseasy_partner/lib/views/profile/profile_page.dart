import 'dart:convert';

import 'package:eatseasy_partner/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/login_controller.dart';
import 'package:eatseasy_partner/views/auth/widgets/login_redirect.dart';
import 'package:eatseasy_partner/views/home/wallet_page.dart';
import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:eatseasy_partner/views/profile/widgets/tile_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/customer_service.dart';
import '../../controllers/feedback_controller.dart';
import '../../controllers/restaurant_controller.dart';
import '../../hooks/fetchServiceNumber.dart';
import '../../models/login_response.dart';
import '../../models/restaurant_response.dart';
import 'about_us.dart';
import 'customer_feedback.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginResponse? user;
    RestaurantResponse? restaurant;
    final upload = Get.put(UserFeedBackController());
    final restaurantController = Get.put(RestaurantController());
    final box = GetStorage();
    String? token = box.read('token');
    String? id = box.read('restaurantId');
    String accessToken = jsonDecode(token!);
    final controller = Get.put(LoginController());
    final serviceNumber = useFetchCustomerService();

    if (token != null) {
      restaurantController.getRestaurant(accessToken);
      user = controller.getUserData();
      restaurant = controller.getRestaurantData(id!);
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return token == null
        ? const LoginRedirection()
        : Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
        leading:InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: kDark,
            )),
        elevation: 0,
        toolbarHeight: screenHeight * 0.1, // Dynamic toolbar height
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: NetworkImage(restaurant!.logoUrl),
                  radius: 20, // Dynamic radius based on screen width
                ),
                SizedBox(width: screenWidth * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      restaurant.title,
                      style: appStyle(16, kGray, FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user!.email,
                      style: appStyle(16, kGray, FontWeight.normal),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileScreen(user: user, restaurant: restaurant));
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: const Icon(
                  Feather.settings,
                  size: 20, // Dynamic icon size
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
          child: BackGroundContainer(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(
                              () => const WalletPage());
                    },
                    child: const TilesWidget(
                      title: "Wallet",
                      leading: MaterialCommunityIcons.pin_outline,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(
                              () => CustomerFeedback(restaurant: restaurant));
                    },
                    child: const TilesWidget(
                      title: "Ratings",
                      leading: MaterialCommunityIcons.star,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      BetterFeedback.of(context).show((UserFeedback feedback) async {
                        var url = feedback.screenshot;
                        upload.feedbackFile.value = await upload.writeBytesToFile(url, "feedback");

                        String message = feedback.text;
                        upload.uploadImageToFirebase(message);
                      });
                    },
                    child: const TilesWidget(
                      title: "App Feedback",
                      leading: Feather.map_pin,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      customerService(context, serviceNumber);
                    },
                    child: const TilesWidget(
                      title: "Service Center",
                      leading: AntDesign.customerservice,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(() => AboutUsScreen());
                    },
                    child: const TilesWidget(
                      title: "About us",
                      leading: Feather.message_square,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kRed, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      controller.logout();
                    },
                    child: const TilesWidget(
                      title: "Log out",
                      leading: Feather.log_out,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ))
    );
  }
}
