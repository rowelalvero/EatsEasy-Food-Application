import 'package:flutter/material.dart';
import 'package:eatseasy_rider/constants/constants.dart';
import 'package:get/get.dart';
void showCustomSnackBar(String message, {bool isError = true, String title="Errors"}) {

  Get.snackbar(
      icon:  isError==true?const Icon(Icons.error):const Icon(Icons.thumb_up),
      title,
      message,
      titleText: Text(title, style: const TextStyle(color: kDark, fontSize: 20),),
      messageText: Text(message, style: const TextStyle(
        color: kDark,
        fontSize: 16,
      ),),
  );
}