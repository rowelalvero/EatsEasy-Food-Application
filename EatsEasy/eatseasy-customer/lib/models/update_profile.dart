// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';

UpdateProfile updateProfileFromJson(String str) => UpdateProfile.fromJson(json.decode(str));

String updateProfileToJson(UpdateProfile data) => json.encode(data.toJson());

class UpdateProfile {
  final String email;
  final String username;
  final String proofOfResidenceUrl;
  final String phone;
  final bool phoneVerification;
  final String profile;

  UpdateProfile({
    required this.proofOfResidenceUrl,
    required this.username,
    required this.email,
    required this.phone,
    required this.phoneVerification,
    required this.profile,
  });

  factory UpdateProfile.fromJson(Map<String, dynamic> json) => UpdateProfile(
    proofOfResidenceUrl: json["proofOfResidenceUrl"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    phoneVerification: json["phoneVerification"],
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "proofOfResidenceUrl": proofOfResidenceUrl,
    "username": username,
    "email": email,
    "phone": phone,
    "phoneVerification": phoneVerification,
    "profile": profile
  };
}
