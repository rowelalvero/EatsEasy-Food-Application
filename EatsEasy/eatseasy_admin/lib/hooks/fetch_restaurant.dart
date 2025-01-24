import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/restaurant_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/restaurant_data.dart';
import 'package:http/http.dart' as http;

FetchRestaurantData fetchRestaurant(
  String id,
) {
  final restaurant = useState<Data?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<ApiError?>(null);
  final ordersTotal = useState<int>(0);
  final cancelledOrders = useState<int>(0);
  final revenueTotal = useState<double>(0);
  final processingOrders = useState<int>(0);
  final restaurantToken = useState<String>('');
  final apiError = useState<ApiError?>(null);
 

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('$appBaseUrl/api/restaurants/byId/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        RestaurantData data = restaurantDataFromJson(response.body);
        restaurant.value = data.data;
        ordersTotal.value = data.ordersTotal;
        cancelledOrders.value = data.cancelledOrders;
        revenueTotal.value = data.revenueTotal;
        processingOrders.value = data.processingOrders;
      } else {
        apiError.value = apiErrorFromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchRestaurantData(
    restaurant: restaurant.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
    ordersTotal: ordersTotal.value,
    cancelledOrders: cancelledOrders.value,
    revenueTotal: revenueTotal.value,
    processingOrders: processingOrders.value,
    restaurantToken: restaurantToken.value,
  );
}
