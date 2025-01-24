import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:eatseasy/models/order_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchOrder(String id) {
  final order = useState<GetOrder?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('${Environment.appBaseUrl}/api/orders/$id');

      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        order.value = getOrderFromJson(response.body);
      } else {
        var error = apiErrorFromJson(response.body);
        Get.snackbar(error.message, "Failed to get data, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      Get.snackbar(e.toString(), "Failed to get data, please try again",
          icon: const Icon(Icons.error));
      // error.value = e as Exception?;
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: order.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );

}
