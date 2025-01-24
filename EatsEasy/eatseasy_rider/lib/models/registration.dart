// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';

Registration registrationFromJson(String str) => Registration.fromJson(json.decode(str));

String registrationToJson(Registration data) => json.encode(data.toJson());

class Registration {
    final String username;
    final String email;
    final String password;
    final String phone;
    final bool phoneVerification;

    Registration({
        required this.username,
        required this.email,
        required this.password,
        required this.phone,
        required this.phoneVerification,
    });

    factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        username: json["username"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        phoneVerification: json["phoneVerification"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "phone": phone,
        "phoneVerification": phoneVerification,
    };
}
