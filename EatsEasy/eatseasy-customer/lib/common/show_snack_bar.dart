import 'package:flutter/material.dart';
import 'package:eatseasy/constants/constants.dart';
import 'package:get/get.dart';
void showCustomSnackBar(String message, {bool isError = true, String title="Login first"}) {

  Get.snackbar(
      icon:  isError==true?const Icon(Icons.error):const Icon(Icons.thumb_up),
      title,
      message,
      titleText: Text(title, style: const TextStyle(fontSize: 20),),
      messageText: Text(message, style: const TextStyle(
          fontSize: 16,
      ),),
  );
}