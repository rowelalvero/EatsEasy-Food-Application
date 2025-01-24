// controllers/earnings_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/admin_earnings_model.dart';

class EarningsController extends GetxController {
  Earnings? earnings;
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  // Replace with your backend API URL
  final String apiUrl = '$appBaseUrl/api/restaurants/total-earnings';

  // Fetch the total earnings and 10% from the backend
  Future<void> fetchEarnings(double commissionRate) async {
    setLoading = true;

    try {
      // Convert commissionRate to decimal form (e.g., 10.00 => 0.10)
      double decimalCommissionRate = commissionRate / 100;

      // Pass the decimal commissionRate as a query parameter
      final response = await http.get(Uri.parse('$apiUrl?commissionRate=$decimalCommissionRate'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Earnings data: $data"); // Debugging line to inspect the JSON response

        earnings = Earnings.fromJson(data);
        setLoading = false;
      } else {
        throw Exception('Failed to load earnings');
      }
    } catch (error) {
      print("Error fetching earnings: $error");
    } finally {
      setLoading = false;
    }
  }


}
