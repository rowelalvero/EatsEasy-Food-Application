import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/order_controller.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/models/hook_models/hook_result.dart';
import 'package:eatseasy_partner/models/ready_orders.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchClientOrders() {
  final controller = Get.put(OrdersController());
  final box = GetStorage();
  final orders = useState<List<ReadyOrders>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    final token = box.read('token');
    final String accessToken = token != null ? jsonDecode(token) : '';

    if (accessToken.isEmpty) {
      print("Access token is missing");
      Get.snackbar("Connection Error", "Check your internet connection.",
          icon: const Icon(Icons.error));
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse('${Environment.appBaseUrl}/api/orders/delivery/Ready');
      print("Fetching data from $url with token $accessToken");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          print("Parsing JSON...");
          final parsedOrders = readyOrdersFromJson(response.body);
          orders.value = parsedOrders;
          controller.setCount = parsedOrders.length;
          print("Orders parsed successfully: ${parsedOrders.length} orders");
        } catch (e) {
          print("Error deserializing JSON: $e");
          Get.snackbar("Connection error", "Check your internet connection.",
              icon: const Icon(Icons.error));
        }
      } else {
        print("Error: ${response.statusCode} ${response.body}");
        error.value = Exception('Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print("Fetch error: $e");
      Get.snackbar("Connection Error", "Check your internet connection.",
          icon: const Icon(Icons.error));
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
      print("Fetch data completed.");
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: orders.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
