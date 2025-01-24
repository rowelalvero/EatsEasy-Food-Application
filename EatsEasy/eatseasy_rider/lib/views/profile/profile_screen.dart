import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:eatseasy_rider/models/driver_response.dart';
import 'package:eatseasy_rider/models/login_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/custom_btn.dart';
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
import '../../controllers/login_controller.dart';
import '../../controllers/update_driver_controller.dart';
import '../../controllers/update_phone_controller.dart';
import '../../models/update_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user, required this.driverController});

  final LoginResponse? user;
  final Driver? driverController;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = GetStorage();
  final controller = Get.put(UserLocationController());
  final loginController = Get.put(LoginController());
  final driverController = Get.put(DriverController());
  final imageUploader = Get.put(ImageUploadController());
  final updateDriver = Get.put(DriverEditController());
  final updatePhoneController = Get.put(UpdatePhoneController());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _plateNumber = TextEditingController();
  final TextEditingController _vehicleName = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  DateTime? expireDate;
  String? expiryDate;
  String? selectedVehicleType;
  final List<String> items = ['Bike', 'Car', 'Scooter'];

  bool isVerifying = false;
  bool isOtpVerified = false;
  String? verificationId;
/*
  @override
  void initState() {
    super.initState();

    if (widget.driverController != null) {
      _phoneController.text = widget.driverController!.phone;
      _plateNumber.text = widget.driverController!.vehicleNumber;
      _vehicleName.text = widget.driverController!.vehicleName;
      _licenseNumber.text = widget.driverController!.licenseNumber;
      imageUploader.logoUrl = widget.driverController!.profileImage;
      imageUploader.nbiClearanceUrl = widget.driverController!.nbiClearanceUrl;
      imageUploader.driverLicenseUrl = widget.driverController!.driverLicenseUrl;
      selectedVehicleType = widget.driverController!.vehicleType;

      // Check if the expireDate is valid, otherwise set to null.
      if (widget.driverController!.licenseExpireDate.isNotEmpty) {
        try {
          setState(() {
            expireDate = DateTime.parse(widget.driverController!.licenseExpireDate);
          });

        } catch (e) {
          print("Error parsing license expire date: $e");
          expireDate = null;  // Set to null if parsing fails
        }
      }
    }
  }*/

  Future<void> _verifyPhone() async {
    setState(() {
      isVerifying = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Get.snackbar('Success', 'Phone number verified');
        setState(() {
          verificationId = '';
          isVerifying = false;
          isOtpVerified = true;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', e.message ?? 'Phone number verification failed');
        setState(() {
          isVerifying = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          isVerifying = false;
        });
        Get.snackbar('OTP Sent', 'Please check your phone for the OTP');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
          isVerifying = false;
        });
      },
    );
  }

  Future<void> _verifyOtp() async {
    if (verificationId == null || _otpController.text.isEmpty) return;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      UpdateProfile model = UpdateProfile(
        phone: _phoneController.text,
        phoneVerification: isOtpVerified,
      );
      print(model);
      String userdata = updateProfileToJson(model);
      print(userdata);
      await updatePhoneController.updateUser(userdata);
      Get.snackbar('Success', 'Phone number verified');
      setState(() {
        isOtpVerified = true;
      });
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }


  @override
  Widget build(BuildContext context) {
    String? token = box.read('token');

    if (token != null) {
      updateDriver.fetchDriverDetails();
    }

    if (widget.driverController != null) {
      _phoneController.text = widget.driverController!.phone;
      _plateNumber.text = widget.driverController!.vehicleNumber;
      _vehicleName.text = widget.driverController!.vehicleName;
      _licenseNumber.text = widget.driverController!.licenseNumber;
      imageUploader.logoUrl = widget.driverController!.profileImage;
      imageUploader.nbiClearanceUrl = widget.driverController!.nbiClearanceUrl;
      imageUploader.driverLicenseUrl = widget.driverController!.driverLicenseUrl;
      selectedVehicleType = widget.driverController!.vehicleType;

      // Check if the expireDate is valid, otherwise set to null.
      if (widget.driverController!.licenseExpireDate.isNotEmpty) {
        try {
          setState(() {
            expireDate = DateTime.parse(widget.driverController!.licenseExpireDate);
          });

        } catch (e) {
          print("Error parsing license expire date: $e");
          expireDate = null;  // Set to null if parsing fails
        }
      }
    }
    String username = box.read('username');
    return Obx(() => updateDriver.isLoading ? LoadingAnimationWidget.threeArchedCircle(
        color: kSecondary,
        size: 35
    ) : Scaffold(
      appBar: AppBar(
        title: ReusableText(
            text: "Driver Profile",
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
              text: "Vehicle Type",
              style: appStyle(16, kDark, FontWeight.bold)),
          const SizedBox(
            height: 10 ,
          ),
          DropdownButton<String>(
            value: selectedVehicleType, // Current selected vehicle type
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  selectedVehicleType = newValue; // Update selected vehicle type
                });
              }
            },
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item)
              );
            }).toList(),
            // Optional: Customize the dropdown button appearance if needed
            icon: const Icon(Icons.arrow_drop_down),
            underline: Container(), // Optional: To remove the underline
          ),

          const SizedBox(
            height: 20 ,
          ),
          ReusableText(
              text: "Vehicle details",
              style: appStyle(16, kDark, FontWeight.bold)),
          /*ReusableText(
            text:
            "You are required fill all the details fully with the correct information",
            style: appStyle(11, kGray, FontWeight.normal),
          ),*/
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
          /*const SizedBox(
            height: 10 ,
          ),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: expireDate ?? DateTime.now(), // Use current date if null
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != expireDate) {
                setState(() {
                  expireDate = pickedDate;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: kSecondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Text(
              "License expire date: ${expireDate != null ? "${expireDate!.day}/${expireDate!.month}/${expireDate!.year}" : "Select Date"}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),*/



          const SizedBox(
            height: 10 ,
          ),
          ReusableText(
              text: "Documents",
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
            children: [
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  onChanged: (String value) {
                    isOtpVerified = false;
                  },
                  keyboardType: TextInputType.phone,
                  style: appStyle(12, kDark, FontWeight.normal),
                  decoration: InputDecoration(
                    labelText: "Phone",
                    labelStyle: appStyle(16, kGray, FontWeight.normal),
                    prefixIcon: Icon(CupertinoIcons.phone, color: Theme.of(context).dividerColor, size: 20),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kGray, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimary, width: 0.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              isOtpVerified
                  ? const Row(
                children: [
                  Text("Verified", style: TextStyle(color: Colors.lightGreen)),
                  Icon(Icons.check_circle, color: Colors.lightGreen),
                ],
              ): ElevatedButton(
                onPressed: isVerifying ? null : _verifyPhone,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1.0,
                ),
                child: isVerifying
                    ? LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.white,
                  size: 24,
                )
                    : const Text('Verify'),
              )
            ],
          ),
          if (verificationId != null && !isOtpVerified) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                prefixIcon: Icon(CupertinoIcons.lock, color: Theme.of(context).dividerColor, size: 20),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text('Verify OTP'),
              ),
            ),
          ],
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
                  selectedVehicleType == null) {
                Get.snackbar("Error", "Please fill all fields");

                print(_plateNumber.text);
                print(_vehicleName.text);
                print(_licenseNumber.text);
                print(imageUploader.driverLicenseUrl);
                print(imageUploader.nbiClearanceUrl);
                print(selectedVehicleType);

                return;
              } else {
                DriverRegistrationRequest data =
                DriverRegistrationRequest(
                    username: username,
                    vehicleType: selectedVehicleType!,
                    phone: _phoneController.text,
                    phoneVerification: isOtpVerified,
                    vehicleNumber: _plateNumber.text,
                    vehicleName: _vehicleName.text,
                    licenseNumber: _licenseNumber.text,
                    licenseExpireDate: widget.driverController!.licenseExpireDate /*"${expireDate!.day}/${expireDate!.month}/${expireDate!.year}"*/,
                    driverLicenseUrl: imageUploader.driverLicenseUrl,
                    nbiClearanceUrl: imageUploader.nbiClearanceUrl,
                    latitude: controller.currentLocation.latitude,
                    longitude: controller.currentLocation.longitude,
                    profileImage: imageUploader.logoUrl
                );

                String driver = driverRegistrationRequestToJson(data);

                updateDriver.updateDriverDetails(widget.driverController!.id, driver);
                //loginController.logout();
              }
            },
            text: "S U B M I T",
          )
        ],
      )),),)
    );
  }
}
