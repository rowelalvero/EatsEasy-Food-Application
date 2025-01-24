// ignore_for_file: unnecessary_getters_setters, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/foods.dart';

class FoodsController extends GetxController {
  final box = GetStorage();

  var currentPage = 0.obs;

  void updatePage(int index) {
    currentPage.value = index;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  final RxInt _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  set setTabIndex(int newValue) {
    _tabIndex.value = newValue; // Update the reactive value
    // update(); // This is optional, as .value already triggers updates
  }

  RxList<String> _tags = <String>[].obs;
  List<String> get tags => _tags;
  set setTags(String newValue) {
    _tags.add(newValue);
  }

  RxList<String> _type = <String>[].obs;
  List<String> get type => _type;
  set setType(String newValue) {
    _type.add(newValue);
  }

  int generateRandomNumber() {
    int min = 10;
    int max = 10000;
    final _random = Random();
    return min + _random.nextInt(max - min + 1);
  }

  //Create category getter and setter of type string
  String _category = '';
  String get category => _category;
  set category(String newValue) {
    _category = newValue;
  }

  RxList<CustomAdditives> _customAdditives = <CustomAdditives>[].obs;
  List<CustomAdditives> get customAdditives => _customAdditives;
  set addQuestion(CustomAdditives newQuestion) {
    _customAdditives.add(newQuestion);
  }
}
