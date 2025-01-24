// ignore_for_file: prefer_final_fields
import 'dart:convert';

import 'package:eatseasy_partner/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../entrypoint.dart';
import '../models/api_error.dart';
import '../models/environment.dart';
import '../models/phone_verification.dart';
import '../views/auth/restaurant_registration.dart';

class PhoneVerificationController extends GetxController {
  final box = GetStorage();

  var _code = '🇩🇪 63'.obs;
  String get code => _code.value;
  set code(String newValue) {
    _code.value = newValue;
  }

  var _phoneCode = '+63'.obs;
  String get phoneCode => _phoneCode.value;
  set phoneCode(String newValue) {
    _phoneCode.value = newValue;
  }

  var _phoneNumber = '+63'.obs;
  String get phoneNumber => _phoneNumber.value;
  set phoneNumber(String newValue) {
    _phoneNumber.value = newValue;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  Future<void> verifyPhone() async {
    String token = box.read('token');

    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users/verify_phone/$phoneNumber');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        PhoneVerificationData data = phoneVerificationDataFromJson(response.body);

        box.write("phone_verification", data.phoneVerification);

        setLoading = false;
        phoneNumber = '';
        Get.snackbar("Successfully verified your phone number ",
            "Enjoy your awesome experience",
            icon: const Icon(Ionicons.fast_food_outline));
        if (data.phoneVerification == true) {
          Get.to(() => const HomePage());
        } else {
          Get.to(() => const RestaurantRegistration());
        }
      }  else {
        var data = apiErrorFromJson(response.body);

        phoneNumber = '';
        Get.snackbar(data.message, "Failed to verify, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;
      phoneNumber = '';
      Get.snackbar(e.toString(), "Failed to login, please try again",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
