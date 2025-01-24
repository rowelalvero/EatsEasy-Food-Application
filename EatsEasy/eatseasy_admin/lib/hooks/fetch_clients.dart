import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/pagination_controller.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/users_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/users_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FetchUsers fetchClients(
    int page,
    int limit,
    ) {
  final clients = useState<List<User>?>(null);
  final isLoading = useState<bool>(false);
  final currentPage = useState<int>(1);
  final totalPages = useState<int>(1);
  final error = useState<ApiError?>(null);
  final appiError = useState<ApiError?>(null);
  final controller = Get.put(PaginationController());

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('$appBaseUrl/api/clients?page=${controller.currentPage}&limit=$limit');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = usersFromJson(response.body);
        clients.value = data.users;
        currentPage.value = data.currentPage;
        controller.updateTotalPages = data.totalPages;
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

  return FetchUsers(
    users: clients.value,
    isLoading: isLoading.value,
    error: error.value,
    currentPage: currentPage.value,
    totalPages: totalPages.value,
    refetch: refetch,
  );
}
