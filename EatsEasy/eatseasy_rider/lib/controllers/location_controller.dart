// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:eatseasy_rider/controllers/order_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../models/api_error.dart';
import '../models/sucess_model.dart';

class UserLocationController extends GetxController {
  final box = GetStorage();
  final orderController = Get.put(OrdersController());

  var _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int newIndex) {
    _currentIndex.value = newIndex;
    update(); // Equivalent to notifyListeners()
  }

  RxBool _defaultAddress = true.obs;
  RxString _userDefaultAddress=''.obs;
  String get userDefaultAddress => _userDefaultAddress.value;
  void setUserDefaultAddress(String address){
    _userDefaultAddress.value = address;
    update();
  }
  bool get defaultAddress => _defaultAddress.value;
  set defaultAddress(bool newDefaultAddress) {
    _defaultAddress.value = newDefaultAddress;
  }

  var _restaurantLocation = const LatLng(0, 0).obs;
  LatLng get restaurantLocation => _restaurantLocation.value;
  void setLocation(LatLng newLocation) {
    _restaurantLocation.value = newLocation;
    update(); // Equivalent to notifyListeners()
  }

  var _currentLocation = const LatLng(0, 0).obs;  // Already reactive
  LatLng get currentLocation => _currentLocation.value;
  void setUserLocation(LatLng newLocation, String? add) {
    _currentLocation.value = newLocation;
    update();  // Notifies listeners of changes
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
    update(); // Equivalent to notifyListeners()
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

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void getAddressFromLatLng(LatLng latLng) async {
    final reverseGeocodeUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${googleApiKey}');

    final response = await http.get(reverseGeocodeUrl);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      final addressComponents =
      responseBody['results'][0]['address_components'];
      for (var component in addressComponents) {
        if (component['types'].contains('street_address') ||
            component['types'].contains('route')) {
          address = responseBody['results'][0]['formatted_address'];
        } else if (component['types'].contains('sublocality_level_1')) {
          district = component['long_name'];
        } else if (component['types'].contains('locality')) {
          city = component['long_name'];
        } else if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
        } else if (component['types'].contains('country')) {
          // Check for the country type
          _country.value = component['long_name']; // Extract the country name
        }
      }
      update();
    } else {
      // Handle the error or no result case
      print('Failed to fetch address details');
    }
  }

  Future<void> updateDriverLocation(String driverId, double latitude, double longitude) async {
    String accessToken = box.read('token');
    var url = Uri.parse('$appBaseUrl/api/driver/location/$driverId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        print('Location updated successfully');
      } else {
        print('Failed to update location: ${response.body}');
      }
    } catch (e) {
      print('Catch: Failed to update location');
    }
  }
}
