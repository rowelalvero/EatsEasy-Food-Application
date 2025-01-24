import 'package:flutter/material.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/restaurant_controller.dart';
import 'package:get/get.dart';

class AvailableSwitch extends StatelessWidget {
  const AvailableSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = Get.put(RestaurantController());
    return SizedBox(
        height: 30,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             ReusableText(
              text: 'Food Availability',
              style: appStyle(14, kGray, FontWeight.w600,
              ),
            ),
            Obx(
              () => Switch(

                value: restaurantController.isAvailable,
                onChanged: (value) {
                  restaurantController.setAvailability =
                      !restaurantController.isAvailable;
                },
                activeColor: kSecondary,
              ),
            )
          ],
        ));
  }
}
