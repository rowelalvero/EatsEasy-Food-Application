// ignore_for_file: unused_local_variable

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/location_controller.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchCategory(String selectedCategory, String code) {
  final location = Get.put(UserLocationController());

  final categoryItems = useState<List<Food>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    error.value = null;  // Reset error before fetching

    try {
      Uri url = Uri.parse(
          '${Environment.appBaseUrl}/api/foods/categories/$selectedCategory/$code');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        categoryItems.value = foodFromJson(response.body);
      } else {
        final apiError = apiErrorFromJson(response.body);
        error.value = Exception(apiError.message);
      }
    } catch (e) {
      error.value = Exception('Failed to fetch data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, [location.postalCode, selectedCategory]);

  // Refetch Function
  void refetch() {
    fetchData();
  }

  // Return values
  return FetchHook(
    data: categoryItems.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
