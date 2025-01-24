// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';

UpdatePhoneUser updatePhoneUserFromJson(String str) => UpdatePhoneUser.fromJson(json.decode(str));

String updatePhoneUserToJson(UpdatePhoneUser data) => json.encode(data.toJson());

class UpdatePhoneUser {
  final String phone;
  final bool phoneVerification;

  UpdatePhoneUser({
    required this.phone,
    required this.phoneVerification,
  });

  factory UpdatePhoneUser.fromJson(Map<String, dynamic> json) => UpdatePhoneUser(
    phone: json["phone"],
    phoneVerification: json["phoneVerification"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "phoneVerification": phoneVerification,
  };
}
