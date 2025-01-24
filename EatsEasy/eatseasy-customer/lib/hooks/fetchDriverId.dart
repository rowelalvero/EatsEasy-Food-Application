import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../models/api_error.dart';
import '../models/environment.dart';
import '../models/hook_models/hook_result.dart';
import '../models/order_details.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchDriverId(String orderId) {
  final driverId = useState<Driver?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  Future<void> fetchDriverData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${Environment.appBaseUrl}/api/orders/$orderId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Extract only driverId-related data
        driverId.value = Driver.fromJson(jsonData['driverId']);
      } else {
        var apiError = apiErrorFromJson(response.body);
        Get.snackbar(apiError.message, "Failed to get data, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      Get.snackbar(e.toString(), "Failed to get data, please try again",
          icon: const Icon(Icons.error));
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchDriverData();
    return;
  }, [orderId]);

  return FetchHook(
    data: driverId.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: fetchDriverData,
  );
}
