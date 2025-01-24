// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eatseasy/models/wallet_top_up.dart';

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
    final String? userToken; // Made nullable
    final String? validIdUrl;
    final String? proofOfResidenceUrl;
    final double? walletBalance;
    final List<WalletTransactions>? walletTransactions;

    LoginResponse({
        required this.id,
        required this.username,
        required this.email,
        required this.verification,
        required this.phone,
        required this.phoneVerification,
        required this.userType,
        required this.profile,
        this.userToken, // Adjusted to accept nullable values
        required this.validIdUrl,
        required this.proofOfResidenceUrl,
        required this.walletBalance,
        required this.walletTransactions,
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
        userToken: json["userToken"], // Handles null values
        validIdUrl: json["validIdUrl"],
        proofOfResidenceUrl: json["proofOfResidenceUrl"],
        walletBalance: json["walletBalance"]?.toDouble(),
        walletTransactions: json["walletTransactions"] == null
            ? null
            : List<WalletTransactions>.from(
            json["walletTransactions"].map((x) => WalletTransactions.fromJson(x))),
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
        "userToken": userToken, // Handles null values
        "validIdUrl": validIdUrl,
        "proofOfResidenceUrl": proofOfResidenceUrl,
        "walletBalance": walletBalance,
        "walletTransactions": walletTransactions
            ?.map((x) => x.toJson())
            .toList(), // Safely handles null `walletTransactions`
    };
}

