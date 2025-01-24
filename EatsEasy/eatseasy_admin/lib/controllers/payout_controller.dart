import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PayoutController extends GetxController {
  Function? refecthList;
  RxMap<String, dynamic> restaurantStats = RxMap<String, dynamic>({});

  void setData(Function getList) {
    refecthList = getList;
  }

  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  Future<void> getRestaurantWithdrawalsStats(String restaurantId) async {
    setLoading = true;

    String accessToken = box.read('token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    var url = Uri.parse('$appBaseUrl/api/payouts/$restaurantId/withdrawals-stats');


    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        setLoading = false;
        // Parse the response body
        var data = json.decode(response.body);

        // Store the fetched data
        restaurantStats.value = data['data'];

        // You can add additional logic here to update your UI or do other actions

        /*// Show a success message if necessary
        Get.snackbar("Stats Retrieved", "Successfully fetched withdrawal stats!",
            colorText: kDark,
            backgroundColor: kOffWhite,
            icon: const Icon(Ionicons.fast_food_outline));*/
      } else {
        setLoading = false;
        Get.snackbar("Error", "Failed to fetch withdrawal stats.",
            colorText: kDark,
            backgroundColor: kOffWhite,
            icon: const Icon(Ionicons.warning_outline));
      }
    } catch (e) {
      setLoading = false;
      debugPrint(e.toString());
      Get.snackbar("Error", "An error occurred while fetching stats.",
          colorText: kDark,
          backgroundColor: kOffWhite,
          icon: const Icon(Ionicons.warning_outline));
    }
  }

  void updateStatus(String id, String query, Function refetch) async {
    setLoading = true;

    String accessToken = box.read('token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    var url = Uri.parse('$appBaseUrl/api/payouts?id=$id&status=$query');
    try {
      final response = await http.put(url, headers: headers);


      if (response.statusCode == 200) {
        setLoading = false;
        refetch();

        Get.snackbar("Status Updated", "Enjoy your awesome experience",
            colorText: kDark,
            backgroundColor: kOffWhite,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.to(() => const HomePage());
      } else if (response.statusCode == 404) {
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
