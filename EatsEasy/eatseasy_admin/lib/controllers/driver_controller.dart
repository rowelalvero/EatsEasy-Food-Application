import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DriverController extends GetxController {
  Function? refecthList;

  void setData(Function getList) {
    refecthList = getList;
  }

  final box = GetStorage();

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool value) => _isLoading.value = value;
  void updateStatus(String id, String query, Function refetch) async {
    setLoading = true;

    String accessToken = box.read('token');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    var url = Uri.parse('$appBaseUrl/api/drivers?id=$id&status=$query');
    try {
      final response = await http.put(url, headers: headers);
      if (response.statusCode == 200) {
        setLoading = false;
        refetch();

        Get.snackbar("Status Updated", "Status successfully updated",
            colorText: kDark,
            backgroundColor: kOffWhite,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.to(() => const HomePage());
      } else if (response.statusCode == 404) {
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
