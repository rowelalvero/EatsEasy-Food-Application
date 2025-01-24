// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';

ChangePassword changePasswordFromJson(String str) => ChangePassword.fromJson(json.decode(str));

String changePasswordToJson(ChangePassword data) => json.encode(data.toJson());

class ChangePassword {
  final String password;
  final String email;

  ChangePassword({
    required this.password,
    required this.email,
  });

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
    password: json["password"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "password": password,
    "email": email,
  };
}
