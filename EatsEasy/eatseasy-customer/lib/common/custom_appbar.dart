import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/address_controller.dart';
import 'package:eatseasy/controllers/location_controller.dart';
import 'package:eatseasy/hooks/fetchDefaultAddress.dart';
import 'package:eatseasy/views/orders/widgets/updates.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cached_image_loader.dart';
class CustomAppBar extends StatefulHookWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final box = GetStorage();
  @override
  void initState() {
    // _determinePosition();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    _determinePosition();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    print("disposed....");
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final location = Get.put(UserLocationController());
    final controller = Get.put(AddressController());
    String? accessToken = box.read("token");
    if (accessToken != null) {
      useFetchDefault(context, false);
    }
    String? userId = box.read("userId");
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      height: 110,
      color: kOffWhite,
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /*Stack(
                  children: [
                    CachedImageLoader(
                      imageWidth: 50,
                      imageHeight:50,
                      image: profile,
                    ),
                    Positioned(
                        child: userId != null
                            ? UpdatesWidget(id: jsonDecode(userId.toString()))
                            : const SizedBox.shrink())
                  ],
                ),*/
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                          text: "Delivering to",
                          style: appStyle(16, kSecondary, FontWeight.w600)),
                      Obx(() => SizedBox(
                        width: width * 0.65,
                        child: Text(
                            location.address.isNotEmpty
                                ? controller.defaultAddress == null
                                ? location.address
                                : controller
                                .defaultAddress!.addressLine1
                                : "Philippines",
                            overflow: TextOverflow.ellipsis,
                            style: appStyle(11, kGray, FontWeight.normal)),
                      ))
                    ],
                  ),
                ),
              ],
            ),
            Text(
              getTimeOfDay(),
              style: const TextStyle(fontSize: 35),
            )
          ],
        ),
      ),
    );
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return "☀️";
    } else if (hour >= 12 && hour < 17) {
      return "🌤️";
    } else {
      return "🌙";
    }
  }

  String profile =
      'https://dbestech-code.oss-ap-southeast-1.aliyuncs.com/foodly_flutter/icons/profile.png?OSSAccessKeyId=LTAI5t8cUzUwGV1jf4n5JVfD&Expires=36001719669835&Signature=7Uq1tIBihBaJBBEBt1bMDLjU3Vs%3D';
  LatLng _center = const LatLng(37.78792117665919, -122.41325651079953);
  Placemark? currentLocation;

  Future<void> _getCurrentLocation() async {
    final location = Get.put(UserLocationController());

    location.setUserLocation(_center);
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (!mounted) return;
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      location.getAddressFromLatLng(_center);
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _getCurrentLocation();
  }
}