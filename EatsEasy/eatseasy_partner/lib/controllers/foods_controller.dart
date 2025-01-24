// ignore_for_file: unnecessary_getters_setters, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/models/api_error.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/models/foods.dart';
import 'package:eatseasy_partner/models/sucess_model.dart';
import 'package:eatseasy_partner/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/foods_request.dart';

class FoodsController extends GetxController {
  final box = GetStorage();

  var currentPage = 0.obs;

  void updatePage(int index) {
    currentPage.value = index;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  final RxInt _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  set setTabIndex(int newValue) {
    _tabIndex.value = newValue; // Update the reactive value
    // update(); // This is optional, as .value already triggers updates
  }

  RxList<Additive> _additives = <Additive>[].obs;
  List<Additive> get additives => _additives;
  set setAdditives(Additive newValue) {
    _additives.add(newValue);
  }

  RxList<String> _tags = <String>[].obs;
  List<String> get tags => _tags;
  set setTags(String newValue) {
    _tags.add(newValue);
  }

  RxList<String> _type = <String>[].obs;
  List<String> get type => _type;
  set setType(String newValue) {
    _type.add(newValue);
  }

  int generateRandomNumber() {
    int min = 10;
    int max = 10000;
    final _random = Random();
    return min + _random.nextInt(max - min + 1);
  }

  //Create category getter and setter of type string
  String _category = '';
  String get category => _category;
  set category(String newValue) {
    _category = newValue;
  }

  RxList<CustomAdditives> _customAdditives = <CustomAdditives>[].obs;
  List<CustomAdditives> get customAdditives => _customAdditives;
  set addQuestion(CustomAdditives newQuestion) {
    _customAdditives.add(newQuestion);
  }

  Future<void> addFood(String foodItem) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    Uri url = Uri.parse('${Environment.appBaseUrl}/api/foods');

    try {
      print("Food Item JSON: $foodItem");
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: foodItem,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;
        Get.snackbar(data.message, "Product successfully added.",
            icon: const Icon(Icons.add_alert));
        Get.offAll(() => const HomePage(),);
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to add product, please try again.",
           icon: const Icon(Icons.error));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add product, please try again.",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  // Refactored method to update a food item along with questions
  Future<void> updateFood(String foodId, String updatedFood) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;
    Uri url = Uri.parse('${Environment.appBaseUrl}/api/foods/$foodId');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: updatedFood,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
        setLoading = false;
        Get.snackbar("Success", "Food item successfully updated.");
        Get.offAll(() => const HomePage(),);
      } else {
        Get.snackbar("Error", "Failed to update food item, please try again.", icon: const Icon(Icons.error));
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred, please try again later.",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  Future<void> deleteFood(String foodId) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    Uri url = Uri.parse('${Environment.appBaseUrl}/api/foods/$foodId');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Food item successfully deleted.", icon: const Icon(Icons.delete));
        // Optionally, refresh the food list or navigate to another screen
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to delete food item, please try again.", icon: const Icon(Icons.error));
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred, please try again later.", icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

}
