// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class PaginationController extends GetxController {
  final RxInt _currentPage = 1.obs;

  int get currentPage => _currentPage.value;

  set updatePage(int newPage) {
    _currentPage.value = newPage;
  }

  final RxInt _verifiedRestaurants = 1.obs;

  int get verifiedRestaurants => _verifiedRestaurants.value;

  set verifiedRestaurants(int newPage) {
    _verifiedRestaurants.value = newPage;
  }

  final RxInt _pendingRestaurants = 1.obs;

  int get pendingRestaurants => _pendingRestaurants.value;

  set pendingRestaurants(int newPage) {
    _pendingRestaurants.value = newPage;
  }

  final RxInt _rejectedRestaurants = 1.obs;

  int get rejectedRestaurants => _rejectedRestaurants.value;

  set rejectedRestaurants(int newPage) {
    _rejectedRestaurants.value = newPage;
  }

  final RxInt _categories = 1.obs;

  int get categories => _categories.value;

  set categories(int newPage) {
    _categories.value = newPage;
  }

    final RxInt _orders = 1.obs;

  int get orders => _orders.value;

  set orders(int newPage) {
    _orders.value = newPage;
  }

  final RxInt _totalPages = 0.obs;

  int get totalPages => _totalPages.value;

  set updateTotalPages(int newPage) {
    _totalPages.value = newPage;
  }

  void resetPage() {
    _currentPage.value = 1;
  }
}
