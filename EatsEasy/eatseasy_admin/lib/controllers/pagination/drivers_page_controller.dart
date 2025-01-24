// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class DriversPagesController extends GetxController {
  final RxInt _verified = 1.obs;

  int get verified => _verified.value;

  set verified(int newPage) {
    _verified.value = newPage;
  }


  final RxInt _pending = 1.obs;

  int get pending => _pending.value;

  set pending(int newPage) {
    _pending.value = newPage;
  }
  
    final RxInt _rejected = 1.obs;

  int get rejected => _rejected.value;

  set rejected(int newPage) {
    _rejected.value = newPage;
  }

}
