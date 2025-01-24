// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/common/address_modal.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/address_controller.dart';
import 'package:eatseasy/models/all_addresses.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchDefault(BuildContext context, bool trigger) {
  final box = GetStorage();
  final controller = Get.put(AddressController());
  final address = useState<AddressesList?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  String? token = box.read('token');
  String accessToken = "";

  if (token != null) {
    accessToken = jsonDecode(token);
  }

  // Fetch Data Function
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${Environment.appBaseUrl}/api/address/default'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        box.write("default_address", true);

        address.value = AddressesList.fromJson(data);
        AddressesList ad = AddressesList.fromJson(data);
        controller.defaultAddress = address.value;

        controller.userAddress = ad.addressLine1;
      }
      if (response.statusCode != 200) {
        print('Failed to load data from backend. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      box.write("default_address", false);
      if (trigger == true) {
        showAddressSheet(context);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    if (token == null) {
      return null;
    } else {
      fetchData();
    }
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: address.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
