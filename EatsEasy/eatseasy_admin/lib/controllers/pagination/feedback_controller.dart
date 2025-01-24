// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class FeedbackController extends GetxController {

    Function? refecthList;

  void setData(Function getList) {
    refecthList = getList;
  }
  
  final RxInt _available = 1.obs;

  int get available => _available.value;

  set available(int newPage) {
    _available.value = newPage;
  }

}
