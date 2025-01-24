import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/drivers_page_controller.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/driver_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/driver_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FetchDrivers fetchDrivers(String status) {
  final drivers = useState<List<DriverElement>?>(null);
  final isLoading = useState<bool>(false);
  final currentPage = useState<int>(1);
  final totalPages = useState<int>(1);
  final error = useState<ApiError?>(null);
  final appiError = useState<ApiError?>(null);
  final controller = Get.put(DriversPagesController());

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('');
      if (status == 'Pending') {
        url = Uri.parse(
            '$appBaseUrl/api/drivers?page=${controller.pending}&status=$status');
      } else if (status == 'Verified') {
        url = Uri.parse(
            '$appBaseUrl/api/drivers?page=${controller.verified}&status=$status');
      } else {
        url = Uri.parse(
            '$appBaseUrl/api/drivers?page=${controller.rejected}&status=$status');
      }
      final response = await http.get(url,);
      if (response.statusCode == 200) {
        var data = driverFromJson(response.body);

        drivers.value = data.drivers;
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

  return FetchDrivers(
    drivers: drivers.value,
    isLoading: isLoading.value,
    error: error.value,
    currentPage: currentPage.value,
    totalPages: totalPages.value,
    refetch: refetch,
  );
}
