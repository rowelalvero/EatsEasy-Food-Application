import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/common/app_style.dart';
import 'package:eatseasy_admin/common/back_ground_container.dart';
import 'package:eatseasy_admin/common/divida.dart';
import 'package:eatseasy_admin/common/reusable_text.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/driver_model.dart';
import 'package:eatseasy_admin/views/home/screens/drivers/widgets/driver_status_button.dart';

import '../../cashout/widgets/cashout_update_page.dart';

class DriverDetails extends StatefulWidget {
  const DriverDetails({super.key, required this.id, required this.driver, this.refetch});

  final String id;
  final DriverElement driver;
  final Function? refetch;

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOffWhite,
        title: ReusableText(
          text: "Driver Details",
          style: appStyle(20, kGray, FontWeight.w600),
        ),
      ),
      body: Center(child: BackGroundContainer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DriverStatusButtons(
                driver: widget.driver,
                refetch: () {
                  widget.refetch!();
                },
              ),
              const Divida(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: "${widget.driver.driver.username} details",
                        style: appStyle(16, kDark, FontWeight.w600)),
                    const SizedBox(height: 10,),
                    //RowText(first: "Driver name: ", second: widget.driver.driver.username),
                    RowText(first: "Driver Id ", second: widget.driver.id),
                    RowText(first: "Vehicle type ", second: widget.driver.vehicleType),
                    RowText(first: "Vehicle name: ", second: widget.driver.vehicleName),
                    RowText(first: "Plate number: ", second: widget.driver.vehicleNumber),
                    RowText(first: "Phone number: ", second: widget.driver.phone),
                    const SizedBox(height: 10,),
                    ReusableText(
                        text: "Uploaded credentials",
                        style: appStyle(16, kDark, FontWeight.w600)),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.network(
                                        widget.driver.driverLicenseUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 120,
                              width: width / 2.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: kGrayLight),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  widget.driver.driverLicenseUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Add spacing between the containers
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.network(
                                        widget.driver.nbiClearanceUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 120,
                              width: width / 2.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: kGrayLight),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  widget.driver.nbiClearanceUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            AntDesign.bells,
                            color: kGrayLight,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(AntDesign.mail, color: kGrayLight)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(AntDesign.phone, color: kGrayLight)),
                    ],
                  ),*/
                  ],
                ),
              ),


              /*Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                    text: "Send Notifications",
                    style: appStyle(12, kGray, FontWeight.w600)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          AntDesign.bells,
                          color: kGrayLight,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(AntDesign.mail, color: kGrayLight)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(AntDesign.phone, color: kGrayLight)),
                  ],
                ),
              ],
            ),
          ),

          const Divida(),*/
            ],
          )),),
    );
  }
}
