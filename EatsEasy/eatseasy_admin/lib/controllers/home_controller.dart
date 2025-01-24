import 'package:get/get.dart';

class HomeController extends GetxController {

   RxString currentPage = "Restaurant".obs;

  set updatePage(String newPage) {
    currentPage.value = newPage;
  }
     RxString image = "assets/icons/restaurant_building.svg".obs;

  set updateImage(String newImage) {
    image.value = newImage;
  }








}
