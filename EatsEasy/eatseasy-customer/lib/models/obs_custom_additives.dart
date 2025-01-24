import 'package:get/get.dart';

class ObsCustomAdditive extends GetxController {
  final int id;
  final String text;
  final String? type;
  final List<Map<String, dynamic>>? options;
  final double? linearScale;
  final double? minScale;
  final double? maxScale;
  final String? minScaleLabel;
  final String? maxScaleLabel;
  final bool required;
  final String? selectionType;
  final int? selectionNumber;
  final String? customErrorMessage;
  var isChecked = false.obs; // Making isChecked an observable

  ObsCustomAdditive({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    this.linearScale,
    this.minScale,
    this.maxScale,
    this.minScaleLabel,
    this.maxScaleLabel,
    this.required = false,
    this.selectionType,
    this.selectionNumber,
    this.customErrorMessage,
    bool checked = false, // Optional parameter for initial value
  }) {
    isChecked.value = checked;
  }

  // Method to toggle isChecked value
  void toggleChecked() {
    isChecked.value = !isChecked.value;
  }


}
