// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/entrypoint.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/verification_response.dart';
import 'package:eatseasy_admin/views/auth/verification_page.dart';
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

    var url = Uri.parse('$appBaseUrl/api/users/verify/$code');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        VerificationResponse data = verificationResponseFromJson(response.body);
  
        box.write("verification", data.verification);

        setLoading = false;

        Get.snackbar("Email verification successful",
            "Please login",
            colorText: kLightWhite,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Ionicons.fast_food_outline));
        if (data.verification == false) {
          Get.offAll(() => const VerificationPage());
        } else {
          Get.offAll(() => MainScreen());
        }
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to verify, please try again",
            backgroundColor: kRed,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
