import 'package:get/get.dart';

class PayoutsPagesController extends GetxController {
  final RxInt _pending = 1.obs;

  int get pending => _pending.value;

  set pending(int newPage) {
    _pending.value = newPage;
  }

    final RxInt _completed = 1.obs;

  int get completed => _completed.value;

  set completed(int newPage) {
    _pending.value = newPage;
  }

    final RxInt _failed = 1.obs;

  int get failed => _failed.value;

  set failed(int newPage) {
    _failed.value = newPage;
  }
}
