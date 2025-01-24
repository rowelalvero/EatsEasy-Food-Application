  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:eatseasy/models/api_error.dart';
  import 'package:eatseasy/models/cart_response.dart';
  import 'package:eatseasy/models/environment.dart';
  import 'package:eatseasy/views/entrypoint.dart';
  import 'package:get/get.dart';
  import 'package:get_storage/get_storage.dart';
  import 'package:http/http.dart' as http;

  import '../constants/constants.dart';

  class CartController extends GetxController {
    final box = GetStorage();
    final RxBool _isSnackbarVisible = false.obs;
    bool get isSnackbarVisible => _isSnackbarVisible.value;
    set isSnackbarVisible(bool value) => _isSnackbarVisible.value = value;


    final _address = false.obs;
    bool get address => _address.value;
    set setAddress(bool newValue) {
      _address.value = newValue;
    }

    final RxBool _isLoading = false.obs;
    bool get isLoading => _isLoading.value;
    set setLoading(bool newValue) {
      _isLoading.value = newValue;
    }

    Future<void> addToCart(String item) async {
      String token = box.read('token');
      String accessToken = jsonDecode(token);

      setLoading = true;
      var url = Uri.parse('${Environment.appBaseUrl}/api/cart');

      try {
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: item,
        );

        if (response.statusCode == 201) {

          CartResponse data = cartResponseFromJson(response.body);

          box.write("cart", jsonEncode(data.count));

          Get.snackbar("Product added successfully to cart",
              "You can now order multiple items via the cart",
              icon: const Icon(Icons.add_alert));

        } else {
          var data = apiErrorFromJson(response.body);

          Get.snackbar(data.message, "Failed to add address, please try again",
              icon: const Icon(Icons.error));
        }
      } catch (e) {
        setLoading = false;
        Get.snackbar(e.toString(), "Failed to add address, please try again",
            icon: const Icon(Icons.error));
      } finally {
        setLoading = false;
      }
    }

    void showSnackbarOnce(String title, String message) {
      if (!isSnackbarVisible) {
        Get.snackbar(title, message, icon: const Icon(Icons.check));
        isSnackbarVisible = true;
        Future.delayed(const Duration(seconds: 2), () {
          isSnackbarVisible = false;
        });
      }
    }


    Future<void> removeFormCart(String itemId, {VoidCallback? refetch}) async {
      String token = box.read('token');
      String accessToken = jsonDecode(token);
      print("Attempting to remove item: $itemId");
      setLoading = true;
      var url = Uri.parse('${Environment.appBaseUrl}/api/cart/delete/$itemId');

      try {
        var response = await http.delete(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            }
        );

        if (response.statusCode == 200) {
          setLoading = false;
          CartResponse data = cartResponseFromJson(response.body);

          box.write("cart", jsonEncode(data.count));
          if (refetch != null) {
            refetch();  // Ensure items is updated here
          }
        } else {
          var data = apiErrorFromJson(response.body);

          Get.snackbar(data.message, "Failed to add address, please try again",
              icon: const Icon(Icons.error));
        }
      } catch (e) {
        setLoading = false;
        Get.snackbar(e.toString(), "Failed to add address, please try again",
            icon: const Icon(Icons.error));
      } finally {
        setLoading = false;
      }
    }


    // Increment product quantity
    Future<void> incrementProductQuantity(String productId, int quantity) async {
      String token = box.read('token');
      String accessToken = jsonDecode(token);

      setLoading = true;
      var url = Uri.parse('${Environment.appBaseUrl}/api/cart/increment');

      try {
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode({"productId": productId, "quantity": quantity}),
        );

        if (response.statusCode == 200) {
          showSnackbarOnce("Success", "Cart item updated successfully");
        } else {
          var data = apiErrorFromJson(response.body);

          Get.snackbar(data.message, "Failed to increment quantity, please try again",
              icon: const Icon(Icons.error));
        }
      } catch (e) {
        Get.snackbar(e.toString(), "Failed to increment quantity, please try again",
            icon: const Icon(Icons.error));
      } finally {
        setLoading = false;
      }
    }

    // Decrement product quantity
    Future<void> decrementProductQuantity(String productId, int quantity) async {
      String token = box.read('token');
      String accessToken = jsonDecode(token);

      setLoading = true;
      var url = Uri.parse('${Environment.appBaseUrl}/api/cart/decrement');

      try {
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode({"productId": productId, "quantity": quantity}),
        );

        if (response.statusCode == 200) {
          showSnackbarOnce("Success", "Cart item updated successfully");
        } else {
          var data = apiErrorFromJson(response.body);

          Get.snackbar(data.message, "Failed to decrement quantity, please try again",
              icon: const Icon(Icons.error));
        }
      } catch (e) {
        Get.snackbar(e.toString(), "Failed to decrement quantity, please try again",
            icon: const Icon(Icons.error));
      } finally {
        setLoading = false;
      }
    }

    // Update custom additives for a food item
    Future<void> updateCustomAdditives(String productId, Map<String, dynamic> customAdditives) async {
      String token = box.read('token');
      String accessToken = jsonDecode(token);
      print(customAdditives);
      print(productId);
      setLoading = true;
      var url = Uri.parse('${Environment.appBaseUrl}/api/cart/updateCustomAdditives/$productId');

      try {
        var response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },

          body: jsonEncode({"customAdditives": customAdditives}),
        );

        print(response.body);
        if (response.statusCode == 200) {
          showSnackbarOnce("Success", "Cart item updated successfully");
        } else {
          var data = apiErrorFromJson(response.body);

          Get.snackbar(data.message, "Failed to update custom additives, please try again",
              icon: const Icon(Icons.error));
        }
      } catch (e) {
        Get.snackbar(e.toString(), "Failed to update custom additives, please try again",
            icon: const Icon(Icons.error));
      } finally {
        setLoading = false;
      }
    }
  }
