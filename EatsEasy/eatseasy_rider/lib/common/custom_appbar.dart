import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:eatseasy_rider/controllers/driver_controller.dart';
import 'package:eatseasy_rider/controllers/location_controller.dart';
import 'package:eatseasy_rider/hooks/fetchDriverAddress.dart';
import 'package:eatseasy_rider/models/driver_address_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../views/profile/profile_page.dart';

class CustomAppBar extends StatefulHookWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final box = GetStorage();
  bool _hasSetDefaultAddress = false;
  String profile =
      "https://dbestech-code.oss-ap-southeast-1.aliyuncs.com/foodly_flutter/icons/profile-photo.png?OSSAccessKeyId=LTAI5t8cUzUwGV1jf4n5JVfD&Expires=36001721319904&Signature=mxqrJ0bGFdbh05ORP7QHQsI3Ty0%3D";

  //LatLng _center = const LatLng(37.78792117665919, -122.41325651079953);
  Placemark? currentLocation;
  final location = Get.put(UserLocationController());

  @override
  dispose() {
    print("disposed...");
    super.dispose();
  }
  Stream<Map<String, dynamic>> newOrders() {
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref('drivers');

    return ordersRef.onValue.map((event) {
      final orderData = event.snapshot.value as Map<dynamic, dynamic>;
      return Map<String, dynamic>.from(orderData);
    });
  }

  Future<void> _handleLocation({String? address}) async {
    LatLng? _center;
    try {
      if (address != null && address.isNotEmpty) {
        // Geocode address
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          setState(() {
            _center = LatLng(locations[0].latitude, locations[0].longitude);
            print("Geocoded to: ${_center!.latitude}, ${_center!.longitude}");
          });
          List<Placemark> placemarks = await placemarkFromCoordinates(
              _center!.latitude, _center!.longitude);

          if (placemarks.isNotEmpty) {
            setState(() {
              currentLocation = placemarks[0];
              print("Current Location: ${currentLocation!.street}");
              String city = placemarks[0].locality ??
                  placemarks[0].subLocality ??
                  placemarks[0].administrativeArea ??
                  placemarks[0].subAdministrativeArea ??
                  placemarks[0].country??
                  placemarks[0].street??"";
              print("City2: ${currentLocation!.street}");
              box.write('defaultAddress', currentLocation!.street);
            });
          }
          // Update location in controller
          location.setUserLocation(_center!, currentLocation!.street);
          if (currentLocation != null) {
            location.setUserAddress(currentLocation!);
          }
        }
      } else {
        // Determine current position
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        _center = LatLng(currentPosition.latitude, currentPosition.longitude);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _center.latitude, _center.longitude);
        if (placemarks.isNotEmpty) {
          setState(() {
            currentLocation = placemarks[0];
            print("Current Location: ${currentLocation!.street}");
            String city = placemarks[0].locality ??
                placemarks[0].subLocality ??
                placemarks[0].administrativeArea ??
                placemarks[0].subAdministrativeArea ??
                placemarks[0].country??
                placemarks[0].street??"";
            print("City1: $city");
            box.write('defaultAddress', currentLocation!.street);
          });
        }
      }

      // Update location in controller
      location.setUserLocation(_center!, currentLocation!.street);
      if (currentLocation != null) {
        location.setUserAddress(currentLocation!);
      }
    } catch (e) {
      print('Error handling location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAdresses();
    final List<AddressesList> addresses = hookResult.data;
    final isLoading = hookResult.isLoading;
    if (isLoading) {
      return  const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(),
        ),
      );
    }

    String? defaultAddress;
    if (addresses.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleLocation(); // Just get the current location
      });
    } else if (!_hasSetDefaultAddress) {
      for (var address in addresses) {
        if (address.addressesListDefault) {
          defaultAddress = address.addressLine1;
          if (defaultAddress.isNotEmpty) {
            print("add....${defaultAddress}");
            _handleLocation(address: defaultAddress); // Geocode the address
            location.setUserDefaultAddress(defaultAddress);
            _hasSetDefaultAddress = true;
          }
        }
      }
    }
    final driverController = Get.put(DriverController());

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      height: 100,
      color: kLightWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /*GestureDetector(
                onTap: () {
              Get.to(() => const ProfilePage());
              },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: kTertiary,
                  backgroundImage: NetworkImage(profile),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: "Current Location",
                      style: appStyle(kFontSizeBodyRegular, kSecondary,
                          FontWeight.w600),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ReusableText(
                          text: isLoading == true
                              ? "Unknown location"
                              : location.userDefaultAddress.isNotEmpty == true
                              ? location.userDefaultAddress
                              : (currentLocation != null
                              ? '${currentLocation!.street}, ${currentLocation!.subLocality}, ${currentLocation!.locality}'
                              : "Philippines"),
                          style: appStyle(
                              kFontSizeBodySmall, kGray, FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Text(
                getTimeOfDay(),
                style: const TextStyle(fontSize: 35),
              ),
              Positioned(
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: newOrders(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    String lastOrder = "updated";
                    Map<String, dynamic> orderData = snapshot.data!;
                    if (lastOrder != orderData['order_id']) {
                      driverController.refetch.value = true;
                      lastOrder = orderData['order_id'];

                      Future.delayed(
                        const Duration(seconds: 2),
                            () {
                          driverController.refetch.value = false;
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ],
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
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:eatseasy_rider/controllers/driver_controller.dart';
import 'package:eatseasy_rider/controllers/location_controller.dart';
import 'package:eatseasy_rider/hooks/fetchDriverAddress.dart';
import 'package:eatseasy_rider/models/driver_address_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAppBar extends StatefulHookWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final box = GetStorage();
  bool _hasSetDefaultAddress = false;
  String profile = "https://dbestech-code.oss-ap-southeast-1.aliyuncs.com/foodly_flutter/icons/profile-photo.png?OSSAccessKeyId=LTAI5t8cUzUwGV1jf4n5JVfD&Expires=36001721319904&Signature=mxqrJ0bGFdbh05ORP7QHQsI3Ty0%3D";

  LatLng _center = const LatLng(37.78792117665919, -122.41325651079953);
  Placemark? currentLocation;
  final location = Get.put(UserLocationController());

  @override
  dispose(){
    print("disposed...");
    super.dispose();
  }


  Stream<Map<String, dynamic>> newOrders() {
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref('drivers');

    return ordersRef.onValue.map((event) {
      final orderData = event.snapshot.value as Map<dynamic, dynamic>;
      return Map<String, dynamic>.from(orderData);
    });
  }
  Future<void> _getCurrentLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      _getAddressFromLatLng(_center);
    });

    final location = Get.put(UserLocationController());
    location.setUserLocation(_center);
  }
  Future<void> _geocodeAddressAndSetCenter(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _center = LatLng(locations[0].latitude, locations[0].longitude);
          print("called here ${_center.latitude}");
        });

        location.setUserLocation(_center);

      }

    } catch (e) {
      print('Error geocoding address: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (placemarks.isNotEmpty) {
      setState(() {
        currentLocation = placemarks[0];

        final location = Get.put(UserLocationController());
        location.setUserAddress(currentLocation!);
      });
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    // Initialize hookResult within the build method
    final hookResult = useFetchAdresses();
    final List<AddressesList> addresses = hookResult.data;
    final isLoading = hookResult.isLoading;
    if(isLoading==true){
      return const SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      );
    }
    String? defaultAddress;
    // Check if addresses are empty and call _determinePosition
    if (addresses.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _determinePosition();
      });
    }else if(!_hasSetDefaultAddress){
      for(int x=0; x<addresses.length; x++){
        if(addresses[x].addressesListDefault==true){
          defaultAddress=addresses[x].addressLine1;
          if (defaultAddress.isNotEmpty) {
            List<String> words = defaultAddress.split(' ');
            String lastTwoWords = words.length >= 2
                ? '${words[words.length - 2]} ${words[words.length - 1]}'
                : defaultAddress;

            // Save the last two words to GetStorage
            box.write('defaultAddress', lastTwoWords);
            _geocodeAddressAndSetCenter(lastTwoWords);
            location.setUserDefaultAddress(defaultAddress);
            _hasSetDefaultAddress=true;
           // break;
          }
        }
      }


      print("${addresses[1].addressLine1}");
    }


    final driverController = Get.put(DriverController());

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      height: 100,
      color: kLightWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: kTertiary,
                backgroundImage: NetworkImage(profile),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: "Current Location",
                      style: appStyle(kFontSizeBodyRegular, kSecondary, FontWeight.w600),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ReusableText(
                          text: isLoading==true?"Unknown location": location.userDefaultAddress.isNotEmpty==true?location.userDefaultAddress :(currentLocation != null
                              ? '${currentLocation!.street}, ${currentLocation!.subLocality}, ${currentLocation!.locality}'
                              : "San Francisco 1 Stockton Street"),
                          style: appStyle(kFontSizeBodySmall, kGray, FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Text(
                getTimeOfDay(),
                style: const TextStyle(fontSize: 35),
              ),
              Positioned(
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: newOrders(),
                  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    String lastOrder = "updated";
                    Map<String, dynamic> orderData = snapshot.data!;
                    if (lastOrder != orderData['order_id']) {
                      driverController.refetch.value = true;
                      lastOrder = orderData['order_id'];

                      Future.delayed(
                        const Duration(seconds: 2),
                            () {
                          driverController.refetch.value = false;
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ],
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
} */