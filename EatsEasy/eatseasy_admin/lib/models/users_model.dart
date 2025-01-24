// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
    final List<User> users;
    final int currentPage;
    final int totalPages;

    Users({
        required this.users,
        required this.currentPage,
        required this.totalPages,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
    };
}

class User {
    final String id;
    final String username;
    final String email;
    final String fcm;
    final String otp;
    final bool verification;
    final String phone;
    final bool phoneVerification;
    final String userType;
    final String profile;
    final String? validIdUrl;
    final String? proofOfResidenceUrl;

    User({
        required this.id,
        required this.username,
        required this.email,
        required this.fcm,
        required this.otp,
        required this.verification,
        required this.phone,
        required this.phoneVerification,
        required this.userType,
        required this.profile,
        this.validIdUrl,
        this.proofOfResidenceUrl,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        fcm: json["fcm"],
        otp: json["otp"],
        verification: json["verification"],
        phone: json["phone"],
        phoneVerification: json["phoneVerification"],
        userType: json["userType"],
        profile: json["profile"],
        validIdUrl: json["validIdUrl"],
        proofOfResidenceUrl: json["proofOfResidenceUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "fcm": fcm,
        "otp": otp,
        "verification": verification,
        "phone": phone,
        "phoneVerification": phoneVerification,
        "userType": userType,
        "profile": profile,
        "validIdUrl": validIdUrl,
        "proofOfResidenceUrl": proofOfResidenceUrl,
    };
}
