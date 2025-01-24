// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class UserPagesController extends GetxController {
  final RxInt _verified = 1.obs;

  int get verified => _verified.value;

  set verified(int newPage) {
    _verified.value = newPage;
  }


  final RxInt _unverified = 1.obs;

  int get unverified => _unverified.value;

  set unverified(int newPage) {
    _unverified.value = newPage;
  }

}
