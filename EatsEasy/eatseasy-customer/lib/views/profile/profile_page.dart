import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/views/profile/profile_screen.dart';
import 'package:eatseasy/views/profile/wallet.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/custom_container.dart';
import 'package:eatseasy/common/customer_service.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/feedback_controller.dart';
import 'package:eatseasy/controllers/login_controller.dart';
import 'package:eatseasy/hooks/fetchServiceNumber.dart';
import 'package:eatseasy/models/login_response.dart';
import 'package:eatseasy/views/auth/widgets/login_redirect.dart';
import 'package:eatseasy/views/message/index.dart';
import 'package:eatseasy/views/orders/client_orders.dart';
import 'package:eatseasy/views/profile/saved_places.dart';
import 'package:eatseasy/views/profile/widgets/profile_appbar.dart';
import 'package:eatseasy/views/profile/widgets/tile_widget.dart';
import 'package:eatseasy/views/reviews/rating_review_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/wallet_controller.dart';
import 'about_us.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final upload = Get.put(UserFeedBackController());
    final controller = Get.put(LoginController());
    final serviceNumber = useFetchCustomerService();
    final location = Get.put(UserLocationController());
    final WalletController _walletController = Get.put(WalletController());
    LoginResponse? user;
    final box = GetStorage();
    String? token = box.read('token');

    if (token != null) {
      user = controller.getUserData();
      _walletController.fetchUserDetails();
      user = controller.getUserData();
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return token == null
        ? const LoginRedirection()
        : Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
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
                  backgroundImage: NetworkImage(user!.profile),
                  radius: 20, // Dynamic radius based on screen width
                ),
                SizedBox(width: screenWidth * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.username,
                      style: appStyle(16, kGray, FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.email,
                      style: appStyle(16, kGray, FontWeight.normal),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileScreen(user: user));
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
              Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(() => const ClientOrderPage());
                    },
                    child: const TilesWidget(
                      title: "My orders",
                      leading: MaterialCommunityIcons.pin_outline,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(() => const RatingReview());
                    },
                    child: const TilesWidget(
                      title: "Ratings",
                      leading: Feather.message_circle,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(() => DashboardScreen());
                    },
                    child: const TilesWidget(
                      title: "Wallet",
                      leading: MaterialCommunityIcons.wallet_outline,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(() => const SavedPlaces());
                    },
                    child: const TilesWidget(
                      title: "Saved places",
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
                      BetterFeedback.of(context)
                          .show((UserFeedback feedback) async {
                        var url = feedback.screenshot;
                        upload.feedbackFile.value =
                        await upload.writeBytesToFile(url, "feedback");

                        String message = feedback.text;
                        upload.uploadImageToFirebase(message);
                      });
                    },
                    child: const TilesWidget(
                      title: "App Feedback",
                      leading: Feather.pen_tool,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimary, textStyle: TextStyle(fontSize: 16.sp),
                    ),
                    onPressed: () {
                      Get.to(() => const MessagePage());
                    },
                    child: const TilesWidget(
                      title: "Chats",
                      leading: Feather.message_circle,
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
            ],
          ),
        ),
      ),
    );
  }
}
