import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/Orders_controller.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/orders_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/order_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FetchOrders fetchOrders(int page, int limit, String query) {
  final orders = useState<List<Order>?>(null);
  final isLoading = useState<bool>(false);
  final currentPage = useState<int>(1);
  final totalPages = useState<int>(1);
  final error = useState<ApiError?>(null);
  final appiError = useState<ApiError?>(null);
  final controller = Get.put(OrderPagesController());

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('');
      if (query == "Placed") {
        url = Uri.parse(
            '$appBaseUrl/api/orders?page=${controller.placed}&orderStatus=$query');
      } else if (query == "Out_for_Delivery") {
        url = Uri.parse(
            '$appBaseUrl/api/orders?page=${controller.delivering}&orderStatus=$query');
      } else if (query == "Cancelled") {
        url = Uri.parse(
            '$appBaseUrl/api/orders?page=${controller.cancelled}&orderStatus=$query');
      }else if (query == "Delivered") {
        url = Uri.parse(
            '$appBaseUrl/api/orders?page=${controller.delivered}&orderStatus=$query');
      }
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = ordersFromJson(response.body);

        orders.value = data.orders;
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

  return FetchOrders(
    orders: orders.value,
    isLoading: isLoading.value,
    error: error.value,
    currentPage: currentPage.value,
    totalPages: totalPages.value,
    refetch: refetch,
  );
}
