import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy/models/api_error.dart';
import 'package:eatseasy/models/environment.dart';
import 'package:eatseasy/models/hook_models/hook_result.dart';
import 'package:eatseasy/models/user_cart.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchCart() {
  final box = GetStorage();
  final cartData = useState<List<UserCart>?>([]);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final isMounted = useIsMounted();
  String? token = box.read('token');
  String accessToken = "";

  if (token != null) {
    accessToken = jsonDecode(token);
  }else{
    print("returning since no valid token");
  }

  // Fetch Data Function
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${Environment.appBaseUrl}/api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        //Get.find<CartCheckoutController>().cartObs.refresh();
        cartData.value = userCartFromJson(response.body);
        isLoading.value = false;

      } else {
        var error = apiErrorFromJson(response.body);
        isLoading.value = false;
      }
    } catch (e) {
      print("cart status  ${e.toString()}");
      debugPrint(e.toString());
    } finally {
      if(isMounted()) {
        isLoading.value = false;
      }
    }
  }

  // Side Effect
  useEffect(() {
    if (token == null) {
      return null;
    } else {
      fetchData();
    }
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    if(isMounted()){
      isLoading.value = true;
      fetchData();
    }
  }

  // Return values
  return FetchHook(
    data: cartData.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}

