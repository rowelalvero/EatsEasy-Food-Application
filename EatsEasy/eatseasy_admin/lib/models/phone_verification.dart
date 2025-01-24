// To parse this JSON data, do
//
//     final phoneVerificationData = phoneVerificationDataFromJson(jsonString);

import 'dart:convert';

PhoneVerificationData phoneVerificationDataFromJson(String str) => PhoneVerificationData.fromJson(json.decode(str));

String phoneVerificationDataToJson(PhoneVerificationData data) => json.encode(data.toJson());

class PhoneVerificationData {
    final bool phoneVerification;

    PhoneVerificationData({
        required this.phoneVerification,
    });

    factory PhoneVerificationData.fromJson(Map<String, dynamic> json) => PhoneVerificationData(
        phoneVerification: json["phoneVerification"],
    );

    Map<String, dynamic> toJson() => {
        "phoneVerification": phoneVerification,
    };
}
