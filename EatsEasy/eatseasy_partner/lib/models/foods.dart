import 'dart:convert';

import 'package:flutter/material.dart';

List<Food> foodFromJson(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

class Food {
    final String id;
    final String title;
    final List<String> foodTags;
    final List<String?> foodType;
    final String? code;
    final bool? isAvailable;
    final String? restaurant;
    final double? rating;
    final String? ratingCount;
    final String description;
    final int? stocks;
    final double price;
    //final List<Additive> additives;
    final List<String> imageUrl;
    final int? v;
    final String? category;
    final String? time;
    final List<CustomAdditives> customAdditives;

    Food({
        required this.id,
        required this.title,
        required this.foodTags,
        required this.foodType,
        this.code,
        this.isAvailable,
        this.restaurant,
        this.rating,
        this.ratingCount,
        required this.description,
        this.stocks,
        required this.price,
        //required this.additives,
        required this.imageUrl,
        this.v,
        this.category,
        this.time,
        required this.customAdditives,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["_id"] ?? '', // Ensure id is provided or set to a default
        title: json["title"] ?? '',
        foodTags: List<String>.from(json["foodTags"]?.map((x) => x) ?? []),
        foodType: List<String?>.from(json["foodType"]?.map((x) => x) ?? []),
        code: json["code"],
        isAvailable: json["isAvailable"],
        restaurant: json["restaurant"],
        rating: json["rating"]?.toDouble(),
        ratingCount: json["ratingCount"],
        description: json["description"] ?? '',
        stocks: json["stocks"],
        price: (json["price"] ?? 0).toDouble(), // Set a default or fallback
        //additives: List<Additive>.from(json["additives"]?.map((x) => Additive.fromJson(x)) ?? []),
        imageUrl: List<String>.from(json["imageUrl"]?.map((x) => x) ?? []),
        v: json["__v"],
        category: json["category"],
        time: json["time"],
        customAdditives: List<CustomAdditives>.from(json['customAdditives']?.map((x) => CustomAdditives.fromMap(x)) ?? []),
    );
}


class Additive {
    final int id;
    final String title;
    final String price;

    Additive({
        required this.id,
        required this.title,
        required this.price,
    });

    factory Additive.fromJson(Map<String, dynamic> json) => Additive(
        id: json["id"],
        title: json["title"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
    };
}

class CustomAdditives {
    final int id;
    final String text;
    final String? type;
    final List<Options>? options;
    final double? linearScale;
    final double? minScale;
    final double? maxScale;
    final String? minScaleLabel;
    final String? maxScaleLabel;
    final bool required;
    final String? selectionType;
    final int? selectionNumber;
    final String? customErrorMessage;

    CustomAdditives({
        required this.id,
        required this.text,
        this.type,
        this.options,
        this.linearScale,
        this.minScale,
        this.maxScale,
        this.minScaleLabel,
        this.maxScaleLabel,
        this.required = false,
        this.selectionType,
        this.selectionNumber,
        this.customErrorMessage,
    });

    // Override toString method
    @override
    String toString() {
        String optionsString = options != null
            ? options!.map((option) => option.toString()).join(', ')
            : 'No options';

        return 'CustomAdditives(id: $id, text: $text, type: $type, options: [$optionsString], linearScale: $linearScale, minScale: $minScale, maxScale: $maxScale, minScaleLabel: $minScaleLabel, maxScaleLabel: $maxScaleLabel, required: $required, selectionType: $selectionType, selectionNumber: $selectionNumber, customErrorMessage: $customErrorMessage)';
    }

    Map<String, dynamic> toMap() {
        return {
            "id": id,
            'text': text,
            'type': type,
            'options': options?.map((option) => option.toJson()).toList(),
            'linearScale': linearScale ?? 0,
            'minScale': minScale ?? 0,
            'maxScale': maxScale ?? 0,
            'minScaleLabel': minScaleLabel ?? '',
            'maxScaleLabel': maxScaleLabel ?? '',
            'required': required,
            'selectionType': selectionType ?? '',
            'selectionNumber': selectionNumber ?? 0,
            'customErrorMessage': customErrorMessage ?? '',
        };
    }

    static CustomAdditives fromMap(Map<String, dynamic> map) {
        return CustomAdditives(
            id: map["id"],
            text: map['text'],
            type: map['type'],
            options: map['options'] != null
                ? List<Options>.from(map['options'].map((x) => Options.fromJson(x)))
                : null,
            linearScale: map['linearScale']?.toDouble(),
            minScale: map['minScale']?.toDouble(),
            maxScale: map['maxScale']?.toDouble(),
            minScaleLabel: map['minScaleLabel'],
            maxScaleLabel: map['maxScaleLabel'],
            required: map['required'],
            selectionType: map['selectionType'],
            selectionNumber: map['selectionNumber'],
            customErrorMessage: map['customErrorMessage'],
        );
    }

    String toJson() {
        return jsonEncode(toMap());
    }

    static CustomAdditives fromJson(String jsonString) {
        final Map<String, dynamic> data = jsonDecode(jsonString);
        return fromMap(data);
    }
}

class Options {
    String optionName;
    String? price;
    TextEditingController? optionNameController;
    TextEditingController? priceController;

    Options({
        required this.optionName,
        required this.price,
        this.optionNameController,
        this.priceController,
    });

    factory Options.fromJson(Map<String, dynamic> json) =>
        Options(
            optionName: json["optionName"],
            price: json["price"],
        );

    Map<String, dynamic> toJson() =>
        {
            "optionName": optionName,
            "price": price,
        };

}