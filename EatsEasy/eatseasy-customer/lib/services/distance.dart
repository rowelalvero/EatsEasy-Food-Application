import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:eatseasy/models/distance_time.dart';

import '../constants/constants.dart';
import '../controllers/constant_controller.dart';
import '../models/environment.dart';

class Distance {
  DistanceTime calculateDistanceTimePrice(double lat1, double lon1, double lat2,
      double lon2, double speedKmPerHr, double pricePerKm) {
    // Convert latitude and longitude from degrees to radians
    var rLat1 = _toRadians(lat1);
    var rLon1 = _toRadians(lon1);
    var rLat2 = _toRadians(lat2);
    var rLon2 = _toRadians(lon2);

    // Haversine formula
    var dLat = rLat2 - rLat1;
    var dLon = rLon2 - rLon1;
    var a = pow(sin(dLat / 2), 2) +
        cos(rLat1) * cos(rLat2) * pow(sin(dLon / 2), 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Radius of the Earth in kilometers
    const double earthRadiusKm = 6371.0;
    var distance = earthRadiusKm * c;  // Removed the extra multiplication by 2

    // Calculate time (distance / speed)
    var time = distance / speedKmPerHr;

    // Calculate price (distance * rate per km)
    var price = distance + pricePerKm;

    return DistanceTime(distance: distance, time: time, price: price);
  }

  // Helper function to convert degrees to radians
  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Future<DistanceTime?> calculateDistanceDurationPrice(
      double lat1, double lon1, double lat2, double lon2, double speedKmPerHr, double pricePkm) async {
    final ConstantController controller = Get.put(ConstantController());
    controller.getConstants();

    final String url = '${Environment.appBaseUrl}/api/address/directions'; // Call your backend here

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // Ensure you're sending the correct content type
        },
        body: json.encode({
          'originLat': lat1,
          'originLng': lon1,
          'destinationLat': lat2,
          'destinationLng': lon2,
          'googleApiKey': googleApiKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final distance = data['distance'].toDouble(); // in kilometers
          final duration = data['duration'].toDouble(); // in minutes

          // Calculate price (distance * rate per km)
          final price = (distance * pricePkm) + controller.constants.value.driverBaseRate;

          return DistanceTime(distance: distance, time: duration, price: price);
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load data from backend. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }

    return null;
  }

}

