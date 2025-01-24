// To parse this JSON data, do
//
//     final feedbackModel = feedbackModelFromJson(jsonString);

import 'dart:convert';

FeedbackModel feedbackModelFromJson(String str) => FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

class FeedbackModel {
    final List<Feedbackx> feedbackx;
    final int currentPage;
    final int totalPages;

    FeedbackModel({
        required this.feedbackx,
        required this.currentPage,
        required this.totalPages,
    });

    factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        feedbackx: List<Feedbackx>.from(json["feedbackx"].map((x) => Feedbackx.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "feedbackx": List<dynamic>.from(feedbackx.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
    };
}

class Feedbackx {
    final String id;
    final String userId;
    final String message;
    final String imageUrl;
    final DateTime createdAt;

    Feedbackx({
        required this.id,
        required this.userId,
        required this.message,
        required this.imageUrl,
        required this.createdAt,
    });

    factory Feedbackx.fromJson(Map<String, dynamic> json) => Feedbackx(
        id: json["_id"],
        userId: json["userId"],
        message: json["message"],
        imageUrl: json["imageUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "message": message,
        "imageUrl": imageUrl,
        "createdAt": createdAt.toIso8601String(),
    };
}
