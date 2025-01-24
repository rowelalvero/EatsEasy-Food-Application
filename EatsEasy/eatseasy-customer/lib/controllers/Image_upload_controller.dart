import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/foundation.dart' show Uint8List, debugPrint;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  var logoFile = Rxn<dynamic>();
  var validId = Rxn<dynamic>();
  var proofOfResidence = Rxn<dynamic>();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  RxString _validIdUrl = ''.obs;
  String get validIdUrl => _validIdUrl.value;
  set validIdUrl(String value) {
    _validIdUrl.value = value;
  }

  RxString _proofOfResidenceUrl = ''.obs;
  String get proofOfResidenceUrl => _proofOfResidenceUrl.value;
  set proofOfResidenceUrl(String value) {
    _proofOfResidenceUrl.value = value;
  }

  RxString _logoUrl = ''.obs;
  String get logoUrl => _logoUrl.value;
  set logoUrl(String value) {
    _logoUrl.value = value;
  }

  // Add a variable to track the currently uploading image
  RxString imageBeingUploaded = ''.obs;

  Future<void> pickImage(String type) async {
    setLoading = true;
    imageBeingUploaded.value = type; // Set the currently uploading image type

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      if (kIsWeb) {
        Uint8List imageData = await pickedImage.readAsBytes();
        setImageData(type, imageData);
      } else {
        io.File file = io.File(pickedImage.path);
        setImageData(type, file);
      }
      uploadImageToFirebase(type);
    }

  }

  void setImageData(String type, dynamic data) {
    switch (type) {
      case "logo":
        logoFile.value = data;
        break;
      case "validId":
        validId.value = data;
        break;
      case "proofOfResidence":
        proofOfResidence.value = data;
        break;
      case "2":
    }
  }

  RxDouble _uploadProgress = 0.0.obs; // Add a variable to track progress
  double get uploadProgress => _uploadProgress.value;
  set setUploadProgress(double value) {
    _uploadProgress.value = value;
  }

  Future<void> uploadImageToFirebase(String type) async {
    setLoading = true;

    UploadTask? uploadTask;
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_$type.png';

    try {
      if (kIsWeb) {
        Uint8List? imageData = getImageData(type) as Uint8List?;
        if (imageData != null) {
          uploadTask = FirebaseStorage.instance.ref().child(fileName).putData(imageData);
        }
      } else {
        io.File? file = getImageData(type) as io.File?;
        if (file != null) {
          uploadTask = FirebaseStorage.instance.ref().child(fileName).putFile(file);
        }
      }

      if (uploadTask == null) return;

      // Track progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setUploadProgress = progress;
      });

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setDownloadUrl(type, downloadUrl);
    } catch (e) {
      debugPrint("Error uploading: $e");
    } finally {
      setUploadProgress = 0.0;
      imageBeingUploaded.value = "";
      setLoading = false;
    }
  }

  dynamic getImageData(String type) {
    switch (type) {
      case "logo":
        return logoFile.value;
      case "validId":
        return validId.value;
      case "proofOfResidence":
        return proofOfResidence.value;
      default:
        return null;
    }
  }

  void setDownloadUrl(String type, String downloadUrl) {
    switch (type) {
      case "logo":
        logoUrl = downloadUrl;
        break;
      case "validId":
        validIdUrl = downloadUrl;
        break;
      case "proofOfResidence":
        proofOfResidenceUrl = downloadUrl;
        break;
    }
  }
}