import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/models/earning_model.dart';
import 'package:eatseasy_rider/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useFetchEarnings() {
  final box = GetStorage();
  final earnings = useState<EarningsData?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  Future<void> fetchData() async {
    String accessToken = box.read('token');
    String driverId = box.read('driverId');
    isLoading.value = true;

    try {
      Uri url = Uri.parse('$appBaseUrl/api/driver/earnings/$driverId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        earnings.value = EarningsData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load earnings');
      }
    } catch (e) {
      error.value = e as Exception;
      Get.snackbar(e.toString(), "Failed to get data, please try again",
          icon: const Icon(Icons.error));
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, const []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: earnings.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}