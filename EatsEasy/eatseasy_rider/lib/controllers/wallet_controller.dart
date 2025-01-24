import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/driver_response.dart';
import '../models/wallet_top_up.dart';
import '../views/profile/payment.dart';

class WalletController extends GetxController {
  final box = GetStorage();
  Rx<Driver?> driver = Rx<Driver?>(null);

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  RxString _paymentUrl = ''.obs;
  String get paymentUrl => _paymentUrl.value;
  set paymentUrl(String newValue) {
    _paymentUrl.value = newValue;
  }

  Future<void> initiateTopUp(double amount, String paymentMethod) async {
    setLoading = true;
    String? driverId = box.read('driverId');
    var url = Uri.parse('$appBaseUrl/api/driver/wallet/$driverId/topup');
    String token = box.read('token') ?? '';

    final body = jsonEncode({
      'amount': amount,
      'paymentMethod': paymentMethod,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        fetchDriverDetails();
        handlePaymentSuccess();
      } else {
        print(response.body);
        handlePaymentFailure();
      }
    } catch (e) {
      print(e.toString());
      handlePaymentFailure();
    } finally {
      setLoading = false;
    }
  }
  Future<void> initiatePay(double amount, String paymentMethod) async {
    setLoading = true;
    String? driverId = box.read('driverId');
    var url = Uri.parse('$appBaseUrl/api/driver/wallet/$driverId/withdraw');
    String token = box.read('token') ?? '';

    final body = jsonEncode({
      'amount': amount,
      'paymentMethod': paymentMethod,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        fetchDriverDetails();
        handlePaymentSuccess();
      } else {
        handlePaymentFailure();
      }
    } catch (e) {
      handlePaymentFailure();
    } finally {
      setLoading = false;
    }
  }
  Future<void> initiateWithdraw(double amount, String paymentMethod) async {
    setLoading = true;
    String? driverId = box.read('driverId');
    var url = Uri.parse('$appBaseUrl/api/driver/wallet/$driverId/withdraw');
    String token = box.read('token') ?? '';

    final body = jsonEncode({
      'amount': amount,
      'paymentMethod': paymentMethod,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        fetchDriverDetails();
        handlePaymentSuccess();
      } else {
        handlePaymentFailure();
      }
    } catch (e) {
      handlePaymentFailure();
    } finally {
      setLoading = false;
    }
  }

  void paymentFunction(double amount, String paymentMethod,  DriverWallet newTransaction) async {
    setLoading = true; // Start loading state
    var url = Uri.parse('$paymentsUrl/stripe/topup-wallet');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: driverWallerToJson(newTransaction),
      );

      if (response.statusCode == 200) {
        var urlData = jsonDecode(response.body);
        paymentUrl = urlData['url'];
      } else {
        print("Error: ${response.statusCode} - ${response.body}"); // Log the error response
      }
    } catch (e) {
      print("Failed to make the request: $e"); // Log the exception
    } finally {
      setLoading = false; // Ensure loading state is stopped
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
        driver.value = Driver.fromJson(data);
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

  /*void updateDriverAvailability(bool availability) async {
    setLoading = true;
    String? driverId = box.read('driverId');
    String token = box.read('token') ?? '';
    var url = Uri.parse('$appBaseUrl/api/driver/$driverId/availability');

    final body = jsonEncode({'isAvailable': availability});

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        driver.value = driver.value?.copyWith(isAvailable: availability);
        Get.snackbar(
          "Success",
          "Availability updated.",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_circle),
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to update availability.",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while updating availability.",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error),
      );
    } finally {
      setLoading = false;
    }
  }*/

  void handlePaymentSuccess() {
    paymentUrl = '';
    Get.snackbar(
      "Top-up Successful",
      "Your wallet has been credited.",
      icon: const Icon(Icons.check_circle),
    );
  }

  void handlePaymentFailure() {
    paymentUrl = '';
    Get.snackbar(
      "Payment Cancelled",
      "Top-up was not completed.",
      icon: const Icon(Icons.error),
    );
  }
}
