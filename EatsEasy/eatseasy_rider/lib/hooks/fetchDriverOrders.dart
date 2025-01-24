import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/models/hook_models/hook_result.dart';
import 'package:eatseasy_rider/models/ready_orders.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
// Custom Hook
FetchHook useFetchPicked(String query) {
  final box = GetStorage();
  final orders = useState<List<ReadyOrders>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final isMounted = useIsMounted(); // Check if the widget is still mounted

  // Fetch Data Function
  Future<void> fetchData() async {
    String accessToken = box.read('token');
    String driver = box.read('driverId');

    if (!isMounted()) return; // Check if widget is still mounted
    isLoading.value = true;

    try {
      Uri url = Uri.parse('$appBaseUrl/api/orders/picked/$query/$driver');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        if (isMounted()) {
          orders.value = readyOrdersFromJson(response.body); // Only update if still mounted
        }
      }
    } catch (error) {
      if (isMounted()) {
        Get.snackbar(
          error.toString(),
          "Failed to get data, please try again",
          icon: const Icon(Icons.error),
        );
      }
    } finally {
      if (isMounted()) {
        isLoading.value = false; // Only update if still mounted
      }
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
