import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

import '../models/environment.dart';

// Custom Hook
String useFetchCustomerService() {
  final customerService = useState<String>('');
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
 
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${Environment.appBaseUrl}/api/users/customer_service'),
      );

      if (response.statusCode == 200) {
        customerService.value = jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);


  return customerService.value;
}
