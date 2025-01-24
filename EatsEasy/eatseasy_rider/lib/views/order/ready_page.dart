// ignore_for_file: unrelated_type_equality_checks, unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:eatseasy_rider/common/back_ground_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_rider/common/app_style.dart';
import 'package:eatseasy_rider/common/custom_btn.dart';
import 'package:eatseasy_rider/common/divida.dart';
import 'package:eatseasy_rider/common/reusable_text.dart';
import 'package:eatseasy_rider/common/row_text.dart';
import 'package:eatseasy_rider/common/show_snack_bar.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/location_controller.dart';
import 'package:eatseasy_rider/controllers/order_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../common/not_found.dart';
import '../../controllers/contact_controller.dart';
import '../../controllers/update_driver_controller.dart';
import '../../hooks/fetchUsers.dart';
import '../../models/distance_time.dart';
import '../../models/response_model.dart';
import '../../models/users.dart';
import '../../services/distance.dart';
import 'delivered.dart';
import 'no_selection.dart';

class ActivePage extends StatefulHookWidget {
  const ActivePage({
    super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  final box = GetStorage();
  final ordersController = Get.find<OrdersController>();
  final userController = Get.find<UserLocationController>();
  final ContactController _controller = Get.put(ContactController());
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinatesToRestaurant = [];
  List<LatLng> polylineCoordinatesToClient = [];
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  DistanceTime? distanceTime1;
  DistanceTime? distanceTime2;
  LatLng? _previousPosition;
  late LatLng _restaurant;
  late LatLng _client;
  late LatLng _rider = LatLng(userController.currentLocation.latitude, userController.currentLocation.longitude);
  late final LatLng _initialRiderLocation = LatLng(userController.currentLocation.latitude, userController.currentLocation.longitude);

  StreamSubscription<LatLng>? _uploadPositionStream;
  StreamSubscription<Position>? _trackPositionStream;

  @override
  void initState() {
    super.initState();
    setState(() {
      _initializeCoordinates();
      _determinePosition();
      _trackRiderLocation();
      //_uploadRiderLocation();
      fetchDistances();
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    _trackPositionStream?.cancel();
    _uploadPositionStream?.cancel();
    super.dispose();
  }

  void _initializeCoordinates() {
    if (ordersController.order != null) {
      setState(() {
        _restaurant = LatLng(ordersController.order!.restaurantCoords[0], ordersController.order!.restaurantCoords[1]);
        _client = LatLng(ordersController.order!.recipientCoords[0], ordersController.order!.recipientCoords[1]);
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _determinePosition() async {
    if (!await _checkLocationServices()) return;

    _getCurrentLocation();
  }

  Future<bool> _checkLocationServices() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false; // Location services are disabled.
    }

    LocationPermission permission = await Geolocator.checkPermission();
    return permission != LocationPermission.deniedForever; // Location permissions are permanently denied.
  }

  void _getCurrentLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _rider = LatLng(currentLocation.latitude, currentLocation.longitude);
      _addMarkers();
      fetchDistances();
      _getPolylines();
    });
  }

  /*void _uploadRiderLocation() {
    if (ordersController.order!.orderStatus != 'Ready') {
      _uploadPositionStream = Stream.periodic(const Duration(seconds: 15)).asyncMap((_) async {
        LatLng newPosition = LatLng(userController.currentLocation.latitude, userController.currentLocation.longitude);
        return newPosition;
      }).listen((newPosition) {
        String? driverId = box.read('driverId');
        userController.updateDriverLocation(driverId!, newPosition.latitude, newPosition.longitude);
      });
    }
  }*/

  void _trackRiderLocation() {
    String? driverId = box.read('driverId');
    if (ordersController.order!.driverStatus != 'Vacant') {
      _trackPositionStream = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
        distanceFilter: 20, // Updates every 10 meters change
      ).listen((Position position) {

        LatLng newPosition = LatLng(position.latitude, position.longitude);
        if (_previousPosition != newPosition) {
          _rider = newPosition;
          _updateMarker("rider_location", _rider);

          userController.updateDriverLocation(driverId!, newPosition.latitude, newPosition.longitude);

          if (_previousPosition != null) {
            _updateCameraPosition(newPosition, _previousPosition!);
          }
          _previousPosition = newPosition;

          // Update polylines based on order status
          if (ordersController.order!.driverStatus == 'Delivering') {
            setState(() {
              fetchDistance1();
            });
          } else if(ordersController.order!.driverStatus == 'Picking') {
            setState(() {
              fetchDistance2();
            });
          }
        }
      });
    }
  }


  void _updateCameraPosition(LatLng newPosition, LatLng previousPosition) {
    double bearing = _calculateBearing(previousPosition, newPosition);

    CameraPosition cameraPosition = CameraPosition(
      target: newPosition,
      zoom: 19.0,
      bearing: bearing, // Set the camera to point in the direction of movement
      tilt: 65.0, // Optional: tilt the camera for a more immersive experience
    );

    mapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * pi / 180;
    double lon1 = start.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;

    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360;
  }

  void _addMarkers() {
    _addMarker(_restaurant, "restaurant_location");
    _addMarker(_client, "client_location");
    _addMarker(_rider, "rider_location");
  }

  Future<void> _addMarker(LatLng position, String id) async {
    final markerId = MarkerId(id);
    BitmapDescriptor markerIcon = await _getMarkerIcon(id);

    final marker = Marker(
      markerId: markerId,
      position: position,
      icon: markerIcon,
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<BitmapDescriptor> _getMarkerIcon(String id) async {
    String assetPath;
    switch (id) {
      case "restaurant_location":
        assetPath = 'assets/images/restaurant_marker.png';
        break;
      case "client_location":
        assetPath = 'assets/images/client_marker.png';
        break;
      default:
        assetPath = 'assets/images/rider_marker.png';
        break;
    }
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(5, 5)),
      assetPath,
    );
  }

  void _updateMarker(String id, LatLng position) {
    final markerId = MarkerId(id);
    if (markers.containsKey(markerId)) {
      markers[markerId] = markers[markerId]!.copyWith(positionParam: position);
    }
  }


  Future<void> _getPolylines() async {
    if (ordersController.order!.driverStatus == 'Delivering') {
      // Restaurant to Client
      PolylineResult resultToClient = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_restaurant.latitude, _restaurant.longitude),
          destination: PointLatLng(_client.latitude, _client.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (resultToClient.status == 'OK') {
        polylineCoordinatesToClient.clear();
        for (var point in resultToClient.points) {
          polylineCoordinatesToClient.add(LatLng(point.latitude, point.longitude));
        }
      }
      _addPolyLines();
    } else if (ordersController.order!.driverStatus == 'Picking') {
      PolylineResult resultToRestaurant = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_initialRiderLocation.latitude, _initialRiderLocation.longitude),
          destination: PointLatLng(_restaurant.latitude, _restaurant.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (resultToRestaurant.status == 'OK') {
        polylineCoordinatesToRestaurant.clear();
        for (var point in resultToRestaurant.points) {
          polylineCoordinatesToRestaurant.add(LatLng(point.latitude, point.longitude));
        }
      }
      _addPolyLines();

    } else {
      // Rider to Restaurant
      PolylineResult resultToRestaurant = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_rider.latitude, _rider.longitude),
          destination: PointLatLng(_restaurant.latitude, _restaurant.longitude),
          mode: TravelMode.driving,
        ),
      );

      // Restaurant to Client
      PolylineResult resultToClient = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApiKey,
        request: PolylineRequest(
          origin: PointLatLng(_restaurant.latitude, _restaurant.longitude),
          destination: PointLatLng(_client.latitude, _client.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (resultToRestaurant.status == 'OK') {
        polylineCoordinatesToRestaurant.clear();
        for (var point in resultToRestaurant.points) {
          polylineCoordinatesToRestaurant.add(LatLng(point.latitude, point.longitude));
        }
      }

      if (resultToClient.status == 'OK') {
        polylineCoordinatesToClient.clear();
        for (var point in resultToClient.points) {
          polylineCoordinatesToClient.add(LatLng(point.latitude, point.longitude));
        }
      }
      _addPolyLines();
    }
  }

  void _addPolyLines() {
    setState(() {
      polylines.clear();
      if (ordersController.order!.driverStatus == 'Delivering') {
        // Rider to Client (Red)
        polylines[const PolylineId("rider_to_client")] = Polyline(
          polylineId: const PolylineId("rider_to_client"),
          color: Colors.red,
          points: polylineCoordinatesToClient,
          width: 6,
        );
      } else if (ordersController.order!.driverStatus == 'Picking') {
        // Rider to Restaurant (Orange)
        polylines[const PolylineId("rider_to_restaurant")] = Polyline(
          polylineId: const PolylineId("rider_to_restaurant"),
          color: Colors.purple,
          points: polylineCoordinatesToRestaurant,
          width: 6,
        );
      } else {
        // Rider to Restaurant (Orange)
        polylines[const PolylineId("rider_to_restaurant")] = Polyline(
          polylineId: const PolylineId("rider_to_restaurant"),
          color: Colors.purple,
          points: polylineCoordinatesToRestaurant,
          width: 6,
        );

        // Restaurant to Client (Red)
        polylines[const PolylineId("restaurant_to_client")] = Polyline(
          polylineId: const PolylineId("restaurant_to_client"),
          color: kPrimary,
          points: polylineCoordinatesToClient,
          width: 6,
        );
      }
    });
  }

  Future<void> fetchDistances() async {
    await Future.wait([fetchDistance1(), fetchDistance2()]);
  }

  Future<void> fetchDistance1() async {
    Distance distanceCalculator = Distance();
    distanceTime1 = await distanceCalculator.calculateDistanceDurationPrice(
      _rider.latitude,
      _rider.longitude,
      ordersController.order!.recipientCoords[0],
      ordersController.order!.recipientCoords[1],
      35,
      pricePkm,
    );
  }

  Future<void> fetchDistance2() async {
    Distance distanceCalculator = Distance();
    distanceTime2 = await distanceCalculator.calculateDistanceDurationPrice(
      _rider.latitude,
      _rider.longitude,
      ordersController.order!.restaurantCoords[0],
      ordersController.order!.restaurantCoords[1],
      35,
      pricePkm,
    );
  }

  Future<ResponseModel> loadData() async {
    //prepare the contact list for this user.
    //get the restaurant info from the firebase
    //get only one restaurant info
    return _controller.asyncLoadSingleUser();
  }

  void loadChatData ()async{
    ResponseModel response = await loadData();
    if(response.isSuccess==false){
      showCustomSnackBar(response.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrdersController());
    String numberString = orderController.order!.orderItems[0].foodId.time.substring(0, 2);
    double tripTime = double.parse(numberString);
    final driverController = Get.put(DriverEditController());
    String? token = box.read('token');

    final hookResult = useFetchUsers(orderController.order?.userId.id);
    print(orderController.order?.userId.id);
    var userData = hookResult.data;
    final load = hookResult.isLoading;
    late User? user = userData;

    if (token != null) {
      driverController.fetchDriverDetails();
    }

    if (load == false) {
      userData = hookResult.data;

      if (userData != null) {
        // Encoding to JSON string
        String jsonString = jsonEncode(userData);


        // Decoding the JSON string back to Map
        Map<String, dynamic> resData = jsonDecode(jsonString);

        // Assigning the restaurant ID to the controller state
        _controller.state.recipientId.value = resData["_id"];

        // Load chat data
        loadChatData();
      } else {
        print("restaurantData is null");
      }
    }

    return orderController.order == null
        ? const NoSelection()
        : orderController.order != null &&
        orderController.order!.driverStatus == 'Delivered'
        ? const DeliveredPage()
        : Scaffold(

        body: Center(child: BackGroundContainer(child: Stack(
          children: [
            // Google Map as the background
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _onMapCreated(controller);
              },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _rider,
                zoom: 14.0,
              ),
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
              padding: const EdgeInsets.only(bottom: 150),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CustomButton(
                radius: 24,
                color: kPrimary,
                btnWidth: width * 0.90,
                btnHieght: 50 ,
                text: "Show Order Details",
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    showDragHandle: true,
                    barrierColor: kGrayLight.withOpacity(0.2),
                    isScrollControlled: true,  // Allows it to expand fully if needed
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                    builder: (BuildContext context) {
                      return Obx(() => Container(
                        decoration: BoxDecoration(
                          color: kOffWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        child: Container(
                          width: width,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          margin: const EdgeInsets.fromLTRB(8, 8, 8, 12 ),
                          decoration: BoxDecoration(
                            color: kLightWhite,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    orderController.order!.driverStatus == 'Delivering'
                                        ? Flexible(
                                      child: ReusableText(
                                        text: orderController.order!.userId.username,
                                        style: appStyle(20, kGray, FontWeight.bold),
                                      ),
                                    )
                                        : Flexible(
                                      child: ReusableText(
                                        text: orderController.order!.restaurantId.title,
                                        style: appStyle(20, kGray, FontWeight.bold),
                                      ),
                                    ),



                                  ],
                                ),
                                SizedBox(height: 10,),
                                orderController.order!.driverStatus == 'Delivering'
                                    ? Row(
                                  children: [
                                    CustomButton(
                                      btnWidth: 200,
                                      radius: 30,
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.r),
                                                child: Image.network(
                                                  orderController.order!.userId.proofOfResidenceUrl!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      color: kPrimary,
                                      text: "Show recipient home",
                                    ),
                                    const SizedBox( width: 10),
                                    Positioned(
                                        bottom: 10,
                                        right: 15,
                                        child: CustomButton(
                                            btnWidth: 110,
                                            radius: 30,
                                            color: kSecondary,
                                            onTap: () async {
                                              if(orderController.order?.userId==null){
                                                Get.to(
                                                        () =>  const NotFoundPage(
                                                      text: "Can not open restaurant page",
                                                    ),
                                                    arguments: {});
                                              } else{
                                                print(orderController.order?.userId);
                                                ResponseModel status = await _controller.goChat(userData);
                                                if(status.isSuccess==false){
                                                  showCustomSnackBar(status.message!, title: status.title!);
                                                }
                                              }
                                            },
                                            text: "Chat")
                                    )
                                  ],
                                )
                                    : const SizedBox.shrink(),
                                const Divida(),
                                orderController.order!.driverStatus == 'Delivering'
                                    ? RowText(
                                  first: "Distance remaining to recipient:",
                                  second: distanceTime1 != null
                                      ? "${distanceTime1!.distance.toStringAsFixed(1)} km"
                                      : "Loading...",
                                )
                                    : RowText(
                                  first: "Distance remaining to restaurant:",
                                  second: distanceTime2 != null
                                      ? "${distanceTime2!.distance.toStringAsFixed(1)} km"
                                      : "Loading...",
                                ),
                                SizedBox(height: 5 ),
                                orderController.order!.driverStatus == 'Delivering'
                                    ? RowText(
                                  first: "Estimated arrival time to recipient: ",
                                  second: distanceTime1 != null
                                      ? "${distanceTime1!.time.toStringAsFixed(0)} mins"
                                      : "Loading...",
                                )
                                    : RowText(
                                  first: "Estimated arrival time to restaurant: ",
                                  second: distanceTime1 != null
                                      ? "${distanceTime1!.time.toStringAsFixed(0)} mins"
                                      : "Loading...",
                                ),
                                SizedBox(height: 5 ),
                                orderController.order!.driverStatus == 'Vacant'
                                    ? Column(
                                  children: [
                                    RowText(
                                      first: "Distance from Restaurant to Client",
                                      second: "${orderController.restaurantToClient.toStringAsFixed(1)} km",
                                    ),
                                    SizedBox(height: 5 ),
                                    RowText(
                                      first: "Total Distance",
                                      second: "${orderController.tripDistance.toStringAsFixed(1)} km",
                                    ),
                                    SizedBox(height: 5 ),
                                  ],
                                )
                                    : const SizedBox.shrink(),
                                RowText(
                                  first: "Payment method: ",
                                  second: orderController.order?.paymentMethod == "COD"
                                      ? "Cash on delivery"
                                      : "Wallet",
                                ),
                                SizedBox(height: 5 ),
                                RowText(
                                  first: "Order total: ",
                                  second: 'Php ${orderController.order?.orderTotal.toStringAsFixed(2)}',
                                ),
                                SizedBox(height: 5 ),
                                RowText(
                                  first: "Delivery Fee",
                                  second: "Php ${orderController.order!.deliveryFee.toStringAsFixed(1)}",
                                ),
                                SizedBox(height: 10 ),
                                const Divida(),
                                orderController.order!.driverStatus == 'Delivering'
                                    ? Column(
                                  children: [
                                    RowText(
                                      first: "Recipient's name: ",
                                      second: orderController.order!.userId.username,
                                    ),
                                    RowText(
                                      first: "Recipient's phone: ",
                                      second: orderController.order!.userId.phone,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Recipient's instructions: ",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Flexible(
                                          child: Text(
                                            orderController.order!.deliveryAddress.deliveryInstructions,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Flexible(
                                          child: Text(
                                            "Recipient's address: ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            orderController.order!.deliveryAddress.addressLine1,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                                    : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Flexible(
                                          child: Text(
                                            "Restaurant's address: ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            orderController.order!.restaurantId.coords.address,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Flexible(
                                          child: Text(
                                            "Recipient's address: ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            orderController.order!.deliveryAddress.addressLine1,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10 ),
                                Obx(() => orderController.setLoading
                                    ? Expanded(
                                  flex: 3,
                                  child: Center( // Center the loading animation
                                    child: LoadingAnimationWidget.waveDots(
                                        color: kSecondary,
                                        size: 35
                                    ),
                                  ),
                                ) : orderController.order!.driverStatus == 'Vacant'
                                    ? CustomButton(
                                  onTap: () async {
                                    if(orderController.tripDistance > 20){
                                      showCustomSnackBar("It's too far for you to deliver the order", title: "Distance alert");
                                    } else {
                                      if(orderController.order?.paymentMethod == "COD") {
                                        await orderController.initiateRiderPay(
                                          orderController.order!.paymentMethod,
                                          orderController.order!.id,
                                          orderController.order!.orderTotal,
                                          orderController.order!.restaurantId.id,
                                          user?.fcm
                                        );
                                      } else {
                                        await orderController.acceptOrder(
                                          orderController.order!.id,
                                        );
                                      }
                                      orderController.tabIndex = 1;
                                      /*_trackRiderLocation();
                                  _getPolylines();*/
                                    }
                                  },
                                  color: kPrimary,
                                  btnHieght: kCustomButtonHeight,
                                  radius: kCustomButtonRadius,
                                  text: orderController.order?.paymentMethod == "COD" ? "Pay and accept order" : "Accept order",
                                )

                                    : orderController.order!.driverStatus == 'Picking'
                                    ? CustomButton(
                                  onTap: () async {
                                    await orderController.pickOrder(orderController.order!.id);
                                    _trackRiderLocation();
                                    _getPolylines();
                                    orderController.tabIndex = 2;
                                    /*if (orderController.order!.orderStatus == 'Ready') {
                                      await orderController.pickOrder(orderController.order!.id);
                                      _trackRiderLocation();
                                      _getPolylines();
                                      orderController.tabIndex = 2;
                                    }*/
                                  },
                                  color: kPrimary,
                                  btnHieght: kCustomButtonHeight,
                                  radius: kCustomButtonRadius,
                                  text: "Mark as order picked",
                                )
                                    : orderController.order!.driverStatus == 'Delivering'
                                    ?  CustomButton(
                                  onTap: () {
                                    orderController.markOrderAsDelivered(orderController.order!.id);
                                    orderController.tabIndex = 3;
                                  },
                                  color: kPrimary,
                                  btnHieght: kCustomButtonHeight,
                                  radius: kCustomButtonRadius,
                                  text: "Mark as delivered",
                                )
                                    : const SizedBox.shrink()
                                )
                              ],
                            ),
                          ),
                        ),
                      ));
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 50 ,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      AntDesign.closecircle,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                  /*Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    width: width * 0.8,
                    height: 30 ,
                    decoration: BoxDecoration(
                      color: kOffWhite,
                      border: Border.all(color: kPrimary, width: 1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: RowText(
                      color: kPrimary,
                      first: "Order Number",
                      second: orderController.order!.id,
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        )),)
    );
  }
}
