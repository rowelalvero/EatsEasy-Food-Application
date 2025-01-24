// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/api_error.dart';

class AddCategoryController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  void addCategory(String data) async {
    setLoading = true;

    String accessToken = box.read('token');
    var url = Uri.parse('$appBaseUrl/api/category');
    try {
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: data
      );

      if (response.statusCode == 201) {
        Get.snackbar("Category added", "Category created successfully",
            colorText: kDark,
            backgroundColor: kOffWhite,
            icon: const Icon(Ionicons.fast_food_outline));
        setLoading = false;
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to add address, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Delete category method
  Future<void> deleteCategory(String id) async {
    setLoading = true;
    String accessToken = box.read('token');
    var url = Uri.parse('$appBaseUrl/api/category/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Category Deleted", "Category removed successfully",
            colorText: kDark,
            backgroundColor: kOffWhite,
            icon: const Icon(Icons.delete_outline));
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to delete category",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint("Delete error: $e");
    } finally {
      setLoading = false;
    }
  }

  // Update category method
  Future<void> updateCategory(String id, String title, String imageUrl) async {
    setLoading = true;
    String accessToken = box.read('token');
    var url = Uri.parse('$appBaseUrl/api/category/$id');
    var data = jsonEncode({
      'title': title,
      'value': title.toLowerCase(),
      'imageUrl': imageUrl,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Category Updated", "Category updated successfully",
            colorText: kDark,
            backgroundColor: kOffWhite,
            icon: const Icon(Icons.update));
      } else {
        var data = apiErrorFromJson(response.body);
        Get.snackbar(data.message, "Failed to update category",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      debugPrint("Update error: $e");
    } finally {
      setLoading = false;
    }
  }
}
