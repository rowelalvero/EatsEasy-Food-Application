import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/models/api_error.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/models/ready_orders.dart';
import 'package:eatseasy_partner/views/home/home_page.dart';
import 'package:eatseasy_partner/views/order/active_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrdersController extends GetxController {
  final box = GetStorage();
  ReadyOrders? order;

  int tabIndex = 0;

  var isLoadingAccept = false.obs;
  var isLoadingDecline = false.obs;
  var isLoadingPushToCouriers = false.obs;
  var isLoadingReady = false.obs;
  var isLoadingManual = false.obs;

  double _tripDistance = 0;
  double get tripDistance => _tripDistance;
  set setDistance(double newValue) {
    _tripDistance = newValue;
  }

  var _count = 0.obs;
  int get count => _count.value;
  set setCount(int newValue) {
    _count.value = newValue;
  }

  var _setLoading = false.obs;
  bool get isLoading => _setLoading.value;
  set setLoading(bool newValue) {
    _setLoading.value = newValue;
  }

  void pickOrder(String orderId) async {
    String token = box.read('token');
    String driverId = box.read('driverId');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url =
        Uri.parse('${Environment.appBaseUrl}/api/orders/picked-orders/$orderId/$driverId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;

        Get.snackbar("Order picked successfully",
            "To view the order, go to the active tab.",
            icon: const Icon(FontAwesome5Solid.shipping_fast));

        Map<String, dynamic> data = jsonDecode(response.body);
        order = ReadyOrders.fromJson(data);

        Get.off(() => const ActivePage());
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(
            data.message, "Failed to picking an order, please try again.",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to picking an order, please try again.",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void processOrder(String orderId, String status) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    _setLoading.value = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/orders/process/$orderId/$status');
    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        _setLoading.value = false;

        Get.off(() =>  const HomePage());
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message,
            "Failed to mark as delivered, please try again or contact support.",
            icon: const Icon(Icons.error));
        print("Status code is ${response.statusCode}");
      }
    } catch (e) {
      _setLoading.value = false;
      Get.snackbar(
          e.toString(), "Failed to mark order as delivered please try again.",
          icon: const Icon(Icons.error));
    } finally {
      _setLoading.value = false;
    }
  }
}
