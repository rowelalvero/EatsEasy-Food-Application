
import 'dart:convert';

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
    final List<Category> categories;
    final int currentPage;
    final int totalPages;

    Categories({
        required this.categories,
        required this.currentPage,
        required this.totalPages,
    });

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
    };
}

class Category {
    final String id;
    final String title;
    final String value;
    final String imageUrl;

    Category({
        required this.id,
        required this.title,
        required this.value,
        required this.imageUrl,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        title: json["title"],
        value: json["value"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "value": value,
        "imageUrl": imageUrl,
    };
}
