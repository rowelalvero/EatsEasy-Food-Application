// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/search_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RestaurantSearchController extends GetxController {
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) {
    _isLoading.value = value;
  }

  RxBool _isTriggered = false.obs;
  bool get isTriggered => _isTriggered.value;
  set setTrigger(bool value) {
    _isTriggered.value = value;
  }

  List<SearchModel>? searchResults;
  ApiError? apiError;

  void searchRestaurants(String key) async {
    setLoading = true;

    Uri url = Uri.parse("$appBaseUrl/api/restaurants/search/$key");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        searchResults = searchModelFromJson(response.body);
        setLoading = false;
      } else {
        setLoading = false;
        apiError = apiErrorFromJson(response.body);
      }
    } catch (e) {
      setLoading = false;
      debugPrint(e.toString());
    }
  }
}
