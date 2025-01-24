import 'package:get/get.dart';

import 'controller.dart';
class PhotoImageViewBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<PhotoImageViewController>(() => PhotoImageViewController());
  }

}