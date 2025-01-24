import 'dart:convert';
import 'dart:math';
import 'package:eatseasy_partner/models/distance_time.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../controllers/constant_controller.dart';
import '../models/environment.dart';
class Distance {
  DistanceTime calculateDistanceTimePrice(double lat1, double lon1, double lat2,
      double lon2, double speedKmPerHr, double pricePkm) {
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
    var price = distance + pricePkm;

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

    final String url = '${Environment.appBaseUrl}/api/directions'; // Call your backend here

    try {
      final response = await http.post(Uri.parse(url), body: {
        'originLat': lat1.toString(),
        'originLng': lon1.toString(),
        'destinationLat': lat2.toString(),
        'destinationLng': lon2.toString(),
        'googleApiKey': googleApiKey,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final distance = data['distance']; // in kilometers
          final duration = data['duration']; // in minutes

          // Calculate price (distance * rate per km)
          final price = (distance * pricePkm) + controller.constants.value.driverBaseRate;

          return DistanceTime(distance: distance, time: duration, price: price);
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load data from backend');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null;
  }
}
