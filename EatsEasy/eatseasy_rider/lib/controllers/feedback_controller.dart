// ignore_for_file: depend_on_referenced_packages, prefer_final_fields
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../constants/constants.dart';
import '../models/feedback_model.dart';
import '../models/sucess_model.dart';

class UserFeedBackController extends GetxController {
  final box = GetStorage();

  var feedbackFile = Rxn<File>();

  RxString _feedBackUrl = ''.obs;

  String get feedBackUrl => _feedBackUrl.value;

  set feedBackUrl(String value) {
    _feedBackUrl.value = value;
  }

  Future<void> uploadImageToFirebase(String feedback) async {
    if (feedbackFile.value == null) return;
    try {
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}_${feedbackFile.value!.path.split('/').last}';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(feedbackFile.value!);
      feedBackUrl = await snapshot.ref.getDownloadURL();

      FeedbackModel model =
          FeedbackModel(message: feedback, imageUrl: feedBackUrl);

      String feed = feedbackModelToJson(model);
      sendFeedBack(feed);
    } catch (e) {
      debugPrint("Error uploading");
    }
  }

  Future<File> writeBytesToFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');

    return await file.writeAsBytes(bytes);
  }

  RxBool isLoading = false.obs;
  set setLoading(bool value) => isLoading.value = value;

  void sendFeedBack(String feedback) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('$appBaseUrl/api/users/feedback');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: feedback,
      );

      if (response.statusCode == 201) {
        setLoading = false;

        SuccessResponse success = successResponseFromJson(response.body);

        Get.snackbar(
          'Feedback Sent',
          success.message,
        );
      }
    } catch (e) {
      setLoading = false;
    } finally {
      setLoading = false;
    }
  }
}
