import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/pagination_controller.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/restaurants_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/restaurants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FetchRestaurants fetchRestaurants(
  String status,
  int page,
  int limit,
) {
  final restaurants = useState<List<Restaurant>?>(null);
  final isLoading = useState<bool>(false);
  final currentPage = useState<int>(1);
  final totalPages = useState<int>(0);
  final error = useState<ApiError?>(null);
  final appiError = useState<ApiError?>(null);
  final controller = Get.put(PaginationController());

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('');
      if (status == "Pending") {
        url = Uri.parse(
            '$appBaseUrl/api/restaurants?page=${controller.pendingRestaurants}&status=$status');
      } else if (status == "Verified") {
        url = Uri.parse(
            '$appBaseUrl/api/restaurants?page=${controller.verifiedRestaurants}&status=$status');
      } else if (status == "Rejected") {
        url = Uri.parse(
            '$appBaseUrl/api/restaurants?page=${controller.rejectedRestaurants}&status=$status');
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("Current Page: ${data['currentPage']}");  // Log current page
        print("Total Pages: ${data['totalPages']}");    // Log total pages
        print("Restaurants: ${data['restaurants']}");  // Log the list of restaurants

        restaurants.value = Restaurants.fromJson(data).restaurants;
        currentPage.value = Restaurants.fromJson(data).currentPage;
        totalPages.value = Restaurants.fromJson(data).totalPages;
        controller.updateTotalPages = Restaurants.fromJson(data).totalPages;
      }

      else {
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

  return FetchRestaurants(
    restaurants: restaurants.value,
    isLoading: isLoading.value,
    error: error.value,
    currentPage: currentPage.value,
    totalPages: totalPages.value,
    refetch: refetch,
  );
}
