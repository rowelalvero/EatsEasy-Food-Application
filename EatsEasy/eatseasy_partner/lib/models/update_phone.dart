// To parse this JSON data, do
//
//     final registration = registrationFromJson(jsonString);

import 'dart:convert';

UpdatePhone updateProfileFromJson(String str) => UpdatePhone.fromJson(json.decode(str));

String updatePhoneToJson(UpdatePhone data) => json.encode(data.toJson());

class UpdatePhone {
  final String phone;

  UpdatePhone({
    required this.phone,
  });

  factory UpdatePhone.fromJson(Map<String, dynamic> json) => UpdatePhone(
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
  };
}
