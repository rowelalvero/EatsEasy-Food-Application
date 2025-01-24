
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/models/driver_address_model.dart';
import 'package:get/get.dart';

import 'default_address_page.dart';
class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.address,
  });

  final AddressesList address;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() =>   SetDefaultAddressPage(address: address,));
      },
      visualDensity: VisualDensity.compact,
      leading: Padding(
        padding: EdgeInsets.only(top: 0.0.r),
        child: Icon(
          SimpleLineIcons.location_pin,
          color: kPrimary,
          size: 28 ,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: ReusableText(
        text: address.addressLine1,
        style: appStyle(kFontSizeBodyRegular, kGray, FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ReusableText(
            text: address.postalCode,
            style: appStyle(kFontSizeBodySmall, kGray, FontWeight.normal),
          ),

          ReusableText(
            text: "Tap on the tile to open address settings",
            style: appStyle(kFontSizeSubtext, kGrayLight, FontWeight.normal),
          ),
        ],
      ),
      trailing: Switch.adaptive(
          value: address.addressesListDefault,
          onChanged: (bool value) {
            // controller.setDfSwitch = value;
          }),
    );
  }
}
