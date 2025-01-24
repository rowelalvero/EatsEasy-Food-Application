import 'dart:convert';

import 'package:eatseasy_partner/models/login_response.dart';
import 'package:eatseasy_partner/models/restaurant_response.dart' as resto;
import 'package:eatseasy_partner/views/auth/widgets/phone_verification.dart';
import 'package:eatseasy_partner/views/home/widgets/back_ground_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_partner/common/app_style.dart';
import 'package:eatseasy_partner/common/custom_btn.dart';
import 'package:eatseasy_partner/common/reusable_text.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/Image_upload_controller.dart';
import 'package:eatseasy_partner/controllers/location_controller.dart';
import 'package:eatseasy_partner/controllers/restaurant_controller.dart';
import 'package:eatseasy_partner/models/restaurant_request.dart';
import 'package:eatseasy_partner/views/auth/widgets/email_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/shimmers/foodlist_shimmer.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/update_phone_controller.dart';
import '../../models/environment.dart';
import '../../models/update_profile.dart';
import 'add_new_place.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user, required this.restaurant});

  final LoginResponse? user;
  final resto.RestaurantResponse? restaurant;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late final PageController _pageController = PageController(initialPage: 0);
  final controller = Get.put(UserLocationController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final loginController = Get.put(LoginController());
  final imageUploader = Get.put(ImageUploadController());
  final locationController = Get.put(UserLocationController());
  final restaurantController = Get.put(RestaurantController());
  final updatePhoneController = Get.put(UpdatePhoneController());
  final TextEditingController _otpController = TextEditingController();
  TimeOfDay timeFrom = const TimeOfDay(hour: 8, minute: 0); // 8:00 AM
  TimeOfDay timeTo = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM

  String? verificationId;

  String? businessTimeFrom;
  String? businessTimeTo;
  bool isVerifying = false;
  bool isOtpVerified = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      List<String> times = widget.restaurant!.time.split(" - ");

      // Split start time and end time
      String startTime = times[0]; // "8:00 AM"
      String endTime = times[1];   // "8:00 PM"

      // Function to parse time string with AM/PM
      TimeOfDay parseTime(String timeString) {
        // Remove extra spaces and split the time from AM/PM
        final timeParts = timeString.trim().split(' ');
        final timeWithoutAmPm = timeParts[0]; // e.g., "8:00"
        final amPm = timeParts[1];            // e.g., "AM" or "PM"

        // Further split to get hour and minute
        final hourMinute = timeWithoutAmPm.split(":");
        int hour = int.parse(hourMinute[0]);
        int minute = int.parse(hourMinute[1]);

        // Convert to 24-hour format if PM
        if (amPm == 'PM' && hour != 12) {
          hour += 12;
        } else if (amPm == 'AM' && hour == 12) {
          hour = 0; // Special case for 12 AM
        }
        return TimeOfDay(hour: hour, minute: minute);
      }

      timeFrom = parseTime(startTime);
      timeTo = parseTime(endTime);

      // Print the results (for debugging)
      print("Start Time: $timeFrom");
      print("End Time: $timeTo");
      _selectedLocation = LatLng(widget.restaurant!.coords.latitude, widget.restaurant!.coords.longitude);
      _phoneController.text = widget.restaurant!.phoneNumber;
      imageUploader.logoUrl = widget.restaurant!.logoUrl;
      imageUploader.coverUrl = widget.restaurant!.imageUrl;
      _title.text = widget.restaurant!.title;
      _postalCodeRes.text = widget.restaurant!.code;
      _address.text = widget.restaurant!.coords.address;
      if (widget.restaurant!.phoneVerification! != null) {
        isOtpVerified = widget.restaurant!.phoneVerification!;
      }

    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    _postalCodeRes.dispose();
    _title.dispose();
    _time.dispose();
    _address.dispose();
    _pageController.dispose();
    super.dispose();
  }

  LatLng? _selectedLocation;

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

      String userdata = updateProfileToJson(model);

      await updatePhoneController.updateUser(userdata);
      Get.snackbar('Success', 'Phone number verified');
      setState(() {
        isOtpVerified = true;
      });
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  String restaurantAddress = "";
  final TextEditingController _title = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _postalCodeRes = TextEditingController();

  @override
  Widget build(BuildContext context) {
    businessTimeFrom = MaterialLocalizations.of(context).formatTimeOfDay(timeFrom);
    businessTimeTo = MaterialLocalizations.of(context).formatTimeOfDay(timeTo);

    final box = GetStorage();
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    if (token != null) {
      restaurantController.getRestaurant(accessToken);
    }

    return Obx(() => restaurantController.isLoading ? LoadingAnimationWidget.threeArchedCircle(
        color: kSecondary,
        size: 35
    ) :
    Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
        title: ReusableText(
          text: "Business Details",
          style: appStyle(20, kDark, FontWeight.w400),
        ),
        elevation: 0,
      ),
      body: Center(child: SizedBox(width: 640, child:  BackGroundContainer(child: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        ) : Container(),
                      ),

                      child: Container(
                          height: 120.h,
                          width: 200.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: kGrayLight),
                          ),
                          child: Obx(
                                () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "logo"
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
                                : imageUploader.logoUrl.isEmpty
                                ? Center(
                              child: Text(
                                "Upload Logo",
                                style:
                                appStyle(16, kDark, FontWeight.w600),
                              ),

                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                imageUploader.logoUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      imageUploader.pickImage("cover");
                    },
                    child: Badge(
                      backgroundColor: Colors.transparent,

                      label: Obx(
                            () => imageUploader.coverUrl.isNotEmpty
                            ? GestureDetector(
                          onTap: () {
                            imageUploader.coverUrl = '';

                          },
                          child: const Icon(Icons.remove_circle, color: kRed),
                        ) : Container(),
                      ),

                      child: Container(
                          height: 120.h,
                          width: 200.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: kGrayLight),
                          ),
                          child: Obx(
                                () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "cover"
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
                                : imageUploader.coverUrl.isEmpty
                                ? Center(
                              child: Text(
                                "Upload Cover",
                                style:
                                appStyle(16, kDark, FontWeight.w600),
                              ),

                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                imageUploader.coverUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              EmailTextField(
                hintText: "Business Name",
                controller: _title,
                prefixIcon: Icon(
                  Ionicons.fast_food_outline,
                  color: Theme.of(context).dividerColor,
                  size: 20.h,
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Business Hours",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Time Picker
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: timeFrom,
                          );
                          if (pickedTime != null) {
                            setState(() {
                              timeFrom = pickedTime;
                              businessTimeFrom = pickedTime.format(context);
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
                          "From: ${timeFrom.format(context)}",
                          style: const TextStyle(
                            fontSize: 16, // Text size
                            fontWeight: FontWeight.bold, // Text weight
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w,),
                      const Text(
                        "-",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.w,),
                      ElevatedButton(
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: timeTo,
                          );
                          if (pickedTime != null) {
                            setState(() {
                              timeTo = pickedTime;
                              businessTimeTo = pickedTime.format(context);
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
                        child: Text("To: ${timeTo.format(context)}",
                          style: const TextStyle(
                            fontSize: 16, // Text size
                            fontWeight: FontWeight.bold, // Text weight
                          ),),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              EmailTextField(
                hintText: "Postal Code",
                controller: _postalCodeRes,
                prefixIcon: Icon(
                  Ionicons.locate_outline,
                  color: Theme.of(context).dividerColor,
                  size: 20.h,
                ),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
              ),
              SizedBox(
                height: 20.h,
              ),

              GestureDetector(
                onTap: () async {
                  // Navigate to AddNewPlace screen to choose a new address
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNewPlace(update: true),
                    ),
                  );

                  // If a result is returned, update the address and location
                  if (result != null) {
                    setState(() {
                      _address.text = result["address"];
                      _selectedLocation = LatLng(result["latitude"], result["longitude"]);
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  height: hieght * .12,
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
                                child: TextField(
                                  controller: _address, // The controller for editing the address
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter address',
                                    border: InputBorder.none, // No border for a clean look
                                  ),
                                  style: appStyle(13, kDark, FontWeight.w400),
                                  onChanged: (newValue) {
                                    // Optionally handle changes in the address field
                                  },
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
                            // Navigate to AddNewPlace to update the address and location
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddNewPlace(update: true),
                              ),
                            );

                            // If a result is returned, update the address and location
                            if (result != null) {
                              setState(() {
                                _address.text = result["address"];
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

              SizedBox(
                height: 5.h,
              ),
              Text(
                "Format: Blk No. Lot No., Street name, Building name, Unit number, Barangay, Province, Zip, Country",
                style: appStyle(11, kGray, FontWeight.normal),
              ),
              SizedBox(
                height: 20.h,
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
              SizedBox(
                height: 10.h,
              ),

              SizedBox(
                height: 20.h,
              ),
              Obx(() => restaurantController.isLoading ?
              Center(
                child: LoadingAnimationWidget.waveDots(
                    color: kSecondary,
                    size: 35
                ),
              ) :
              CustomButton(
                color: kPrimary,
                btnHieght: 45,
                onTap: () async {
                  String owner = box.read("userId");
                  String ownerId = jsonDecode(owner);
                  print("dsadsa"+isOtpVerified.toString());
                  // Check if the restaurant exists
                  String? restaurantId = box.read('restaurantId'); // This should be saved when the restaurant is created
                  if (_title.text.isNotEmpty &&
                      businessTimeFrom != null &&
                      businessTimeTo != null &&
                      _postalCodeRes.text.isNotEmpty &&
                      _address.text.isNotEmpty &&
                      imageUploader.logoUrl.isNotEmpty &&
                      imageUploader.coverUrl.isNotEmpty &&
                      _phoneController.text.isNotEmpty &&
                      _selectedLocation != null) {

                    RestaurantRequest data = RestaurantRequest(
                      title: _title.text,
                      time: '$businessTimeFrom - $businessTimeTo',
                      code: _postalCodeRes.text,
                      logoUrl: imageUploader.logoUrl,
                      imageUrl: imageUploader.coverUrl,
                      phoneNumber: _phoneController.text,
                      phoneVerification: isOtpVerified,
                      owner: ownerId,
                      coords: Coords(
                        id: 3023,
                        latitude: _selectedLocation!.latitude,
                        longitude: _selectedLocation!.longitude,
                        address: _address.text,
                        title: _title.text,
                      ),
                    );

                    String restaurant = restaurantRequestToJson(data);

                    // Update or create the restaurant based on whether restaurantId exists
                    restaurantController.updateRestaurant(restaurant, restaurantId);

                  } else {
                    Get.snackbar("Registration Failed", "Please fill all the fields and try again.",
                        icon: const Icon(Icons.add_alert));
                    print(_title.text);
                    print(businessTimeFrom);
                    print(businessTimeTo);
                    print(_postalCodeRes.text);
                    print(_address.text);
                    print(imageUploader.logoUrl);
                    print(imageUploader.coverUrl);
                    print(_phoneController.text);
                    print(_selectedLocation);
                  }
                },
                text: "Save",
              ),
              ),

              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ],
      )),)),)
    );
  }
}
