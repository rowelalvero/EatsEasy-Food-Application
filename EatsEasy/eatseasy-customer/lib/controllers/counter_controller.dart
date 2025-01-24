
import 'package:get/get.dart';

class CounterController extends GetxController {
  var count = 1.obs;  // Initialize count to 1

  void increment() {
    count++;
  }

  void decrement() {
    if (count > 1) {
      count--;
    }
  }
}