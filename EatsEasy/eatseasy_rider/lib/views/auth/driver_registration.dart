import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/custom_btn.dart';
import 'package:eatseasy_rider/common/custom_container.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/driver_controller.dart';
import 'package:eatseasy_rider/controllers/location_controller.dart';
import 'package:eatseasy_rider/models/driver_reg_request.dart';
import 'package:eatseasy_rider/views/auth/widgets/email_textfield.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/Image_upload_controller.dart';

class DriverRegistration extends StatefulWidget {
  const DriverRegistration({super.key});

  @override
  State<DriverRegistration> createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {
  final TextEditingController _plateNumber = TextEditingController();
  final TextEditingController _vehicleName = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  DateTime? expireDate;
  String? expiryDate;
  final List<String> items = ['Bike', 'Car', 'Scooter'];

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final controller = Get.put(UserLocationController());
    final driverController = Get.put(DriverController());
    final imageUploader = Get.put(ImageUploadController());
    String username = box.read('username');
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
            text: "Driver Registration",
            style: appStyle(16, kDark, FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0.4,
      ),
      body: Center(child: BackGroundContainer(child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          /*Image.asset(
              'assets/images/delivery.png',
              height: height / 3,
              width: width,
            ),*/

          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    imageUploader.pickImage("logo");
                  },
                  child: Badge(
                    backgroundColor: Colors.transparent,
                    label: Obx(
                          () => imageUploader.logoUrl.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          imageUploader.logoUrl = '';
                        },
                        child: const Icon(Icons.remove_circle, color: kRed),
                      )
                          : Container(),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: Obx(
                            () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "logo"
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.threeArchedCircle(
                                color: kSecondary,
                                size: 35,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                style: appStyle(16, kDark, FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                            : ClipOval(
                          child: imageUploader.logoUrl.isNotEmpty
                              ? Image.network(
                            imageUploader.logoUrl,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          )
                              : const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey, // Placeholder if no image URL
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 20 ,
          ),
          ReusableText(
              text: "Pick Vehicle Type",
              style: appStyle(16, kDark, FontWeight.bold)),
          const SizedBox(
            height: 10 ,
          ),
          Row(
            children: List.generate(items.length, (i) {
              return Obx(() => GestureDetector(
                onTap: () {
                  driverController.setVehicleType = items[i];
                },
                child: SizedBox(
                  width: 80 ,
                  height: 30 ,
                  child: Card(
                    elevation: 0.3,
                    color: driverController.vehicleType == items[i]
                        ? kSecondary
                        : kLightWhite,
                    child: Center(
                      child: Text(items[i]),
                    ),
                  ),
                ),
              ));
            }),
          ),
          const SizedBox(
            height: 20 ,
          ),
          ReusableText(
              text: "Vehicle details",
              style: appStyle(16, kDark, FontWeight.bold)),
          ReusableText(
            text:
            "You are required fill all the details fully with the correct information",
            style: appStyle(11, kGray, FontWeight.normal),
          ),
          const SizedBox(
            height: 10 ,
          ),
          EmailTextField(
              hintText: "Vehicle Name",
              controller: _vehicleName,
              prefixIcon: Icon(
                CupertinoIcons.car_detailed,
                color: Theme.of(context).dividerColor,
                size: 20 ,
              ),
              keyboardType: TextInputType.text,
              onEditingComplete: () {}
          ),
          ReusableText(
            text:
            "e.g., Kawasaki Ninja ZX-10R",
            style: appStyle(11, kGray, FontWeight.normal),
          ),
          const SizedBox(
            height: 10 ,
          ),
          EmailTextField(
              hintText: "Plate Number",
              controller: _plateNumber,
              prefixIcon: Icon(
                CupertinoIcons.car_detailed,
                color: Theme.of(context).dividerColor,
                size: 20 ,
              ),
              keyboardType: TextInputType.text,
              onEditingComplete: () {}),
          ReusableText(
            text:
            "e.g., ABC-123",
            style: appStyle(11, kGray, FontWeight.normal),
          ),
          const SizedBox(
            height: 10 ,
          ),
          EmailTextField(
              hintText: "License Number",
              controller: _licenseNumber,
              prefixIcon: Icon(
                CupertinoIcons.car_detailed,
                color: Theme.of(context).dividerColor,
                size: 20 ,
              ),
              keyboardType: TextInputType.text,
              onEditingComplete: () {}
          ),
          ReusableText(
            text:
            "e.g., N01-23-456789",
            style: appStyle(11, kGray, FontWeight.normal),
          ),
          const SizedBox(
            height: 10 ,
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: expireDate ?? DateTime.now(),
                firstDate: DateTime(2000),  // Earliest selectable date
                lastDate: DateTime(2101),   // Latest selectable date
              );
              if (pickedDate != null) {
                setState(() {
                  expireDate = pickedDate;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: kSecondary, // Background color
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              elevation: 2, // Shadow elevation
            ),
            child: Text(
              "License expire date: ${expireDate != null ? "${expireDate!.day}/${expireDate!.month}/${expireDate!.year}" : "Select Date"}",
              style: const TextStyle(
                fontSize: 16, // Text size
                fontWeight: FontWeight.bold, // Text weight
              ),
            ),
          ),
          const SizedBox(
            height: 10 ,
          ),
          ReusableText(
              text: "Upload documents",
              style: appStyle(16, kDark, FontWeight.bold)),
          ReusableText(
            text:
            "You are required fill all the details fully with the correct information",
            style: appStyle(11, kGray, FontWeight.normal),
          ),
          const SizedBox(
            height: 10 ,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  imageUploader.pickImage("driverLicense");
                },
                child: Badge(
                  backgroundColor: Colors.transparent,

                  label: Obx(
                        () => imageUploader.driverLicenseUrl.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        imageUploader.driverLicenseUrl = '';

                      },
                      child: const Icon(Icons.remove_circle, color: kRed),
                    ) : Container(),
                  ),

                  child: Container(
                      height: 120 ,
                      width: width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: kGrayLight),
                      ),
                      child: Obx(
                            () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "driverLicense"
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.threeArchedCircle(
                                  color: kSecondary,
                                  size: 35
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                style: appStyle(16, kDark, FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                            : imageUploader.driverLicenseUrl.isEmpty
                            ? Center(
                          child: Text(
                            "Driver's License",
                            style:
                            appStyle(16, kDark, FontWeight.w600),
                          ),

                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.network(
                            imageUploader.driverLicenseUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  imageUploader.pickImage("nbiClearance");
                },
                child: Badge(
                  backgroundColor: Colors.transparent,

                  label: Obx(
                        () => imageUploader.nbiClearanceUrl.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        imageUploader.nbiClearanceUrl = '';

                      },
                      child: const Icon(Icons.remove_circle, color: kRed),
                    ) : Container(),
                  ),

                  child: Container(
                      height: 120 ,
                      width: width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: kGrayLight),
                      ),
                      child: Obx(
                            () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "nbiClearance"
                            ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.threeArchedCircle(
                                  color: kSecondary,
                                  size: 35
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${(imageUploader.uploadProgress * 100).toStringAsFixed(0)}%",  // Display the percentage
                                style: appStyle(16, kDark, FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                            : imageUploader.nbiClearanceUrl.isEmpty
                            ? Center(
                          child: Text(
                            "NBI Clearance",
                            style:
                            appStyle(16, kDark, FontWeight.w600),
                          ),

                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.network(
                            imageUploader.nbiClearanceUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10 ,
          ),
          CustomButton(
            color: kPrimary,
            btnHieght: 45,
            onTap: () {
              String phone = box.read('phone');
              if (_plateNumber.text.isEmpty ||
                  _vehicleName.text.isEmpty ||
                  _licenseNumber.text.isEmpty ||
                  imageUploader.driverLicenseUrl.isEmpty ||
                  imageUploader.nbiClearanceUrl.isEmpty ||
                  driverController.vehicleType.isEmpty) {
                Get.snackbar("Error", "Please fill all fields");
                return;
              } else {
                DriverRegistrationRequest data =
                DriverRegistrationRequest(
                    username: username,
                    vehicleType: driverController.vehicleType,
                    phone: phone,
                    vehicleNumber: _plateNumber.text,
                    vehicleName: _vehicleName.text,
                    licenseNumber: _licenseNumber.text,
                    licenseExpireDate: "${expireDate!.day}/${expireDate!.month}/${expireDate!.year}",
                    driverLicenseUrl: imageUploader.driverLicenseUrl,
                    nbiClearanceUrl: imageUploader.nbiClearanceUrl,
                    latitude: controller.currentLocation.latitude,
                    longitude: controller.currentLocation.longitude,
                    profileImage: imageUploader.logoUrl
                );

                String driver = driverRegistrationRequestToJson(data);

                driverController.driverRegistration(driver);
              }
            },
            text: "S U B M I T",
          )
        ],
      )),),
    );
  }
}
