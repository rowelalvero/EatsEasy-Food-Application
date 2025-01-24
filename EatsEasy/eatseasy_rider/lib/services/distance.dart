import 'dart:convert';
import 'dart:math';
import 'package:eatseasy_rider/models/distance_time.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../controllers/constant_controller.dart';

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
    String origin = "$lat1,$lon1";
    String destination = "$lat2,$lon2";

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if ((data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];

          final leg = route['legs'][0];

          // Extracting the distance and duration
          final distanceText = leg['distance']['value'] / 1000; // in kilometers
          final durationText = leg['duration']['value'] / 60; // in minutes

          // Calculate price (distance * rate per km)
          final price = (distanceText * pricePkm) + controller.constants.value.driverBaseRate;


          return DistanceTime(distance: distanceText, time: durationText, price: price);
        }
      } else {
        print('Failed to load data from Google API');
      }
    } catch (e) {
      print('Error occurred: $e');
    }

    return null;
  }
}
