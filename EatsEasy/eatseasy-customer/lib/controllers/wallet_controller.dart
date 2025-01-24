import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/environment.dart';
import '../models/login_response.dart';
import '../models/order_details.dart';
import '../models/wallet_top_up.dart';

class WalletController extends GetxController {
  final box = GetStorage();
  Rx<LoginResponse?> user = Rx<LoginResponse?>(null);

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
    String? userId = box.read('userId');
    final sanitizedUserId = userId?.replaceAll('"', '').trim();
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    var url = Uri.parse('${Environment.appBaseUrl}/api/users/wallet/$sanitizedUserId/topup');
    final body = jsonEncode({
      'amount': amount,
      'paymentMethod': paymentMethod,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        fetchUserDetails();
        handlePaymentSuccess();
        setLoading = false;
      } else {
        handlePaymentFailure();
        print(response.body);
      }
    } catch (e) {
      handlePaymentFailure();
    } finally {
      setLoading = false;
    }
  }
  Future<void> initiatePay(double amount, String paymentMethod) async {
    setLoading = true;
    final userId = box.read("userId");
    var url = Uri.parse('${Environment.appBaseUrl}/api/users/wallet/$userId/withdraw');
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
        fetchUserDetails();
        handlePaymentSuccess();
        setLoading = false;
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
    final userId = box.read("userId");
    var url = Uri.parse('${Environment.appBaseUrl}/api/users/wallet/$userId/withdraw');
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
        fetchUserDetails();
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

  void paymentFunction(double amount, String paymentMethod,  UserWallet newTransaction) async {
    setLoading = true; // Start loading state
    var url = Uri.parse('${Environment.paymentUrl}/stripe/topup-wallet');

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
        print(paymentUrl);
        setLoading = false;
      } else {
        print("Error: ${response.statusCode} - ${response.body}"); // Log the error response
      }
    } catch (e) {
      print("Failed to make the request: $e"); // Log the exception
    } finally {
      setLoading = false; // Ensure loading state is stopped
    }
  }

  /*Future<void> fetchUserDetails() async {
    setLoading = true;
    final userId = box.read("userId");
    final sanitizedUserId = userId?.replaceAll('"', '').trim();
    String token = box.read('token') ?? '';
    var url = Uri.parse('${Environment.appBaseUrl}/api/users/byId/$sanitizedUserId');

    print(sanitizedUserId);
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var data = jsonDecode(response.body);
    user.value = LoginResponse.fromJson(data);
  }*/

  Future<void> fetchUserDetails() async {
    setLoading = true;
    final userId = box.read("userId");
    final sanitizedUserId = userId?.replaceAll('"', '').trim();
    String token = box.read('token') ?? '';
    var url = Uri.parse('${Environment.appBaseUrl}/api/users/byId/$sanitizedUserId');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        setLoading = false;
        var data = jsonDecode(response.body);
        print(response.body);
        user.value = LoginResponse.fromJson(data);

      } else {
        setLoading = false;
        print(response.body);
        Get.snackbar(
          "Error",
          "Failed to load driver details.",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error),
        );
      }
    } catch (e) {
      Get.snackbar(
        e.toString(),
        "An error occurred while fetching driver data.",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error),
      );
    } finally {
      setLoading = false;
    }
  }

  void handlePaymentSuccess() {
    paymentUrl = '';
    Get.snackbar(
      "Top-up Successful",
      "Your wallet has been credited.",
      colorText: kDark,
      backgroundColor: kOffWhite,
      icon: const Icon(Icons.check_circle),
    );
  }

  void handlePaymentFailure() {
    paymentUrl = '';
    Get.snackbar(
      "Payment Cancelled",
      "Top-up was not completed.",
      colorText: kDark,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error),
    );
  }
}
