import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileAppBar extends StatelessWidget {
  ProfileAppBar({super.key});


  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    String? defaultAddress = box.read('defaultAddress');

    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {},
        child: GestureDetector(
          onTap: () {
            controller.logout();
          },
          child: const Icon(
            AntDesign.logout,
            size: 18,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {

          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 15,
                  width: 1,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(defaultAddress??"Unknown", style: appStyle(16, kDark, FontWeight.normal)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
