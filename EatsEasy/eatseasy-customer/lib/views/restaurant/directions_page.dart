import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/app_style.dart';
import 'package:eatseasy/common/divida.dart';
import 'package:eatseasy/common/reusable_text.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/distance_time.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:eatseasy/services/distance.dart';
import 'package:eatseasy/views/restaurant/restaurants_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../controllers/address_controller.dart';

class DirectionsPage extends StatefulWidget {
  const DirectionsPage({super.key, required this.restaurant});

  final Restaurants restaurant;

  @override
  State<DirectionsPage> createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Placemark? place;
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  LatLng _center = const LatLng(45.521563, -122.677433);

  final box =  GetStorage();

  DistanceTime? distanceTime;
  final controller = Get.put(AddressController());
  double totalTime = 30;

  Map<MarkerId, Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _fetchDistance();
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

  Future<void> _getCurrentLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() async {
      //_center = LatLng(currentLocation.latitude, currentLocation.longitude);
      _center = LatLng(controller.defaultAddress!.latitude,
          controller.defaultAddress!.longitude);
      CameraPosition _kGooglePlex = const CameraPosition(
        target: LatLng(53, 10),
        zoom: 14.4746,
      );

      _addMarker(_center, "You", widget.restaurant.imageUrl);
      _addMarker(
          LatLng(widget.restaurant.coords.latitude,
              widget.restaurant.coords.longitude),
          widget.restaurant.title.toString(), widget.restaurant.imageUrl);
      await _getPolyline();
    });
  }

  void _addMarker(LatLng position, String id, String? imageUrl) {
    setState(() {
      final markerId = MarkerId(id);
      final marker = Marker(
        markerId: markerId,
        position: position,
        infoWindow: InfoWindow(title: id),
      );
      markers[markerId] = marker;
    });
  }

  Future<void> _getPolyline() async {
    final String url = '${Environment.appBaseUrl}/api/address/getPolyline';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'originLat': _center.latitude.toString(),
          'originLng': _center.longitude.toString(),
          'destinationLat': widget.restaurant.coords.latitude.toString(),
          'destinationLng': widget.restaurant.coords.longitude.toString(),
          'googleApiKey': Environment.googleApiKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final decodedPolyline = data['polyline'];
          polylineCoordinates = decodedPolyline.map<LatLng>((point) {
            return LatLng(point['latitude'], point['longitude']);
          }).toList();

          if (polylineCoordinates.isEmpty) {
            print("No polyline coordinates decoded.");
            return;
          }

          _addPolyLine();
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load polyline data from backend, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _addPolyLine() {
    PolylineId id = const PolylineId("route");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    setState(() {
      polylines[id] = polyline;
      _updateCameraBounds();
    });

    print("Polyline added with ${polylineCoordinates.length} points.");
  }

  Future<void> _fetchDistance() async {
    Distance distanceCalculator = Distance();
    distanceTime = await distanceCalculator.calculateDistanceDurationPrice(
        controller.defaultAddress!.latitude,
        controller.defaultAddress!.longitude,
        widget.restaurant.coords.latitude,
        widget.restaurant.coords.longitude,
        35,
        pricePkm
    );
    setState(() {
      totalTime += distanceTime!.time;
    }); // Update the UI with fetched data
  }

  Future<void> _updateCameraBounds() async {
    if (polylineCoordinates.isNotEmpty) {
      final GoogleMapController mapController = await _controller.future;

      LatLngBounds bounds = LatLngBounds(
        southwest: polylineCoordinates.reduce((a, b) =>
            LatLng(a.latitude < b.latitude ? a.latitude : b.latitude,
                a.longitude < b.longitude ? a.longitude : b.longitude)),
        northeast: polylineCoordinates.reduce((a, b) =>
            LatLng(a.latitude > b.latitude ? a.latitude : b.latitude,
                a.longitude > b.longitude ? a.longitude : b.longitude)),
      );

      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }
  @override
  Widget build(BuildContext context) {

    LatLng restaurant = LatLng(
        widget.restaurant.coords.latitude, widget.restaurant.coords.longitude);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: restaurant,
              zoom: 30.0,
            ),
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: width,
              height: 280.h,
              decoration: BoxDecoration(
                  color: kPrimary.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r))),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                decoration: BoxDecoration(
                    color: kLightWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                            text: widget.restaurant.title!,
                            style: appStyle(20, kGray, FontWeight.bold)),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: kTertiary,
                          backgroundImage:
                              NetworkImage(widget.restaurant.imageUrl!),
                        ),
                      ],
                    ),
                    const Divida(),
                RowText(
                    first: "Distance To Restaurant",
                    second: distanceTime != null
                        ? "${distanceTime!.distance.toStringAsFixed(2)} km"
                        : "Loading..."),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Delivery fee",
                        second: distanceTime != null
                            ? "\Php ${distanceTime!.price.toStringAsFixed(2)}"
                            : "Loading..."),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Estimated Delivery Time to Current Location",
                        second: distanceTime != null
                            ? "${"${totalTime.toStringAsFixed(0)} - ${(totalTime + distanceTime!.time).toStringAsFixed(0)}" } mins."
                            : "Loading..."),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Business Hours",
                        second: widget.restaurant.time),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Divida(),
                    RowText(
                        first: "Address: ",
                        second: widget.restaurant.coords.address),
                    SizedBox(
                      height: 10.h,
                    ),
                    /*const CustomButton(
                      color: kPrimary,
                      btnHieght: 35,
                      radius: 6,
                      text: "Make a reservation",
                    )*/
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Ionicons.chevron_back_circle,
                color: kDark,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}
