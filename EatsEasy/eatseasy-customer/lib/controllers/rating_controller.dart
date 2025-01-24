import 'dart:convert';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/sucess_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class RatingController extends GetxController {
  final box = GetStorage();
  double rating = 0.0;

  void updateRating(double value) {
    rating = value;
    update();
  }
  double foodRating = 0.0;
  void updateFood(double value) {
    foodRating = value;
    update();
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void  addRating(String rating, Function refetch) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/rating');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: rating,
      );

      if (response.statusCode == 200) {
        setLoading = false;
        SuccessResponse success = successResponseFromJson(response.body);

        Get.snackbar(
          'Success',
          success.message,
          duration: const Duration(seconds: 2),
        );
        refetch();
      }
    } catch (e) {
      setLoading = false;
    } finally {
      setLoading = false;
    }
  }
}
