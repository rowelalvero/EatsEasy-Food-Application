import 'dart:convert';

String addCategoryModelToJson(AddCategoryModel data) => json.encode(data.toJson());

class AddCategoryModel {
    final String title;
    final String value;
    final String imageUrl;

    AddCategoryModel({
        required this.title,
        required this.value,
        required this.imageUrl,
    });

    Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "imageUrl": imageUrl,
    };
}
