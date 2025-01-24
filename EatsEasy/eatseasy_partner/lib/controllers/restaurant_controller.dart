import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/models/api_error.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/models/restaurant_response.dart';
import 'package:eatseasy_partner/models/status.dart';
import 'package:eatseasy_partner/models/sucess_model.dart';
import 'package:eatseasy_partner/views/auth/login_page.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'login_controller.dart';

class RestaurantController extends GetxController {
  final box = GetStorage();
  RestaurantResponse? restaurant;

  RxBool _isAvailable = false.obs;
  bool get isAvailable => _isAvailable.value;
  set setAvailability(bool newValue) {
    _isAvailable.value = newValue;
  }

  RxBool _status = false.obs;
  bool get status => _status.value;
  set setStatus(bool newValue) {
    _status.value = newValue;
    refetch.value = newValue;
  }

  var refetch = false.obs;

  // Function to be called when status changes
  Function? onStatusChange;

  @override
  void onInit() {
    super.onInit();
    // Set up the listener
    ever(refetch, (_) async {
      if (refetch.isTrue && onStatusChange != null) {
        await Future.delayed(const Duration(seconds: 5));
        onStatusChange!();
      }
    });
  }

  void setOnStatusChangeCallback(Function callback) {
    onStatusChange = callback;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void updateRestaurant(String model, String? restaurantId) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    print(model);
    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/updateRestaurant/$restaurantId'); // Update endpoint

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: model,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        await getRestaurant(accessToken);
        setLoading = false;
        Get.snackbar("Update complete!",
            "Restaurant details have been successfully updated.",
            icon: const Icon(Icons.add_alert));
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to update, please try again.",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;
      Get.snackbar(e.toString(), "Failed to update, please try again.",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  Future<void> getRestaurant(String token) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/profile');
    setLoading = true;
    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        RestaurantResponse restaurant =
        restaurantResponseFromJson(response.body);
        restaurant = restaurant;
        box.write("restaurantId", restaurant.id);
        box.write("verification", restaurant.verification);
        box.write(restaurant.id, json.encode(restaurant));
        setLoading = false;
        restaurant = getRestaurantData(restaurant.id)!;

      } else {
        var error = apiErrorFromJson(response.body);
        Get.snackbar("Opps Error ", error.message,
            icon: const Icon(Ionicons.fast_food_outline));

      }
    } catch (e) {
      Get.snackbar(e.toString(), "Failed to login, please try again",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }

  }

  RestaurantResponse? getRestaurantData(String restaurantId) {
    String? data = box.read(restaurantId);
    if (data != null) {
      return restaurantResponseFromJson(data);
    }
    return null;
  }

  void restaurantRegistration(String model) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: model,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;
        Get.snackbar("Register complete!",
            "Wait 3-5 business days for approval. You will receive an email once your verification is complete.",
            icon: const Icon(Icons.add_alert));

        Get.offAll(() => const Login());
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to login, please try again.",
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

  void restaurantStatus() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? restaurantId = box.read('restaurantId');
    if(restaurantId==null){
      print("I am null...................");
    }
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/$restaurantId');
    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Status data = statusFromJson(response.body);
        box.write("status", data.isAvailable);
        setStatus = data.isAvailable;
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to toggle status, please try again.",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
