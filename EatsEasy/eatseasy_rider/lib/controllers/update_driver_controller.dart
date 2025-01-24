import 'dart:convert';
import 'package:eatseasy_rider/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/driver_response.dart';

class DriverEditController extends GetxController {
  final WalletController _walletController = Get.put(WalletController());
  final box = GetStorage();
  Driver? driver;

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  Future<void> updateDriverDetails(String driverId, String driverData) async {
    print(driverData);
    print(driverId);
    String accessToken = box.read('token');
    setLoading = true;
    final apiUrl = '$appBaseUrl/api/driver/$driverId';
    print(accessToken);

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken' // Use if auth is needed
        },
        body: driverData,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await fetchDriverDetails();
        print('Success: ${responseData['message']}');
      } else if (response.statusCode == 404) {
        print('Error: Driver not found');
      } else {
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
      setLoading = false;
    }
  }

  Future<void> fetchDriverDetails() async {
    setLoading = true;
    String? driverId = box.read('driverId');
    String token = box.read('token') ?? '';
    var url = Uri.parse('$appBaseUrl/api/driver');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        driver = Driver.fromJson(data);
      } else {
        Get.snackbar(
          "Error",
          "Failed to load driver details.",
          icon: const Icon(Icons.error),
        );
      }
    } catch (e) {
      Get.snackbar(
        e.toString(),
        "An error occurred while fetching driver data.",
        icon: const Icon(Icons.error),
      );
    } finally {
      setLoading = false;
    }
  }
}


