// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class OrderPagesController extends GetxController {
  final RxInt _placed = 1.obs;
  int get placed => _placed.value;
  set placed(int newPage) {
    _placed.value = newPage;
  }


  final RxInt _delivering = 1.obs;
  int get delivering => _delivering.value;
  set delivering(int newPage) {
    _delivering.value = newPage;
  }

  final RxInt _delivered = 1.obs;
  int get delivered => _delivered.value;
  set delivered(int newPage) {
    _placed.value = newPage;
  }

  final RxInt _cancelled = 1.obs;
  int get cancelled => _cancelled.value;
  set cancelled(int newPage) {
    _placed.value = newPage;
  }

  final RxInt _currentPage = 1.obs;
  int get currentPage => _currentPage.value;
  set currentPage(int newPage) {
    _currentPage.value = newPage;
  }
}
