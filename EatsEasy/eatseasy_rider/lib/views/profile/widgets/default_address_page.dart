
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:eatseasy_rider/common/custom_app_bar.dart';
import 'package:eatseasy_rider/common/custom_btn.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/address_controller.dart';
import 'package:eatseasy_rider/models/driver_address_model.dart';
import 'package:get/get.dart';
class SetDefaultAddressPage extends StatelessWidget {
  const SetDefaultAddressPage({super.key, required this.address});

  final AddressesList address;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: CommonAppBar(
        titleText:  "Change Default Address"
      ) ,
      body: BackGroundContainer(
        color: kLightWhite,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: [
            SizedBox(
              height: 35 ,
            ),

            ReusableText(
                text: address.addressLine1,
                style: appStyle(kFontSizeBodyRegular, kGray, FontWeight.normal)),


            SizedBox(
              height: 15 ,
            ),
            CustomButton(
              onTap: () {
                controller.setDefaultAddress(address.id);
              },
              radius: 9,
              color: kPrimary,
              btnWidth: width * 0.95,
              btnHieght: 34 ,
              text: "CLICK TO SET AS DEFAULT",
            ),


          ],
        ),
      ),
    );
  }
}
