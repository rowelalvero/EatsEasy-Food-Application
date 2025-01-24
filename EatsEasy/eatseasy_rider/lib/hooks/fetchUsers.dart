import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/contact_controller.dart';
import '../models/hook_models/hook_result.dart';
import '../models/users.dart';

// Custom Hook
FetchHook useFetchUsers(id) {
  final users = useState<User?>(null);// Stores list of users
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final controller = Get.find<ContactController>();

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$appBaseUrl/api/users/byId/$id'));

      print("..............."+ response.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        User fetchedUsers = User.fromJson(data);
        users.value = fetchedUsers;
        controller.state.user.value = fetchedUsers;
      } else {
        throw Exception('Failed to load users');
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
    data: users.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
