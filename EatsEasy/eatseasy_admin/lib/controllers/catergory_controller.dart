import 'package:get/get.dart';

class CategoryController extends GetxController {
  
  RxString category = ''.obs;

  String get categoryValue => category.value;

  set updateCategory(String newValue) {
    category.value = newValue;
  }

  RxString title = ''.obs;

  String get titleValue => title.value;

  set updateTitle(String newValue) {
    title.value = newValue;
  }
}
