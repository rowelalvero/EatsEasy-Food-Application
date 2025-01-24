// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/environment.dart';

class UserLocationController extends GetxController {

  RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int newIndex) {
    _currentIndex.value = newIndex;
  }

  RxBool _defaultAddress = true.obs;
  bool get defaultAddress => _defaultAddress.value;
  set defaultAddress(bool newDefaultAddress) {
    _defaultAddress.value = newDefaultAddress;
  }

  var _restaurantLocation = const LatLng(0, 0).obs;
  LatLng get restaurantLocation => _restaurantLocation.value;
  void setLocation(LatLng newLocation) {
    _restaurantLocation.value = newLocation;
    update();
  }

  var _currentLocation = const LatLng(0, 0).obs;
  LatLng get currentLocation => _currentLocation.value;
  void setUserLocation(LatLng newLocation) {
    _currentLocation.value = newLocation;
    update();
  }

  var _userAddress = const Placemark(
    name: "Central Park",
    street: "59th St to 110th St",
    isoCountryCode: "US",
    country: "United States",
    postalCode: "10022",
    administrativeArea: "New York",
    subAdministrativeArea: "New York County",
    locality: "New York",
    subLocality: "Manhattan",
    thoroughfare: "Central Park West",
    subThoroughfare: "1",
  ).obs;

  Placemark get userAddress => _userAddress.value;

  void setUserAddress(Placemark newAddress) {
    _userAddress.value = newAddress;
    update();
  }

  var _address = ''.obs;
  String get address => _address.value;
  set address(String newAddress) {
    _address.value = newAddress;
    update();
  }

  var _postalCode = ''.obs;
  String get postalCode => _postalCode.value;
  set postalCode(String newPostalCode) {
    _postalCode.value = newPostalCode;
    update();
  }

  var _district = ''.obs;
  String get district => _district.value;
  set district(String newDistrict) {
    _district.value = newDistrict;
    update();
  }

  var _city = ''.obs;
  String get city => _city.value;
  set city(String newCity) {
    _city.value = newCity;
    update();
  }

  var _country = ''.obs;
  String get country => _country.value;
  set country(String newCountry) {
    _country.value = newCountry;
    update();
  }

  void getAddressFromLatLng(LatLng latLng) async {
    try {
      final reverseGeocodeUrl = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${Environment.googleApiKey}'
      );

      final response = await http.get(reverseGeocodeUrl);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("API Response: $responseBody");

        if (responseBody['results'].isNotEmpty) {
          // Set formatted address directly
          address = responseBody['results'][0]['formatted_address'];

          // Extract address components
          final addressComponents = responseBody['results'][0]['address_components'];
          for (var component in addressComponents) {
            if (component['types'].contains('sublocality_level_1')) {
              district = component['long_name'];
            } else if (component['types'].contains('locality')) {
              city = component['long_name'];
            } else if (component['types'].contains('postal_code')) {
              postalCode = component['long_name'];
            } else if (component['types'].contains('country')) {
              country = component['long_name'];  // Update the country directly
            }
          }
        } else {
          print('No results found for this location.');
        }
      } else {
        print('Failed to fetch address details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }
  int generateRandomNumber(int min, int max) {
    final _random = Random();
    return min + _random.nextInt(max - min + 1);
  }
}
