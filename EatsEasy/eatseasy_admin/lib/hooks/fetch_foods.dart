import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/food_pagination_controller.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/food_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/foods.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FetchFoods fetchFood(int page, int limit, bool status) {
  final food = useState<List<Food>?>(null);
  final isLoading = useState<bool>(false);
  final currentPage = useState<int>(1);
  final totalPages = useState<int>(1);
  final error = useState<ApiError?>(null);
  final appiError = useState<ApiError?>(null);
  final controller = Get.put(FoodPagesController());

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('');
      if (status == true) {
        url = Uri.parse('$appBaseUrl/api/foods?page=${controller.available}&status=$status');
      } else {
        url = Uri.parse('$appBaseUrl/api/foods?page=${controller.available}&status=$status');
      }
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = foodsFromJson(response.body);

        food.value = data.foods;
        currentPage.value = data.currentPage;
        totalPages.value = data.totalPages;
      } else {
        appiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchFoods(
    foods: food.value,
    isLoading: isLoading.value,
    error: error.value,
    currentPage: currentPage.value,
    totalPages: totalPages.value,
    refetch: refetch,
  );
}
