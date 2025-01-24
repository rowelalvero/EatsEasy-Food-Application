import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:eatseasy_rider/views/profile/earnings_data.dart';
import 'package:eatseasy_rider/views/profile/profile_screen.dart';
import 'package:eatseasy_rider/views/profile/wallet.dart';
import 'package:eatseasy_rider/views/profile/widgets/profile_appbar.dart';
import 'package:eatseasy_rider/views/profile/widgets/tile_widget.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/constants.dart';
import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../common/customer_service.dart';
import '../../controllers/feedback_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/update_driver_controller.dart';
import '../../hooks/fetchServiceNumber.dart';
import '../../models/driver_response.dart';
import '../../models/login_response.dart';
import '../auth/widgets/login_redirect.dart';
import 'customer_feedback.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final upload = Get.put(UserFeedBackController());
    final driverController = Get.put(DriverEditController());
    LoginResponse? user;
    Driver? driverData;
    final box = GetStorage();
    String? token = box.read('token');

    final controller = Get.put(LoginController());
    final serviceNumber = useFetchCustomerService();

    if (token != null) {
      driverController.fetchDriverDetails();
      user = controller.getUserData();
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return token == null
        ? const LoginRedirection()
        : Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
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
                  backgroundImage: NetworkImage(driverController.driver?.profileImage != null  ? driverController.driver!.profileImage : user!.profile),
                  radius: screenWidth * 0.05, // Dynamic radius based on screen width
                ),
                SizedBox(width: screenWidth * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user!.username,
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
                Get.to(() => ProfileScreen(
                    user: user, driverController: driverController.driver));
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 8 ),
                child: Icon(
                  Feather.settings,
                  size: 20, // Dynamic icon size
                ),
              ),
            ),
          ],
        ),
      ),

      body: Center(child: BackGroundContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                     Get.to(() => CustomerFeedback(driverController: driverController.driver));
                  },
                  child: TilesWidget(
                    title: "Rating",
                    leading: Feather.star,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => DashboardScreen());
                  },
                  child: TilesWidget(
                    title: "Wallet",
                    leading: MaterialCommunityIcons.wallet_outline,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => EarningData());
                  },
                  child: TilesWidget(
                    title: "Earnings",
                    leading: Feather.bar_chart_2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    customerService(context, serviceNumber);
                  },
                  child: TilesWidget(
                    title: "Service Center",
                    leading: AntDesign.customerservice,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    BetterFeedback.of(context)
                        .show((UserFeedback feedback) async {
                      var url = feedback.screenshot;
                      upload.feedbackFile.value = await upload.writeBytesToFile(url, "feedback");

                      String message = feedback.text;
                      upload.uploadImageToFirebase(message);
                    });
                  },
                  child: TilesWidget(
                    title: "App Feedback",
                    leading: Feather.pen_tool,
                  ),
                ),
                /*SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    // Get.to(() => const MessagePage());
                  },
                  child: TilesWidget(
                    title: "Chats",
                    leading: Feather.message_square,
                  ),
                ),*/
                TextButton(
                  onPressed: () {
                    controller.logout();
                  },
                  child: TilesWidget(
                    title: "Log out",
                    leading: Feather.log_out,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),),
    );
  }
}
