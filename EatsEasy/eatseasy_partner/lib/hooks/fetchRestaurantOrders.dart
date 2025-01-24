import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/models/hook_models/hook_result.dart';
import 'package:eatseasy_partner/models/ready_orders.dart';
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

  void appSnackBar(String msg) {
    Get.snackbar(msg, "Failed to get data, please try again",
        colorText: kLightWhite,
        backgroundColor: kRed,
        icon: const Icon(Icons.error));
  }

  // Fetch Data Function
  Future<void> fetchData() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? restaurant = box.read('restaurantId');
    isLoading.value = true;
    try {
      Uri url = Uri.parse(
          '${Environment.appBaseUrl}/api/orders/orderslist/$restaurant?status=$query');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        try {
          // Deserialize JSON response to list of ReadyOrders
          final decodedOrders = readyOrdersFromJson(response.body);
          orders.value = decodedOrders;

          if (orders.value == null || orders.value!.isEmpty) {
            //appSnackBar("No orders found");
          } else {
            print("Orders: ${orders.value!.length}");
            isLoading.value = false;
          }
        } catch (e) {
          print("Error deserializing JSON: $e");
          appSnackBar("Error deserializing orders");
        }
      } else {
        // Handle error response
        print("Error: ${response.statusCode} ${response.body}");
        error.value = Exception(response.body);
      }
    } catch (e) {
      appSnackBar("Something went wrong");
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, []);

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
