import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/payouts_model.dart';

class FetchPayouts {
  final List<PayoutElement>? payouts;
  final int currentPage;
  final int totalPages;
  final ApiError? error;
  final bool isLoading;
  final Function? refetch;

  FetchPayouts(
      {required this.payouts,
      required this.currentPage,
      required this.totalPages,
      required this.error,
      required this.isLoading,
      required this.refetch});
}
