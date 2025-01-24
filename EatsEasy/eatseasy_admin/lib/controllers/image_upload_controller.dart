import 'dart:io' as io;  // for mobile platforms

// For conditional imports based on platform
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/foundation.dart' show Uint8List, debugPrint;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Use `dynamic` here to allow either `File` or `Uint8List`, depending on the platform.
  var coverFile = Rxn<dynamic>();
  var logoFile = Rxn<dynamic>();
  var image1 = Rxn<dynamic>();
  var image2 = Rxn<dynamic>();
  var imageOne = Rxn<dynamic>();
  var imageTwo = Rxn<dynamic>();
  var imageThree = Rxn<dynamic>();
  var imageFour = Rxn<dynamic>();

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

  RxString _image1Url = ''.obs;
  String get image1Url => _image1Url.value;
  set image1Url(String value) {
    _image1Url.value = value;
  }

  RxString _image2Url = ''.obs;
  String get image2Url => _image2Url.value;
  set image2Url(String value) {
    _image2Url.value = value;
  }

  RxString _imageOneUrl = ''.obs;
  String get imageOneUrl => _imageOneUrl.value;
  set imageOneUrl(String value) {
    _imageOneUrl.value = value;
  }

  RxString _imageTwoUrl = ''.obs;
  String get imageTwoUrl => _imageTwoUrl.value;
  set imageTwoUrl(String value) {
    _imageTwoUrl.value = value;
  }

  RxString _imageThreeUrl = ''.obs;
  String get imageThreeUrl => _imageThreeUrl.value;
  set imageThreeUrl(String value) {
    _imageThreeUrl.value = value;
  }

  RxString _imageFourUrl = ''.obs;
  String get imageFourUrl => _imageFourUrl.value;
  set imageFourUrl(String value) {
    _imageFourUrl.value = value;
  }

  RxString _logoUrl = ''.obs;
  String get logoUrl => _logoUrl.value;
  set logoUrl(String value) {
    _logoUrl.value = value;
  }

  // Track currently uploading image
  RxString imageBeingUploaded = ''.obs;

  Future<void> pickImage(String type) async {
    setLoading = true;
    imageBeingUploaded.value = type;

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
      case "cover":
        coverFile.value = data;
        break;
      case "1":
        image1.value = data;
        break;
      case "2":
        image2.value = data;
        break;
      case "one":
        imageOne.value = data;
        break;
      case "two":
        imageTwo.value = data;
        break;
      case "three":
        imageThree.value = data;
        break;
      case "four":
        imageFour.value = data;
        break;
    }
  }

  RxDouble _uploadProgress = 0.0.obs;
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
      images.add(downloadUrl);
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
      case "cover":
        return coverFile.value;
      case "1":
        return image1.value;
      case "2":
        return image2.value;
      case "one":
        return imageOne.value;
      case "two":
        return imageTwo.value;
      case "three":
        return imageThree.value;
      case "four":
        return imageFour.value;
      default:
        return null;
    }
  }

  void setDownloadUrl(String type, String downloadUrl) {
    switch (type) {
      case "logo":
        logoUrl = downloadUrl;
        break;
      case "cover":
        coverUrl = downloadUrl;
        break;
      case "1":
        image1Url = downloadUrl;
        break;
      case "2":
        image2Url = downloadUrl;
        break;
      case "one":
        imageOneUrl = downloadUrl;
        break;
      case "two":
        imageTwoUrl = downloadUrl;
        break;
      case "three":
        imageThreeUrl = downloadUrl;
        break;
      case "four":
        imageFourUrl = downloadUrl;
        break;
    }
  }
}
