import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/client_orders.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchClientOrders(String query, String paymentStatus) {
  final box = GetStorage();
  final orders = useState<List<ClientOrders>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Mounted flag
  final mounted = useIsMounted();

  // Fetch Data Function
  Future<void> fetchData() async {
    if (!mounted()) return;  // Ensure the hook is mounted before starting

    String token = box.read('token');
    String accessToken = jsonDecode(token);
    isLoading.value = true;

    try {
      Uri url = Uri.parse('${Environment.appBaseUrl}/api/orders?$query=$paymentStatus');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        if (mounted()) {
          orders.value = clientOrdersFromJson(response.body);
        }
      } else {
        var apiError = apiErrorFromJson(response.body);
        if (mounted()) {
          Get.snackbar(
            apiError.message,
            "Failed to get data, please try again",
            icon: const Icon(Icons.error),
          );
        }
      }
    } catch (e) {
      if (mounted()) {
        Get.snackbar(
          e.toString(),
          "Failed to get data, please try again",
          icon: const Icon(Icons.error),
        );
        error.value = e as Exception?;
      }
    } finally {
      if (mounted()) {
        isLoading.value = false;
      }
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, [query, paymentStatus]); // Re-run when query or paymentStatus changes

  // Refetch Function
  void refetch() {
    if (mounted()) {
      isLoading.value = true;
      fetchData();
    }
  }

  // Return values
  return FetchHook(
    data: orders.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
