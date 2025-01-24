import 'dart:convert';

FeedbackModel feedbackModelFromJson(String str) => FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

class FeedbackModel {
    final String message;
    final String imageUrl;

    FeedbackModel({
        required this.message,
        required this.imageUrl,
    });

    factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        message: json["message"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "imageUrl": imageUrl,
    };
}
