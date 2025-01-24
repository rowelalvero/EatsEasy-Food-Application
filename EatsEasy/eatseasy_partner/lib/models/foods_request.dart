
import 'dart:convert';

import 'package:eatseasy_partner/models/foods.dart';

AddFoods addFoodsFromJson(String str) => AddFoods.fromJson(json.decode(str));

String addFoodsToJson(AddFoods data) => json.encode(data.toJson());

class AddFoods {
    final String title;
    final List<String> foodTags;
    final List<String> foodType;
    final String code;
    final String category;
    final bool isAvailable;
    final String restaurant;
    final String time;
    final String description;
    final int? stocks;
    final double price;
    //final List<Additive> additives;
    final List<String> imageUrl;
    final List<CustomAdditives> customAdditives;

    AddFoods({
        required this.title,
        required this.foodTags,
        required this.foodType,
        required this.code,
        required this.category,
        required this.isAvailable,
        required this.restaurant,
        required this.description,
        this.stocks,
        required this.price,
        required this.time,
        //required this.additives,
        required this.imageUrl,
        required this.customAdditives,
    });

    factory AddFoods.fromJson(Map<String, dynamic> json) => AddFoods(
        title: json['title'],
        foodTags: List<String>.from(json['foodTags']),
        foodType: List<String>.from(json['foodType']),
        code: json['code'],
        category: json['category'],
        isAvailable: json['isAvailable'],
        restaurant: json['restaurant'],
        description: json['description'],
        stocks: json["stocks"],
        price: json['price'].toDouble(),
        time: json['time'],
        //additives: List<Additive>.from(json['additives'].map((x) => Additive.fromJson(x))),
        imageUrl: List<String>.from(json['imageUrl']),
        customAdditives: List<CustomAdditives>.from(
            json['customAdditives'].map((x) => CustomAdditives.fromMap(x)) // Correct parsing here
        ),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "foodTags": foodTags,
        "foodType": foodType,
        "code": code,
        "category": category,
        "isAvailable": isAvailable,
        "restaurant": restaurant,
        "description": description,
        "stocks": stocks,
        "price": price,
        "time": time,
        //"additives": List<dynamic>.from(additives.map((x) => x.toJson())),
        "imageUrl": imageUrl,
        "customAdditives": List<dynamic>.from(customAdditives.map((x) => x.toMap())), // Serialize questions
    };
}





