
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/foods.dart';

class FetchFoods {
  final List<Food>? foods;
  final int currentPage;
  final int totalPages;
  final ApiError? error;
  final bool isLoading;
  final Function? refetch;

  FetchFoods(
      {required this.foods,
      required this.currentPage,
      required this.totalPages,
      required this.error,
      required this.isLoading,
      required this.refetch});
}
