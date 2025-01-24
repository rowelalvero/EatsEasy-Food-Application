
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/feedback_model.dart';

class FetchFeedBack {
  final List<Feedbackx>? feeds;
  final int currentPage;
  final int totalPages;
  final ApiError? error;
  final bool isLoading;
  final Function? refetch;

  FetchFeedBack(
      {required this.feeds,
      required this.currentPage,
      required this.totalPages,
      required this.error,
      required this.isLoading,
      required this.refetch});
}
