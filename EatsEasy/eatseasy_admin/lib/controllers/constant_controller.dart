import 'dart:convert';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/constant.dart';

class ConstantController extends GetxController {
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;
  Rx<Constant> constants = Constant(commissionRate: 10.0, driverBaseRate: 20.0).obs;  // Default values

  final box = GetStorage();

  // Method to fetch the constants from the backend
  Future<void> getConstants() async {
    setLoading = true;

    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse('$appBaseUrl/api/constants'), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        constants.value = Constant.fromJson(data);
        setLoading = false;
      } else {
        Get.snackbar("Error", "Failed to fetch constants", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching constants", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setLoading = false;
    }
  }

  // Method to update the constants on the backend
  Future<void> updateConstants({required double commissionRate, required double driverBaseRate}) async {
    setLoading = true;

    String accessToken = box.read('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    var body = json.encode({
      'commissionRate': commissionRate,
      'driverBaseRate': driverBaseRate,
    });

    try {
      final response = await http.put(
        Uri.parse('$appBaseUrl/api/constants'), // Assuming API endpoint for update is `/api/constants`
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        constants.value = Constant.fromJson(data);
        setLoading = false;
        Get.snackbar("Success", "Constants updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Failed to update constants", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while updating constants", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setLoading = false;
    }
  }
}
