import 'package:get/get.dart';

class ObsAdditive extends GetxController {
  final int id;
  final String title;
  final String price;
  var isChecked = false.obs;  // Making isChecked an observable

  ObsAdditive({
    required this.id,
    required this.title,
    required this.price,
    bool checked = false, // Optional parameter for initial value
  }) {
    isChecked.value = checked;
  }

  // Method to toggle isChecked value
  void toggleChecked() {
    isChecked.value = !isChecked.value;
  }
}