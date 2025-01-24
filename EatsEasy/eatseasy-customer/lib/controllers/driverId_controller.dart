import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/environment.dart';
import '../models/order_details.dart';

class DriverController extends GetxController {
  final box = GetStorage();
  Rx<Driver?> driverIdData = Rx<Driver?>(null);

  RxBool _isLoading = false.obs;
  bool get loading => _isLoading.value;
  set setLoader(bool newLoader) {
    _isLoading.value = newLoader;
  }

  RxString _orderStatus = ''.obs;
  String get orderStatus => _orderStatus.value;
  set setOrderStatus(String newOrderStatus) {
    _orderStatus.value = newOrderStatus;
  }

  var error = ''.obs;

  // Fetch driverId data
  Future<void> fetchDriverData(String driverId) async {
    String accessToken =  box.read('token');
    _isLoading.value = true;
    error.value = '';

    try {
      var url = Uri.parse('${Environment.appBaseUrl}/api/drivers/$driverId'); // Adjust endpoint if necessary
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        driverIdData.value = Driver.fromJson(json.decode(response.body));
      } else {
        error.value = 'Failed to load driver data';
      }
    } catch (e) {
      error.value = 'An error occurred: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  // Fetch order status data
  Future<void> fetchOrderStatus(String orderId) async {
    String accessToken =  box.read('token');
    _isLoading.value = true;
    error.value = '';

    try {
      var url = Uri.parse('${Environment.appBaseUrl}/api/orders/$orderId/status'); // Adjust endpoint if necessary
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _orderStatus.value = data['orderStatus'] ?? ''; // assuming response has an 'orderStatus' field
        print("The order status! ${_orderStatus.value}");
      } else {
        error.value = 'Failed to load order status';
      }
    } catch (e) {
      error.value = 'An error occurred: $e';
    } finally {
      _isLoading.value = false;
    }
  }
}
