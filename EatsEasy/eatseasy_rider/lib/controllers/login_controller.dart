import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/main.dart';
import 'package:eatseasy_rider/models/api_error.dart';
import 'package:eatseasy_rider/models/driver_response.dart';
import 'package:eatseasy_rider/models/login_response.dart';
import 'package:eatseasy_rider/views/auth/driver_registration.dart';
import 'package:eatseasy_rider/views/auth/login_page.dart';
import 'package:eatseasy_rider/views/auth/waiting_page.dart';
import 'package:eatseasy_rider/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../views/auth/verification_page.dart';
import 'notifications_controller.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  final controller = Get.put(NotificationsController());
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void loginFunc(String model) async {
    setLoading = true;

    var url = Uri.parse('$appBaseUrl/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );

      print(response.body);

      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = json.encode(data);
        print("getting data ${userData}");
        box.write(userId, userData);
        box.write("userClientId", userData);
        box.write("token", data.userToken);
        box.write("userId", data.id);
        box.write("phone", data.phone);
        box.write("email", data.email);
        box.write("username", data.username);
        controller.updateUserToken(controller.fcmToken);

        print("${controller.fcmToken} updated successfully");
        if (data.userType == "Driver") {
          getDriver(data.userToken);
        } else if (data.verification == false) {
          Get.offAll(() => const VerificationPage());
        } else {
          Get.snackbar("Login error",
              "You are not a driver, please register as a driver",
              icon: const Icon(Ionicons.fast_food_outline));

          defaultHome = const Login();
          Get.to(() => const DriverRegistration());
        }

        setLoading = false;

        Get.snackbar("Welcome!", "Successful login",
            icon: const Icon(Ionicons.fast_food_outline));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      print(e);
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void logout() {
    box.erase();
    defaultHome = const Login();
    Get.offAll(() => defaultHome);
  }

  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    String? data = box.read(userId.toString());
    if (data != null) {
      return loginResponseFromJson(data);
    }
    return null;
  }

  void getDriver(String token) async {
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
        Driver driver = driverFromJson(response.body);
        box.write("driverId", driver.id);
        box.write(driver.id, json.encode(driver));

        box.write("verification", driver.verification);

        if (driver.verification != "Verified") {
          Get.offAll(() => const WaitingPage());
        } else {
          Get.to(() => MainScreen());
        }
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar("Opps Error ", error.message,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.offAll(() => MainScreen());
      }
    } catch (e) {
      Get.snackbar(e.toString(), "Failed to login, please try again",
          icon: const Icon(Icons.error));
    }
  }

  Driver? getDriverData() {
    String? driverId = box.read("driverId");
    String? data = box.read(driverId!);
    if (data != null) {
      return driverFromJson(data);
    }
    return null;
  }
}
