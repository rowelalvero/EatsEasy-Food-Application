import 'dart:convert';

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

import '../../models/environment.dart';

class RestaurantRegistration extends StatefulWidget {
  const RestaurantRegistration({super.key});

  @override
  State<RestaurantRegistration> createState() => _RestaurantRegistrationState();
}

class _RestaurantRegistrationState extends State<RestaurantRegistration> {
  late final TextEditingController _lastNameController = TextEditingController();
  late final TextEditingController _firstNameController = TextEditingController();
  //late final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  late final PageController _pageController = PageController(initialPage: 0);
  final controller = Get.put(UserLocationController());
  GoogleMapController? _mapController;
  final box = GetStorage();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final imageUploader = Get.put(ImageUploadController());
  final locationController = Get.put(UserLocationController());
  final restaurantController = Get.put(RestaurantController());
  //final TextEditingController _otpController = TextEditingController();
  TimeOfDay timeFrom = const TimeOfDay(hour: 8, minute: 0); // 8:00 AM
  TimeOfDay timeTo = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM

  String? verificationId;

  String? businessTimeFrom;
  String? businessTimeTo;
  //bool isVerifying = false;
  //bool isOtpVerified = false;


  @override
  void initState() {
    super.initState();
    _determinePosition();
    controller.currentIndex = 0;
    _pageController.addListener(() {
      setState(() {});
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

  List<dynamic> _placeList = [];
  final List<dynamic> _selectedPlace = [];
  LatLng? _selectedLocation;

  Future<void> _determinePosition() async {
    if (kIsWeb) {
      print("Web platform detected. Skipping permission request.");
      await _getCurrentLocation();
      return;
    }

    if (!await _checkLocationServices()) return;
    await _showLocationPermission();
  }

  Future<bool> _checkLocationServices() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }

    if (kIsWeb) {
      return true;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    return permission != LocationPermission.deniedForever;
  }

  Future<void> _showLocationPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      await _getCurrentLocation();
    } else if (status.isDenied) {
      print("Location permission denied.");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    if (kIsWeb) {
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        setState(() {
          _selectedLocation = LatLng(position.latitude, position.longitude);
          locationController.getAddressFromLatLng(_selectedLocation!);
          _searchController.text = locationController.address;
          _postalCodeRes.text = locationController.postalCode;
        });

        if (_selectedLocation != null && _mapController != null) {
          //moveToSelectedLocation();
          _mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _selectedLocation!,
                zoom: 16.0,
              ),
            ),
          );
        }
      } catch (e) {
        print("Error getting location on web: $e");
      }
    } else {
      var currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedLocation = LatLng(currentLocation.latitude, currentLocation.longitude);
        locationController.getAddressFromLatLng(_selectedLocation!);
        _searchController.text = locationController.address;
        _postalCodeRes.text = locationController.postalCode;
      });

      if (_selectedLocation != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _selectedLocation!,
              zoom: 16.0,
            ),
          ),
        );
      }
    }
  }

  Future<void> _onSearchChanged(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      final response = await http.post(
        Uri.parse('${Environment.appBaseUrl}/api/address/search-places'),
        body: json.encode({
          'searchQuery': searchQuery,
          'googleApiKey': Environment.googleApiKey2,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        setState(() {
          _placeList = [];
        });
      }
    } else {
      setState(() {
        _placeList = [];
      });
    }
  }

  Future<void> _getPlaceDetail(String placeId) async {
    final response = await http.post(
      Uri.parse('${Environment.appBaseUrl}/api/address/get-place-detail'),
      body: json.encode({
        'placeId': placeId,
        'googleApiKey': Environment.googleApiKey2,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _selectedLocation = LatLng(data['lat'], data['lng']);
        _searchController.text = data['address'];
        _postalCodeRes.text = data['postalCode'];
        moveToSelectedLocation();
        _placeList = [];
      });
    } else {
      print('Failed to fetch place details');
    }
  }

  void moveToSelectedLocation() {
    if (_selectedLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _selectedLocation!,
            zoom: 16.0, // Adjust zoom level as needed
          ),
        ),
      );
    }
  }

  void _onMarkerDragEnd(LatLng newPosition) async {
    setState(() {
      _selectedLocation = newPosition;
    });

    final response = await http.post(
      Uri.parse('${Environment.appBaseUrl}/api/address/reverse-geocode'),
      body: json.encode({
        'lat': newPosition.latitude,
        'lng': newPosition.longitude,
        'googleApiKey': Environment.googleApiKey2,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchController.text = data['address'];
        _postalCodeRes.text = data['postalCode'];
      });
    } else {
      print('Failed to fetch address for marker');
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOffWhite,
        title: ReusableText(
          text: "Business registration",
          style: appStyle(20, kDark, FontWeight.w400),
        ),
        elevation: 0,
        leading: controller.currentIndex == 1 ? Padding(
            padding: EdgeInsets.only(right: 0.w),
            child: IconButton(
              onPressed: () {
                controller.currentIndex = 0;
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              icon: const Icon(Icons.arrow_back_rounded, color: kDark),
            )
        ) : null,
      ),
      body: Center(child: SizedBox(width: 640, child:  BackGroundContainer(child: SizedBox(
        height: hieght,
        width: width,
        child: PageView(
          controller: _pageController,
          pageSnapping: false,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            _pageController.jumpToPage(index);
          },
          children: [
            Container(
              color: kGrayLight,
              width: width,
              height: hieght,
              child: Stack(
                children: [
                  if (_selectedLocation != null)
                    GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: _selectedLocation ??
                            const LatLng(37.77483, -122.41942),
                        zoom: 15.0,
                      ),
                      markers: _selectedLocation == null
                          ? Set.of([])
                          : {
                        /*Marker(
                            markerId: const MarkerId('Your Location'),
                            position: _selectedLocation!,
                            draggable: false,
                          ),*/
                      },
                      onCameraMove: (position) {
                        setState(() {
                          _selectedLocation = position.target;
                        });
                      },
                      onCameraIdle: () {
                        if (_selectedLocation != null) {
                          _onMarkerDragEnd(_selectedLocation!);
                        }
                      },
                    ),
                  const Center(
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  // Show a loading indicator if location is not yet available
                  if (_selectedLocation == null)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  const Center(
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),

                  Padding(padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Container(
                            height: 50, // Adjust the height as necessary
                            decoration: BoxDecoration(
                              color: kWhite, // Light grey background for text field
                              borderRadius: _placeList.isEmpty
                                  ? BorderRadius.circular(30) : const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30),), // Rounded corners
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                hintText: "Enter a location",
                                border: InputBorder.none, // Remove default borders
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              ),
                            )
                        ),
                        _placeList.isEmpty
                            ? const SizedBox.shrink()
                            : Container(
                          decoration: const BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true, // Let ListView take only the necessary height
                            physics: NeverScrollableScrollPhysics(), // Disable scrolling
                            itemCount: _placeList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: ListTile(
                                  visualDensity: VisualDensity.compact,
                                  title: Text(_placeList[index]['description']),
                                  onTap: () {
                                    _getPlaceDetail(_placeList[index]['place_id']);
                                    _selectedPlace.add(_placeList[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              width: width,
              height: hieght,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  ReusableText(
                      text: "Let's register your business!",
                      style: appStyle(20, kDark, FontWeight.bold)),
                  ReusableText(
                    text:
                    "You are required fill all the details fully with the correct information",
                    style: appStyle(11, kGray, FontWeight.normal),
                  ),
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
                  /*SizedBox(
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
                  ),*/
                  SizedBox(
                    height: 20.h,
                  ),

                  EmailTextField(
                    hintText: "Address",
                    controller: _searchController,
                    prefixIcon: Icon(
                      Ionicons.location_outline,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  ReusableText(
                    text:
                    "Format: Blk No. Lot No., Street name, Building name, Unit number, Barangay, Province, Zip, Country",
                    style: appStyle(11, kGray, FontWeight.normal),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  EmailTextField(
                    hintText: "First name",
                    controller: _firstNameController,
                    prefixIcon: Icon(
                      CupertinoIcons.person,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  EmailTextField(
                    hintText: "Last name",
                    controller: _lastNameController,
                    prefixIcon: Icon(
                      CupertinoIcons.person,
                      color: Theme.of(context).dividerColor,
                      size: 20.h,
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  /*Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          onChanged: (String value) {
                            setState(() {
                              isOtpVerified = false;
                            });
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
                  ),*/
                  ReusableText(
                      text: "Upload documents",
                      style: appStyle(16, kDark, FontWeight.bold)),
                  ReusableText(
                    text:
                    "You are required fill all the details fully with the correct information",
                    style: appStyle(11, kGray, FontWeight.normal),
                  ),
                  ReusableText(
                    text:
                    "Upload proof of residence e.g., Valid IDs, Electric/Water bill",
                    style: appStyle(11, kGray, FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          imageUploader.pickImage("1");
                        },
                        child: Badge(
                          backgroundColor: Colors.transparent,
                          label: Obx(
                                () => imageUploader.image1Url.isNotEmpty
                                ? GestureDetector(
                              onTap: () {
                                imageUploader.image1Url = '';
                              },
                              child: const Icon(Icons.remove_circle, color: kRed),
                            )
                                : Container(),
                          ),
                          child: Container(
                            height: 120.h,
                            width: 200.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: kGrayLight),
                            ),
                            child: Obx(
                                  () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "1"
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
                                  : imageUploader.image1Url.isEmpty
                                  ? Center(
                                child: Text(
                                  "Upload Valid ID",
                                  style: appStyle(16, kDark, FontWeight.w600),
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  imageUploader.image1Url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          imageUploader.pickImage("2");
                        },
                        child: Badge(
                          backgroundColor: Colors.transparent,
                          label: Obx(
                                () => imageUploader.image2Url.isNotEmpty
                                ? GestureDetector(
                              onTap: () {
                                imageUploader.image2Url = '';
                              },
                              child: const Icon(Icons.remove_circle, color: kRed),
                            )
                                : Container(),
                          ),
                          child: Container(
                            height: 120.h,
                            width: 200.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: kGrayLight),
                            ),
                            child: Obx(
                                  () => imageUploader.isLoading && imageUploader.imageBeingUploaded.value == "2"
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
                                  : imageUploader.image2Url.isEmpty
                                  ? Center(
                                child: Text(
                                  "Proof of Residence",
                                  style: appStyle(16, kDark, FontWeight.w600),
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  imageUploader.image2Url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),


                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                    color: kPrimary,
                    btnHieght: 45,
                    onTap: () async {
                      //var result = await _showVerificationSheet(context);

                      String owner = box.read("userId");
                      String ownerId = jsonDecode(owner);
                      String phone = box.read('phone');
                      if (controller.currentIndex == 1) {
                        if (_title.text.isNotEmpty &&
                            businessTimeFrom != null &&
                            businessTimeTo != null &&
                            //_postalCodeRes.text.isNotEmpty&&
                            _searchController.text.isNotEmpty &&
                            imageUploader.logoUrl.isNotEmpty &&
                            imageUploader.coverUrl.isNotEmpty &&
                            _firstNameController.text.isNotEmpty&&
                            _lastNameController.text.isNotEmpty&&
                            //_phoneController.text.isNotEmpty&&
                            imageUploader.image1Url.isNotEmpty &&
                            imageUploader.image2Url.isNotEmpty &&
                            _selectedLocation != null) {
                          RestaurantRequest data = RestaurantRequest(
                            title: _title.text,
                            time: '$businessTimeFrom - $businessTimeTo',
                            code: "3023",
                            logoUrl: imageUploader.logoUrl,
                            imageUrl: imageUploader.coverUrl,
                            image1Url: imageUploader.image1Url,
                            image2Url: imageUploader.image2Url,
                            ownerName: '${_firstNameController.text} ${_lastNameController.text}',
                            phoneNumber: phone,
                            owner: ownerId,
                            coords: Coords(
                              id: /*locationController.generateRandomNumber(10, 100000)*/3023,
                              latitude: _selectedLocation!.latitude,
                              longitude: _selectedLocation!.longitude,
                              address: _searchController.text,
                              title: _title.text,
                            ),
                          );

                          String restaurant = restaurantRequestToJson(data);

                          restaurantController.restaurantRegistration(restaurant);
                        } else {
                          Get.snackbar("Registration Failed",
                              "Please fill all the fields and try again.",
                              icon: const Icon(Icons.add_alert));
                        }
                      }

                    },
                    text: "S U B M I T",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),)),
      bottomSheet: buildBottomSheet(context),
    );
  }
  Widget buildBottomSheet(BuildContext context) {
    return controller.currentIndex == 0 ?
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures the container takes only the space it needs
        children: [
          controller.currentIndex == 1
              ? const SizedBox.shrink()
              : _searchController.text == null ? const SizedBox.shrink() : Container(
            width: width,
            decoration: const BoxDecoration(
                color: kOffWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: // Priority Option
            // Standard Option
            ListTile(
              leading: const Icon(Icons.location_on, color: kPrimary),
              title: Text(locationController.city),
              subtitle: Text(_searchController.text),
              trailing: IconButton(onPressed: () {_determinePosition();}, icon: const Icon(Icons.gps_fixed_rounded)),
            ),
          ),
          const SizedBox(height: 14),
          restaurantController.isLoading ?
          Center(
            child: LoadingAnimationWidget.waveDots(
                color: kPrimary,
                size: 35
            ),
          )
              : CustomButton(
            onTap: () {
              String owner = box.read("userId");
              String ownerId = jsonDecode(owner);
              String phone = box.read('phone');
              bool? phoneVerification= box.read('phoneVerification');
                if (controller.currentIndex == 1) {
                  if (_title.text.isNotEmpty &&
                      businessTimeFrom != null &&
                      businessTimeTo != null &&
                      //_postalCodeRes.text.isNotEmpty&&
                      _searchController.text.isNotEmpty &&
                      imageUploader.logoUrl.isNotEmpty &&
                      imageUploader.coverUrl.isNotEmpty &&
                      _firstNameController.text.isNotEmpty&&
                      _lastNameController.text.isNotEmpty&&
                      //_phoneController.text.isNotEmpty&&
                      imageUploader.image1Url.isNotEmpty &&
                      imageUploader.image2Url.isNotEmpty &&
                      _selectedLocation != null) {
                    RestaurantRequest data = RestaurantRequest(
                      title: _title.text,
                      time: '$businessTimeFrom - $businessTimeTo',
                      code: "3023",
                      logoUrl: imageUploader.logoUrl,
                      imageUrl: imageUploader.coverUrl,
                      image1Url: imageUploader.image1Url,
                      image2Url: imageUploader.image2Url,
                      ownerName: '${_firstNameController.text} ${_lastNameController.text}',
                      phoneNumber: phone,
                      phoneVerification: phoneVerification,
                      owner: ownerId,
                      coords: Coords(
                        id: /*locationController.generateRandomNumber(10, 100000)*/3023,
                        latitude: _selectedLocation!.latitude,
                        longitude: _selectedLocation!.longitude,
                        address: _searchController.text,
                        title: _title.text,
                      ),
                    );

                    String restaurant = restaurantRequestToJson(data);

                    restaurantController.restaurantRegistration(restaurant);
                  } else {
                    Get.snackbar("Registration Failed",
                        "Please fill all the fields and try again.",
                        icon: const Icon(Icons.add_alert));
                  }
                } else {
                  controller.currentIndex = 1;
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                }

            },
            radius: 24,
            color: kPrimary,
            btnWidth: width * 0.90,
            btnHieght: 50,
            text: controller.currentIndex == 1
                ? 'Submit'
                : 'Choose This Location',
          ),
          const SizedBox(height: 16),
        ],
      ),
    ) : SizedBox.shrink();
  }
}
