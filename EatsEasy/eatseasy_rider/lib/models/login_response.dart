// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    final String id;
    final String username;
    final String email;
    final bool verification;
    final String phone;
    final bool phoneVerification;
    final String userType;
    final String profile;
    final String userToken;
    final String? validIdUrl;
    final String? proofOfResidenceUrl;

    LoginResponse({
        required this.id,
        required this.username,
        required this.email,
        required this.verification,
        required this.phone,
        required this.phoneVerification,
        required this.userType,
        required this.profile,
        required this.userToken,
        required this.validIdUrl,
        required this.proofOfResidenceUrl,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        verification: json["verification"],
        phone: json["phone"],
        phoneVerification: json["phoneVerification"],
        userType: json["userType"],
        profile: json["profile"],
        userToken: json["userToken"],
        validIdUrl: json["validIdUrl"],
        proofOfResidenceUrl: json["proofOfResidenceUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "verification": verification,
        "phone": phone,
        "phoneVerification": phoneVerification,
        "userType": userType,
        "profile": profile,
        "userToken": userToken,
        "validIdUrl": validIdUrl,
        "proofOfResidenceUrl": proofOfResidenceUrl,
    };
}
