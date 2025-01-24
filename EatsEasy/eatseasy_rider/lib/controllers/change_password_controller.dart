import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/api_error.dart';
import '../views/auth/login_page.dart';

class ChangePasswordController extends GetxController {
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

  var _email = ''.obs;
  String get email => _email.value;
  set email(String newValue) {
    _email.value = newValue;
  }

  Future<void> findUserByEmail(String email) async {
    setLoading = true;

    final url = Uri.parse('$appBaseUrl/api/users/find-user-by-email');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        print('User found: $responseBody');
        Get.snackbar("Success", "User found: ${responseBody['user']['email']}");
      } else if (response.statusCode == 404) {
        print('User not found');
        Get.snackbar("Error", "User not found.");
      } else {
        print('Failed to find user. Status code: ${response.statusCode}');
        Get.snackbar("Error", "Failed to find user. Try again.");
      }
    } catch (error) {
      print('Error: $error');
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      setLoading = false;
    }
  }

  Future<void> verifyEmail({final Function()? next, final Function()? back}) async {
    setLoading = true;

    var url = Uri.parse('$appBaseUrl/api/users/verifyEmail/$code/$email');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        setLoading = false;
        Get.snackbar("Yey! Account verified!",
            "Enjoy your awesome experience.",
            colorText: kDark,
            icon: const Icon(Ionicons.fast_food_outline));
        if (next != null) {
          next();
        } else {
          Get.offAll(() => const Login());
        }
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to verify, please try again.",
            backgroundColor: kRed,
            colorText: kLightWhite,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again.",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  Future<void> changePassword(String model, String userEmail) async {
    setLoading = true;

    final url = Uri.parse('$appBaseUrl/api/users/changePassword/$userEmail');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        print('Password updated successfully: $responseBody');
        Get.snackbar("Success", "Password updated successfully.");
        setLoading = false;
        Get.offAll(() => const Login());
      } else {
        print('Failed to change password. Status code: ${response.statusCode}');
        Get.snackbar("Error", "Failed to change password. Try again.");
      }
    } catch (error) {
      print('Error: $error');
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      setLoading = false;
    }
  }
}
