import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/foods.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/restaurants.dart';

class FoodSearchController extends GetxController {

  final _searchQuery = 'initial value'.obs;
  String get searchQuery => _searchQuery.value;
  set setSearchQuery(String newValue) {
    _searchQuery.value = newValue;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  List<Food>? foodSearchResults;
  List<Restaurants>? restaurantSearchResults;

  void searchFoods(String key) async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/foods/search/$key');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setLoading = false;
        foodSearchResults = foodFromJson(response.body);
        print("foods: " + foodSearchResults.toString());
        
        return;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setLoading = false;
      rethrow;
    } finally {
      setLoading = false;
    }
  }

  void searchRestaurants(String key) async {
    setLoading = true;
    var url = Uri.parse('${Environment.appBaseUrl}/api/restaurants/search/$key');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        restaurantSearchResults = restaurantsFromJson(response.body);
        print("resto: " + restaurantSearchResults.toString());
      } else {
        throw Exception('Failed to load restaurant data');
      }
    } catch (e) {
      print(e); // Log the error for debugging
    } finally {
      setLoading = false;
    }
  }


}
