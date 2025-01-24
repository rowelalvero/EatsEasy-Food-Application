// ignore_for_file: prefer_final_fields, depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class ImageFeedbackUploadController extends GetxController {
  var feedbackFile = Rxn<File>();

  RxString _feedBackUrl = ''.obs;
  String get feedBackUrl => _feedBackUrl.value;
  set feedBackUrl(String value) {
    _feedBackUrl.value = value;
  }

  Future<void> uploadImageToFirebase() async {
    if (feedbackFile.value == null) return;
    try {
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}_${feedbackFile.value!.path.split('/').last}';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(feedbackFile.value!);
      feedBackUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading");
    }
  }

  Future<File> writeBytesToFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');

    return await file.writeAsBytes(bytes);
  }
}
