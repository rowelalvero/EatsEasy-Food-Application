import 'package:get/get.dart';

class DeliveryOptionsController extends GetxController {

  RxString option = ''.obs;
  String get optionValue => option.value;
  set updateCategory(String newValue) {
    option.value = newValue;
  }

  RxString title = ''.obs;
  String get titleValue => title.value;
  set updateTitle(String newValue) {
    title.value = newValue;
  }
}
