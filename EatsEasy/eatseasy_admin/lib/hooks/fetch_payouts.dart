import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/payouts_controller.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/payout_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/payouts_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FetchPayouts fetchPayouts(String status) {
  final payouts = useState<List<PayoutElement>?>(null);
  final isLoading = useState<bool>(false);
  final currentPage = useState<int>(1);
  final totalPages = useState<int>(0);
  final error = useState<ApiError?>(null);
  final appiError = useState<ApiError?>(null);
  final controller = Get.put(PayoutsPagesController());

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('');
      if (status == "pending") {
        url = Uri.parse(
            '$appBaseUrl/api/payouts?page=${controller.pending}&status=$status');
      } else if (status == "completed") {
        url = Uri.parse(
            '$appBaseUrl/api/payouts?page=${controller.completed}&status=$status');
      } else if (status == "failed") {
        url = Uri.parse(
            '$appBaseUrl/api/payouts?page=${controller.failed}&status=$status');
      }

      final response = await http.get(url);

      var data = jsonDecode(response.body);
      payouts.value = Payout.fromJson(data).payouts;
      currentPage.value = Payout.fromJson(data).currentPage;
      totalPages.value = Payout.fromJson(data).totalPages;

      if (response.statusCode == 200) {

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

  return FetchPayouts(
    payouts: payouts.value,
    isLoading: isLoading.value,
    error: error.value,
    currentPage: currentPage.value,
    totalPages: totalPages.value,
    refetch: refetch,
  );
}
