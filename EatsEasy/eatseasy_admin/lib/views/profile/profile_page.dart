import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/custom_container.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/login_controller.dart';
import 'package:eatseasy_admin/models/login_response.dart';
import 'package:eatseasy_admin/views/auth/widgets/login_redirect.dart';
import 'package:eatseasy_admin/views/profile/widgets/profile_appbar.dart';
import 'package:eatseasy_admin/views/profile/widgets/tile_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginResponse? user;
    final box = GetStorage();
    String? token = box.read('token');

    final controller = Get.put(LoginController());

    if (token != null) {
      user = controller.getUserData();
    }

    return token == null
        ? const LoginRedirection()
        : Scaffold(
            backgroundColor: kPrimary,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.h),
                child: const ProfileAppBar()),
            body: SafeArea(
              child: CustomContainer(
                  containerContent: Column(
                children: [
                  Container(
                    height: hieght * 0.06,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade100,
                                      backgroundImage:
                                          NetworkImage(user!.profile),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username,
                                          style: appStyle(
                                              12, kGray, FontWeight.w600),
                                        ),
                                        Text(
                                          user.email,
                                          style: appStyle(
                                              11, kGray, FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 12.0.h),
                                    child: const Icon(Feather.edit, size: 18),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 210.h,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TilesWidget(
                          onTap: () {
                           
                          },
                          title: "My Orders",
                          leading: Ionicons.cart_outline,
                        ),
                        TilesWidget(
                          onTap: () {
                          
                          },
                          title: "My Favorites Places",
                          leading: MaterialCommunityIcons.heart_outline,
                        ),
                        TilesWidget(
                          onTap: () {
                            
                          },
                          title: "My Reviews",
                          leading: MaterialCommunityIcons.star_outline,
                        ),
                        TilesWidget(
                          onTap: () {
                         
                          },
                          title: "Coupons",
                          leading: MaterialCommunityIcons.tag_outline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 210.h,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TilesWidget(
                          onTap: () {
                            
                          },
                          title: "Shipping addresses",
                          leading: SimpleLineIcons.location_pin,
                        ),
                        TilesWidget(
                          onTap: () {},
                          title: "Service Center",
                          leading: AntDesign.customerservice,
                        ),
                        const TilesWidget(
                          title: "App Feedback",
                          leading: MaterialIcons.rss_feed,
                        ),
                        TilesWidget(
                          onTap: () {},
                          title: "Settings",
                          leading: AntDesign.setting,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          );
  }
}
