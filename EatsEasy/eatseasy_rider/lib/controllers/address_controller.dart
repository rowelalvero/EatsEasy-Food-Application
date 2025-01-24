
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/models/api_error.dart';
import 'package:eatseasy_rider/models/driver_address_model.dart';
import 'package:eatseasy_rider/views/entrypoint.dart';
import 'package:eatseasy_rider/views/profile/driver_addresses.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
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
    String accessToken = token;//jsonDecode(token);
    print("your token $accessToken");
    setLoading = true;
    var url = Uri.parse('${appBaseUrl}/api/address');

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
        setLoading = false;

        Get.snackbar("Address successfully add",
            "Thank you for adding the address, you can now order food",
            icon: const Icon(Icons.add_alert));

        Get.off(() =>   MainScreen());
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

  void setDefaultAddress(String id) async {

    String token = box.read('token');
    String accessToken = token;

    setLoading = true;
    var url = Uri.parse('$appBaseUrl/api/address/default/$id');

    try {
      var response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;

        Get.snackbar("Default Address successfully updated",
            "Thank you for updating the address, you can now order food",
            icon: const Icon(Icons.add_alert));

        Get.off(() =>  const Addresses());
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

  var _index = 0.obs;
  // Getter
  int get getIndex => _index.value;

  // Setter
  set setIndex(int newValue) {
    _index.value = newValue;
  }

  var _dfSwitch = false;

  // Getter
  bool get dfSwitch => _dfSwitch;

  // Setter
  set setDfSwitch(bool newValue) {
    _dfSwitch = newValue;
  }

}
