// ignore_for_file: prefer_final_fields, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/order_details.dart';
import 'package:eatseasy/models/sucess_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class NotificationsController extends GetxController {
  final box = GetStorage();
  GetOrder? order;


  RxString _fcmToken = ''.obs;
  String get fcmToken => _fcmToken.value;
  set setFcm(String newValue) {
    _fcmToken.value = newValue;
  }

  RxBool _loading = false.obs;
  bool get loading => _loading.value;
  set setLoader(bool newLoader) {
    _loading.value = newLoader;
  }

  Rx<LatLng> _currentLocation = LatLng(0.0, 0.0).obs;
  LatLng get currentLocation => _currentLocation.value;
  void updateLocation(LatLng newLocation) {
    _currentLocation.value = newLocation;
  }

  RxString _orderStatus = ''.obs;
  String get orderStatus => _orderStatus.value;
  void updateOrderStatus(String newStatus) {
    _orderStatus.value = newStatus;
  }

  // Function to fetch order and observe the driver’s location and status
  Future<void> getOrder(String orderId) async {
    setLoader = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/orders/$orderId');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        order = getOrderFromJson(response.body);
        setLoader = false;
      } else {
        var data = apiErrorFromJson(response.body);
        setLoader = false;
        Get.snackbar(data.message, "Failed to login, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoader = false;
      debugPrint(e.toString());
    }
  }

  String extractOrderNumber(String input) {
    // Find the start index of the order number
    String identifier = "order : ";
    int startIndex = input.indexOf(identifier);

    // Check if the identifier is found
    if (startIndex != -1) {
      // Adjust startIndex to the beginning of the order number
      startIndex += identifier.length;

      // Extract the order number
      // Assuming the order number length is fixed (e.g., 24 characters long)
      return input.substring(startIndex, startIndex + 24);
    }

    // Return an empty string if the identifier is not found
    return '';
  }

  void updateUserToken(String deviceToken) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    var url = Uri.parse('${Environment.appBaseUrl}/api/users/updateToken/$deviceToken');
    print("device token $deviceToken");
    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        var data = successResponseFromJson(response.body);
        debugPrint(data.message);
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}
