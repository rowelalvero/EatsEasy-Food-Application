import 'package:flutter/material.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/sucess_model.dart';
import 'package:eatseasy/views/auth/login_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void registration(String model) async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/register');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);
        setLoading = false;

        Get.snackbar(data.message, "Proceed to login",
            icon: const Icon(Icons.add_alert));

        Get.to(() => const Login());
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again",
          icon: const Icon(Icons.error));

    } finally {
      setLoading = false;
    }
  }
}
