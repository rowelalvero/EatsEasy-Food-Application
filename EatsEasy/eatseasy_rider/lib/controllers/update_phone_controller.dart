import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class UpdatePhoneController extends GetxController {
  final box = GetStorage();
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  Future<void> updateUser(String model) async {
    String? userId = box.read("userId");
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    String? data = box.read("user");
    print(userId);
    print(token);

    final url = Uri.parse('${appBaseUrl}/api/users/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    setLoading = true;

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: model,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('Phone number updated successfully: $responseBody');
        Get.snackbar("Success", "Phone number updated successfully.");
      } else {
        print('Failed to update phone number. Status code: ${response.statusCode}');
        Get.snackbar("Error", "Failed to update phone number. Try again.");
      }
    } catch (error) {
      print('Error: $error');
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      setLoading = false;
    }
  }

}
