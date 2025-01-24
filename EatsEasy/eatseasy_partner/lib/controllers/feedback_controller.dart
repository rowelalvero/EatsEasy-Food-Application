// ignore_for_file: depend_on_referenced_packages, prefer_final_fields
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/constants.dart';
import '../models/environment.dart';
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

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Function to pick image, supports both mobile and web platforms
  Future<void> pickImage() async {
    try {
      XFile? pickedFile;
      if (kIsWeb) {
        // For Web, allow the user to pick an image from their browser.
        pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      } else {
        // For Android/iOS, allow picking an image from the device gallery
        pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedFile != null) {
        // If a file was picked, we set it to the feedbackFile.
        feedbackFile.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // Upload image to Firebase
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
      debugPrint("Error uploading: $e");
    }
  }

  // Write bytes to a file (for Web and mobile platforms)
  Future<File> writeBytesToFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    return await file.writeAsBytes(bytes);
  }

  RxBool isLoading = false.obs;

  set setLoading(bool value) => isLoading.value = value;

  // Send feedback to the server
  void sendFeedBack(String feedback) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users/feedback');

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
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      setLoading = false;
    } finally {
      setLoading = false;
    }
  }
}
