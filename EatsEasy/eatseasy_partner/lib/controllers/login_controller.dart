import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:eatseasy_partner/common/entities/user.dart';
import 'package:eatseasy_partner/constants/constants.dart';
import 'package:eatseasy_partner/controllers/notifications_controller.dart';
import 'package:eatseasy_partner/controllers/restaurant_controller.dart';
import 'package:eatseasy_partner/main.dart';
import 'package:eatseasy_partner/models/api_error.dart';
import 'package:eatseasy_partner/models/environment.dart';
import 'package:eatseasy_partner/models/login_request.dart';
import 'package:eatseasy_partner/models/restaurant_response.dart';
import 'package:eatseasy_partner/views/auth/restaurant_registration.dart';
import 'package:eatseasy_partner/views/auth/login_page.dart';
import 'package:eatseasy_partner/views/auth/verification_page.dart';
import 'package:eatseasy_partner/views/auth/waiting_page.dart';
import 'package:eatseasy_partner/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/login_response.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  final controller = Get.put(NotificationsController());
  final restaurantController = Get.put(RestaurantController());
  RxBool _isLoading = false.obs;
  final db = FirebaseFirestore.instance;
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;
  bool get isLoading => _isLoading.value;

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
        print("user login id is ${userId}");
        box.write(userId, userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        print(box.read("userId"));
        box.write("e-verification", data.verification);
        box.write("phoneVerification", data.phoneVerification);
        box.write("phone", data.phone);
        box.write("email", data.email);
        controller.updateUserToken(controller.fcmToken);

        print("${controller.fcmToken} updated successfully");
        if (data.userType == "Vendor") {
          getRestaurant(data.userToken);
        } else if (data.verification == false) {
          Get.offAll(() => const VerificationPage());
        } else {
          Get.snackbar("Please register your business",
              "You do not have a registered restaurant, please register first",
              icon: const Icon(Ionicons.fast_food_outline));

          defaultHome = const Login();
          Get.offAll(() => const RestaurantRegistration(),);

          defaultHome = const Login();
        }

        setLoading = false;

        /*Get.snackbar("Successfully logged in ", "Enjoy your awesome experience",
            icon: const Icon(Ionicons.fast_food_outline));
*/

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
    defaultHome = const Login();
    Get.offAll(() => defaultHome,);
  }

  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    String? data = box.read(jsonDecode(userId!));
    if (data != null) {
      return loginResponseFromJson(data);
    }
    return null;
  }

  void getRestaurant(String token) async {
    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/profile');

    try {
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        RestaurantResponse restaurant =
        restaurantResponseFromJson(response.body);
        restaurantController.restaurant = restaurant;
        box.write("restaurantId", restaurant.id);
        box.write("verification", restaurant.verification);
        box.write(restaurant.id, json.encode(restaurant));

        restaurantController.restaurant = getRestaurantData(restaurant.id)!;

        if (restaurant.verification != "Verified") {
          Get.offAll(() => const WaitingPage());
        } else {
          Get.to(() => const HomePage(),);
        }
      } else {
        var error = apiErrorFromJson(response.body);
        Get.snackbar("Opps Error ", error.message,
            icon: const Icon(Ionicons.fast_food_outline));

        Get.offAll(() => const HomePage(),);
      }
    } catch (e) {
      Get.snackbar(e.toString(), "Failed to login, please try again",
          icon: const Icon(Icons.error));
    }
  }

  RestaurantResponse? getRestaurantData(String restaurantId) {
    String? data = box.read(restaurantId);
    if (data != null) {
      return restaurantResponseFromJson(data);
    }
    return null;
  }

  RxBool _payout = false.obs;

  bool get payout => _payout.value;

  set setRequest(bool newValue) {
    _payout.value = newValue;
  }
}

