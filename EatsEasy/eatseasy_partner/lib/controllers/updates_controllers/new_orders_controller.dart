import 'package:get/get.dart';

class NewOrdersController extends GetxController {

  var refetch = false.obs;

  // Function to be called when status changes
  Function? onStatusChange;
  RxInt triggerReload=0.obs;
  @override
  void onInit() {
    super.onInit();
    // Set up the listener
    ever(refetch, (_) async {
      if (refetch.isTrue && onStatusChange != null) {
        print("Hello......");
        await Future.delayed(const Duration(seconds: 5));
        onStatusChange!();
      }
    });
  }

  void setOnStatusChangeCallback(Function callback) {
    onStatusChange = callback;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("closed.....");
    super.onClose();
  }

  void setTriggerReload(){
    print("Reloading new orders tab ${triggerReload.value}");

    triggerReload.value++;
  }
}