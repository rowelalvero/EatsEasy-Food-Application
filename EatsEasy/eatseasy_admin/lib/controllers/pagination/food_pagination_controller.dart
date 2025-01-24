// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class FoodPagesController extends GetxController {
  final RxInt _available = 1.obs;

  int get available => _available.value;

  set available(int newPage) {
    _available.value = newPage;
  }


  final RxInt _soldout = 1.obs;

  int get soldout => _soldout.value;

  set soldout(int newPage) {
    _soldout.value = newPage;
  }

}
