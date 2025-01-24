import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:eatseasy/models/restaurants.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchRestaurants() {
  final restaurants = useState<List<Restaurants>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final isMounted = useIsMounted(); // Hook to check if widget is mounted

// Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/41007428');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        restaurants.value = restaurantsFromJson(response.body);
        isLoading.value = false;
      } else {
        var error = apiErrorFromJson(response.body);
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint(e.toString());
      if(isMounted()) {
        error.value = e as Exception?;
      }

    } finally {
      if(isMounted()) {
        isLoading.value = false;
      }
    }
  }
  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    if(isMounted()) {
      isLoading.value = false;
      fetchData();
    }

  }

  // Return values
  return FetchHook(
    data: restaurants.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
