// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/all_addresses.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/views/entrypoint.dart';
import 'package:eatseasy/views/profile/saved_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AddressController extends GetxController {
  final box = GetStorage();
  AddressesList? defaultAddress;
  Location? userLoc;
  String? userAddress;

  // Reactive state
  var _address = false.obs;
  // Getter
  bool get address => _address.value;
  // Setter
  set setAddress(bool newValue) {
    _address.value = newValue;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void addAddress(String address) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: address,
      );

      if (response.statusCode == 201) {


        Get.snackbar("Address successfully added",
            "Please reload this page",
            icon: const Icon(Icons.add_alert));

        setLoading = false;
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

  Future<void> setDefaultAddress(String id) async {
    
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address/default/$id');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {

        Get.snackbar("Address successfully updated",
            "Please reload this page",
            icon: const Icon(Icons.add_alert));
        setLoading = false;

        //Get.off(() =>  const SavedPlaces());
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to update address, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to update address, please try again",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  Future<void> deleteAddress(String id) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address/$id');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {

        Get.snackbar("Address deleted",
            "Address has been successfully deleted.",
            icon: const Icon(Icons.delete));

        setLoading = false;
        //Get.off(() => const SavedPlaces());
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to delete address. Try again.",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to delete address. Try again.",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void updateAddress(String id, String updatedAddress) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/address/$id');

    try {
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: updatedAddress,
      );

      if (response.statusCode == 200) {

        Get.snackbar("Address Updated",
            "Address has been successfully saved.",
            icon: const Icon(Icons.update));

        setLoading = false;
        //Get.off(() => const SavedPlaces());
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to update address. Try again.",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to update address. Try again.",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  var _index = 0.obs;
  int get getIndex => _index.value;
  set setIndex(int newValue) {
    _index.value = newValue;
  }
  
  var _dfSwitch = false;
  bool get dfSwitch => _dfSwitch;
  set setDfSwitch(bool newValue) {
    _dfSwitch = newValue;
  }
  
}
