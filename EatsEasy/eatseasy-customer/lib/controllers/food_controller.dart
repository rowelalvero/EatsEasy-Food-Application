import 'package:eatseasy/models/foods.dart';
import 'package:eatseasy/models/obs_additives.dart';
import 'package:get/get.dart';
import '../models/obs_custom_additives.dart';

class FoodController extends GetxController {
  var additivesList = <ObsAdditive>[].obs;
  var customAdditivesList = <ObsCustomAdditive>[].obs;
  final RxDouble _totalPrice = 0.0.obs;
  final RxDouble _totalPriceCustomAdditives = 0.0.obs;
  bool initialCheckedValue = false;
  List<String> ads = [];
  Map<String, dynamic> userResponses = {};
  var currentPage = 0.obs;

  void updatePage(int index) {
    currentPage.value = index;
  }

  void loadAdditives(List<Additive> addittives) {
    additivesList.clear();
    for (var additiveInfo in addittives) {
      var additive = ObsAdditive(
        id: additiveInfo.id,
        title: additiveInfo.title,
        price: additiveInfo.price,
        checked: initialCheckedValue,
      );
      if (addittives.length != additivesList.length) {
        additivesList.add(additive);
      }
    }
  }

  void loadCustomAdditives(List<CustomAdditives> customAdditives) {
    customAdditivesList.clear(); // Clear the existing list

    for (var customAdditiveInfo in customAdditives) {
      // Create an ObsCustomAdditive from the provided CustomAdditives
      var customAdditive = ObsCustomAdditive(
        id: customAdditiveInfo.id,
        checked: initialCheckedValue,
        text: customAdditiveInfo.text,
        type: customAdditiveInfo.type,
        options: customAdditiveInfo.options
            ?.where((option) => option != null) // Ensure no null options
            .map((option) => option.toJson())
            .toList(),

        linearScale: customAdditiveInfo.linearScale,
        minScale: customAdditiveInfo.minScale,
        maxScale: customAdditiveInfo.maxScale,
        minScaleLabel: customAdditiveInfo.minScaleLabel,
        maxScaleLabel: customAdditiveInfo.maxScaleLabel,
        required: customAdditiveInfo.required,
        selectionType: customAdditiveInfo.selectionType,
        selectionNumber: customAdditiveInfo.selectionNumber,
        customErrorMessage: customAdditiveInfo.customErrorMessage,
      );

      // Add the custom additive to the list
      customAdditivesList.add(customAdditive);
    }
  }

  double get additiveTotal => _totalPrice.value;
  set setAdditveTotal(double newValue) {
    _totalPrice.value = newValue;
  }
  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var additive in additivesList) {
      if (additive.isChecked.value) {
        totalPrice += double.tryParse(additive.price) ?? 0.0;
      }
    }
    setAdditveTotal = totalPrice;
    return totalPrice;
  }

  List<String> getList() {
    List<String> ads = [];
    for (var additive in additivesList) {
      if (additive.isChecked.value && !ads.contains(additive.title)) {
        ads.add(additive.title);
      } else if (!additive.isChecked.value && ads.contains(additive.title)) {
        ads.remove(additive.title);
      }
    }
    return ads;
  }


  double get additiveTotalCustom => _totalPriceCustomAdditives.value;
  set setAdditiveTotalCustom(double newValue) {
    _totalPriceCustomAdditives.value = newValue;
  }
  // New method to calculate the total price of custom additives
  double getTotalPriceCustomAdditives() {
    double totalCustomPrice = 0.0;


    // Add price for selected checkbox options
    for (var customAdditive in customAdditivesList) {
      if (userResponses[customAdditive.text] != null) {
        for (var option in customAdditive.options ?? []) {
          if (userResponses[customAdditive.text].contains(option['optionName'])) {
            totalCustomPrice += double.tryParse(option['price'] ?? '0') ?? 0.0;
          }
        }
      }
    }

    setAdditiveTotalCustom = totalCustomPrice; // Update the total price in the controller
    return totalCustomPrice;
  }


  // New method to get list of custom additive option names
  List<String> getListCustomAdditives() {
    List<String> customAds = [];
    print('customAdditivesList: $customAdditivesList');
    for (var customAdditive in customAdditivesList) {
      print('isChecked: ${customAdditive.isChecked.value}'); // Log isChecked
      if (customAdditive.isChecked.value) {
        for (var option in customAdditive.options ?? []) {
          var optionName = option['optionName'];
          print('Found optionName: $optionName'); // Log found options
          if (!customAds.contains(optionName)) {
            customAds.add(optionName);
          }
        }
      }
    }
    print('customAds: $customAds'); // Final output of customAds
    return customAds;
  }


}
