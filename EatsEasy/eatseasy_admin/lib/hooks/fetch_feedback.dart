import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/constants/constants.dart';
import 'package:eatseasy_admin/controllers/pagination/feedback_controller.dart';
import 'package:eatseasy_admin/hooks/hook_data_types/feedback_data.dart';
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/feedback_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

FetchFeedBack fetchFeedback() {
  final feeds = useState<List<Feedbackx>?>(null);
  final isLoading = useState<bool>(false);
  final currentPage = useState<int>(1);
  final totalPages = useState<int>(1);
  final error = useState<ApiError?>(null);
  final appiError = useState<ApiError?>(null);
  final controller = Get.put(FeedbackController());

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      Uri url = Uri.parse('$appBaseUrl/api/feedbacks?page=${controller.available}');
     
      final response = await http.get(url);

      if (response.statusCode == 200) {
        FeedbackModel data = feedbackModelFromJson(response.body);

        feeds.value = data.feedbackx;
        currentPage.value = data.currentPage;
        totalPages.value = data.totalPages;
      } else {
        appiError.value = apiErrorFromJson(response.body);
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

  return FetchFeedBack(
    feeds: feeds.value,
    isLoading: isLoading.value,
    error: error.value,
    currentPage: currentPage.value,
    totalPages: totalPages.value,
    refetch: refetch,
  );
}
