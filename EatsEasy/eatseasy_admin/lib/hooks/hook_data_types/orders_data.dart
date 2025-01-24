import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/order_model.dart';

class FetchOrders {
  final List<Order>? orders;
  final int currentPage;
  final int totalPages;
  final ApiError? error;
  final bool isLoading;
  final Function? refetch;

  FetchOrders(
      {required this.orders,
      required this.currentPage,
      required this.totalPages,
      required this.error,
      required this.isLoading,
      required this.refetch});
}
