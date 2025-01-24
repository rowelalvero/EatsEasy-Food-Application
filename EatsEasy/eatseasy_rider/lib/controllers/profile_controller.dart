import 'dart:convert';
import 'package:eatseasy_rider/controllers/wallet_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class UpdateUserController extends GetxController {
  final WalletController _walletController = Get.put(WalletController());
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

    print("accesstoken: " + token);
    print("userId: " + userId!);

    final url = Uri.parse('${appBaseUrl}/api/users/$userId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
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
        print('User updated successfully: $responseBody');
        _walletController.fetchDriverDetails();
        Get.snackbar("Success", "Profile updated successfully.");
      } else {
        print('Failed to update user. Status code: ${response.statusCode}');
        Get.snackbar("Error", "Failed to update profile. Try again.");
      }
    } catch (error) {
      print('Error: $error');
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      setLoading = false;
    }
  }

}
