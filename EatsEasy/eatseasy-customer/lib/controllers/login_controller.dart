// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy/common/entities/user.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:eatseasy/controllers/notifications_controller.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/login_request.dart';
import 'package:eatseasy/models/login_response.dart';
import 'package:eatseasy/views/auth/verification_page.dart';
import 'package:eatseasy/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../views/auth/phone_verification.dart';

class LoginController extends GetxController {
  final controller = Get.put(NotificationsController());
  final box = GetStorage();
  RxBool _isLoading = false.obs;
  final db = FirebaseFirestore.instance;
  bool get isLoading => _isLoading.value;
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void loginFunc(String model, LoginRequest login) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );
      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = json.encode(data);

        box.write(userId, userData);
        box.write("user", userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("verification", data.verification);
        box.write("email", data.email);

        print("my token is ${json.encode(data.userToken)}");
        if (data.phoneVerification == true) {
          box.write("phone_verification", true);
        } else {
          box.write("phone_verification", false);
        }

        setLoading = false;
        controller.updateUserToken(controller.fcmToken);
        Get.snackbar("Welcome!", "Successful login",
            icon: const Icon(Ionicons.fast_food_outline));

        var userbase = await db.collection("users").withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options)=>userdata.toFirestore(),
        ).where("id", isEqualTo: userId).get();

        if(userbase.docs.isEmpty){
          print("docs---empty");
          final data = UserData(
              id:userId,
              name: "",
              email: login.email,
              photourl: "",
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now()

          );
           try {
            await db.collection("users").withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) => userdata.toFirestore(),
            ).add(data);

            print("docs---updated");
          } catch (e) {
            print("Error adding document: $e");
          }
          print("docs---updated");
        }else{
          print("docs---exist");
        }
        Get.offAll(() => MainScreen());
        if (data.verification == false) {
          Get.offAll(() => const VerificationPage());
        } else {
          Get.offAll(() => MainScreen());
        }
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

  void logout() {
    box.erase();
    Get.offAll(() => MainScreen());
  }

  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    String? data = box.read(jsonDecode(userId!));
    if (data != null) {
      return loginResponseFromJson(data);
    }
    return null;
  }

  void deleteAccount() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;
        box.erase();
        Get.offAll(() => MainScreen());
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to delete, please try again",
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to delete, please try again",
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
