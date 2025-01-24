  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:eatseasy/views/profile/add_new_place.dart';
import 'package:get/get.dart';

import '../controllers/address_controller.dart';

Future<dynamic> showAddressSheet(BuildContext context) {
  final controller = Get.put(AddressController());
    return showModalBottomSheet(
      enableDrag: controller.defaultAddress != null ? true : false,
        backgroundColor: Colors.transparent,
        showDragHandle: true,
        barrierColor: kGrayLight.withOpacity(0.2),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 700.h,
            width: width,
            decoration: const BoxDecoration(
                /*image: DecorationImage(
                    image: AssetImage(
                      "assets/images/restaurant_bk.png",
                    ),
                    fit: BoxFit.fill),*/
                color: kOffWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: Padding(
              padding: EdgeInsets.all(8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  ReusableText(
                      text: "Add Default Address",
                      style: appStyle(20, kPrimary, FontWeight.bold)),
                  SizedBox(
                      height: 300.h,
                      child: ListView.builder(
                          itemCount: reasonsToAddAddress.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              visualDensity: VisualDensity.compact,
                              minVerticalPadding: 0,
                              title: Text(
                                reasonsToAddAddress[index],
                                textAlign: TextAlign.justify,
                                style:
                                    appStyle(12, kGray, FontWeight.normal),
                              ),
                              leading: const Icon(
                                Icons.check_circle_outline,
                                color: kPrimary,
                              ),
                            );
                          })),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomButton(
                      onTap: () {
                        Get.to(() => const AddNewPlace());
                      },
                      btnHieght: 40.h,
                      text: "Proceed To Address Page"),
                ],
              ),
            ),
          );
        });
  }