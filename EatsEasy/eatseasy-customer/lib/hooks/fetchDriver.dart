import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/contact_controller.dart';
import '../controllers/driver_contact_controller.dart';
import '../models/environment.dart';
import '../models/hook_models/hook_result.dart';
import '../models/order_details.dart';

// Custom Hook
FetchHook useFetchDriver(id) {
  final drivers = useState<Driver?>(null);// Stores list of users
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final controller = Get.find<DriverContactController>();

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('${Environment.appBaseUrl}/api/users/byId/$id'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Driver fetchedDrivers = Driver.fromJson(data);
        drivers.value = fetchedDrivers;
        controller.state.driver.value = fetchedDrivers;
      } else {
        throw Exception('Failed to load drivers');
      }
    } catch (e) {
      print(e.toString());
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect to fetch data when hook is used
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: drivers.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
