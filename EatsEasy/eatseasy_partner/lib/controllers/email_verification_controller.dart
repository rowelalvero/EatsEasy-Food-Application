// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/models/api_error.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/models/verification_response.dart';
import 'package:eatseasy_partner/views/auth/restaurant_registration.dart';
import 'package:eatseasy_partner/views/auth/verification_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class EmailVerificationController extends GetxController {
  final box = GetStorage();
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  var _code = ''.obs;
  String get code => _code.value;
  set code(String newValue) {
    _code.value = newValue;
  }

  void verifyEmail() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users/verify/$code');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'text/plain',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        VerificationResponse data = verificationResponseFromJson(response.body);
  
        box.write("e-verification", data.verification);

        setLoading = false;

        Get.snackbar("Yey! Account verified!",
            "Enjoy your awesome experience.",
            icon: const Icon(Ionicons.fast_food_outline));
        if (data.verification == false) {
          Get.offAll(() => const VerificationPage());
        } else {
          Get.offAll(() => const RestaurantRegistration());
        }
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to verify, please try again.",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again.",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  Future<void> sendVerificationEmail(email, {final Function()? next}) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users/send-verification-email');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success!",
          "Verification email sent successfully.",
          icon: const Icon(Icons.check_circle_outline),
        );
        if (next != null) {
          next();
        }

      } else {
        var errorData = apiErrorFromJson(response.body);
        Get.snackbar(
          errorData.message,
          "Failed to send verification email. Please try again.",
          icon: const Icon(Icons.error),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while sending verification email. Please try again.",
        icon: const Icon(Icons.error),
      );
    } finally {
      setLoading = false;
    }
  }
}
