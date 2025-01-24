import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchFoodByCategory(String id, String code) {
  final foodList = useState<List<Food>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    error.value = null; // Reset error before fetching

    try {
      Uri url = Uri.parse('${Environment.appBaseUrl}/api/foods/categories/$id/$code');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        foodList.value = foodFromJson(response.body);
      } else {
        final apiError = apiErrorFromJson(response.body);
        error.value = Exception(apiError.message);

        Get.snackbar(
          "Error",
          apiError.message,
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      error.value = Exception('Failed to fetch data: ${e.toString()}');
      Get.snackbar(
        "Error",
        'Failed to fetch data: ${e.toString()}',
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, [id, code]); // Dependency array to refetch data when id or code changes

  // Refetch Function
  void refetch() {
    fetchData();
  }

  // Return values
  return FetchHook(
    data: foodList.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

