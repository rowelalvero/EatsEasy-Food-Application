import 'dart:convert';

import 'package:eatseasy/views/profile/widgets/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/back_ground_container.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/address_controller.dart';
import 'package:eatseasy/models/all_addresses.dart';
import 'package:eatseasy/views/home/widgets/custom_btn.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'add_new_place.dart';

class UpdateAddressPage extends StatefulWidget {
  const UpdateAddressPage({super.key, required this.address});

  final AddressesList address;

  @override
  _UpdateAddressPageState createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  final controller = Get.put(AddressController());
  LatLng? _selectedLocation;

  // Text Editing Controllers for form fields
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _deliveryInstructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Prepopulate fields with existing address data
    _addressNameController.text = widget.address.addressName;
    _addressLine1Controller.text = widget.address.addressLine1;
    _postalCodeController.text = widget.address.postalCode;
    _deliveryInstructionsController.text = widget.address.deliveryInstructions ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        centerTitle: true,
        title: ReusableText(
          text: "Update Address",
          style: appStyle(20, Colors.black, FontWeight.w400),
        ),
      ),
      body: Center(
        child: BackGroundContainer(
          color: kLightWhite,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            children: [
              SizedBox(height: 35.h),

              //Address name
              TextField(
                controller: _addressNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.h),

              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewPlace(update: true),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      _addressLine1Controller.text = result["address"];
                      _selectedLocation = LatLng(result["latitude"], result["longitude"]);
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: height * .08,
                  width: width,
                  decoration: const BoxDecoration(
                    color: kOffWhite,
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                text: "Address:",
                                style: appStyle(11, kDark, FontWeight.w400),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Flexible(
                                child: Text(
                                  _addressLine1Controller.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: appStyle(13, kDark, FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddNewPlace(update: true),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                _addressLine1Controller.text = result["address"];
                                _selectedLocation = LatLng(result["latitude"], result["longitude"]);
                              });
                            }
                          },
                          icon: const Icon(Icons.keyboard_arrow_right_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),
              // Postal Code
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15.h),

              // Delivery Instructions
              TextField(
                controller: _deliveryInstructionsController,
                minLines: 1, // Minimum number of lines
                maxLines: null,
                decoration: const InputDecoration(
                  hintMaxLines:3,
                  labelText: 'Delivery Instructions',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15.h),

              // Update Address Button
              controller.isLoading ?
              Center(
                child: LoadingAnimationWidget.waveDots(
                  color: kPrimary,
                  size: 35
                ),
              )
                  :
              CustomButton(
                onTap: () {
                  final updatedAddress = {
                    "addressName": _addressNameController.text,
                    "addressLine1": _addressLine1Controller.text,
                    "postalCode": _postalCodeController.text,
                    "latitude": _selectedLocation?.latitude ?? widget.address.latitude,
                    "longitude": _selectedLocation?.longitude ?? widget.address.longitude,
                    "deliveryInstructions": _deliveryInstructionsController.text,
                  };

                  // Call update address function
                  controller.updateAddress(widget.address.id, jsonEncode(updatedAddress));
                  final result = true;
                  Navigator.pop(context, result);
                },
                radius: 9,
                color: kPrimary,
                btnWidth: width * 0.95,
                btnHieght: 34.h,
                text: "U P D A T E  A D D R E S S",
              ),
              SizedBox(height: 15.h),

              controller.isLoading
                  ? Center(
                child: LoadingAnimationWidget.waveDots(
                  color: kPrimary,
                  size: 35
                ),
              )

                  : CustomButton(
                onTap: () {
                  controller.deleteAddress(widget.address.id);
                  final result = true;
                  Navigator.pop(context, result);
                },
                radius: 9,
                color: kRed,
                btnWidth: width * 0.95,
                btnHieght: 34.h,
                text: "D E L E T E  A D D R E S S",
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    _addressNameController.dispose();
    _addressLine1Controller.dispose();
    _postalCodeController.dispose();
    _deliveryInstructionsController.dispose();
    super.dispose();
  }
}
