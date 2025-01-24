// ignore: file_names
// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  var coverFile = Rxn<File>();
  var logoFile = Rxn<File>();
  var driverLicense = Rxn<File>();
  var nbiClearance = Rxn<File>();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  RxList<String> _images = <String>[].obs;
  List<String> get images => _images;
  set setImages(String newValue) {
    _images.add(newValue);
  }

  RxString _coverUrl = ''.obs;
  String get coverUrl => _coverUrl.value;
  set coverUrl(String value) {
    _coverUrl.value = value;
  }

  RxString _driverLicenseUrl = ''.obs;
  String get driverLicenseUrl => _driverLicenseUrl.value;
  set driverLicenseUrl(String value) {
    _driverLicenseUrl.value = value;
  }

  RxString _nbiClearanceUrl = ''.obs;
  String get nbiClearanceUrl => _nbiClearanceUrl.value;
  set nbiClearanceUrl(String value) {
    _nbiClearanceUrl.value = value;
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
      switch (type) {
        case "logo":
          logoFile.value = File(pickedImage.path);
          break;
        case "cover":
          coverFile.value = File(pickedImage.path);
          break;
        case "driverLicense":
          driverLicense.value = File(pickedImage.path);
          break;
        case "nbiClearance":
          nbiClearance.value = File(pickedImage.path);
          break;
      }
      uploadImageToFirebase(type);
    }
  }

  RxDouble _uploadProgress = 0.0.obs; // Add a variable to track progress
  double get uploadProgress => _uploadProgress.value;
  set setUploadProgress(double value) {
    _uploadProgress.value = value;
  }

  Future<void> uploadImageToFirebase(String type) async {
    setLoading = true;
    File? file;

    switch (type) {
      case "logo":
        file = logoFile.value;
        break;
      case "cover":
        file = coverFile.value;
        break;
      case "driverLicense":
        file = driverLicense.value;
        break;
      case "nbiClearance":
        file = nbiClearance.value;
        break;
    }

    if (file == null) return;

    try {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      UploadTask uploadTask = FirebaseStorage.instance.ref().child(fileName).putFile(file);

      // Start the upload and listen for progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setUploadProgress = progress;
      });

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      switch (type) {
        case "logo":
          logoUrl = downloadUrl;
          break;
        case "cover":
          coverUrl = downloadUrl;
          break;
        case "driverLicense":
          driverLicenseUrl = downloadUrl;
          break;
        case "nbiClearance":
          nbiClearanceUrl = downloadUrl;
          break;
      }

      images.add(downloadUrl);
    } catch (e) {
      debugPrint("Error uploading");
    } finally {
      // Reset the upload progress and the currently uploading image
      setUploadProgress = 0.0;
      imageBeingUploaded.value = ""; // Reset the currently uploading image
      setLoading = false;
    }
  }
}