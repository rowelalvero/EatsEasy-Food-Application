import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/restaurants.dart';

class FetchRestaurants {
  final List<Restaurant>? restaurants;
  final int currentPage;
  final int totalPages;
  final ApiError? error;
  final bool isLoading;
  final Function? refetch;

  FetchRestaurants(
      {required this.restaurants,
      required this.currentPage,
      required this.totalPages,
      required this.error,
      required this.isLoading,
      required this.refetch});
}
