// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';

UpdateProfile updateProfileFromJson(String str) => UpdateProfile.fromJson(json.decode(str));

String updateProfileToJson(UpdateProfile data) => json.encode(data.toJson());

class UpdateProfile {
  final String phone;
  final bool phoneVerification;

  UpdateProfile({
    required this.phone,
    required this.phoneVerification,
  });

  factory UpdateProfile.fromJson(Map<String, dynamic> json) => UpdateProfile(
    phone: json["phone"],
    phoneVerification: json["phoneVerification"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "phoneVerification": phoneVerification
  };
}
