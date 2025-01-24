
import 'dart:convert';

import 'package:eatseasy_rider/models/wallet_top_up.dart';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
    final CurrentLocation currentLocation;
    final double walletBalance;
    final List<WalletTransactions> walletTransactions; // Changed to List<WalletTransactions>
    final String verification;
    final String verificationMessage;
    final String id;
    final String vehicleType;
    final String phone;
    final String vehicleNumber;

    final String vehicleName;
    final String licenseNumber;
    final String licenseExpireDate;

    final bool isAvailable;
    final int rating;
    final int totalDeliveries;
    final String profileImage;
    final String nbiClearanceUrl;
    final String driverLicenseUrl;
    final bool isActive;

    Driver({
        required this.currentLocation,
        required this.walletBalance,
        required this.walletTransactions, // Now a list of transactions
        required this.verification,
        required this.verificationMessage,
        required this.id,
        required this.vehicleType,
        required this.phone,
        required this.vehicleNumber,
        required this.isAvailable,
        required this.rating,
        required this.totalDeliveries,
        required this.profileImage,
        required this.nbiClearanceUrl,
        required this.driverLicenseUrl,
        required this.isActive,
        required this.vehicleName,
        required this.licenseNumber,
        required this.licenseExpireDate,
    });

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        currentLocation: CurrentLocation.fromJson(json["currentLocation"]),
        walletBalance: json["walletBalance"].toDouble(),
        walletTransactions: List<WalletTransactions>.from(
            json["walletTransactions"].map((x) => WalletTransactions.fromJson(x))),
        verification: json["verification"],
        verificationMessage: json["verificationMessage"],
        id: json["_id"],
        vehicleType: json["vehicleType"],
        phone: json["phone"],
        vehicleNumber: json["vehicleNumber"],
        vehicleName: json["vehicleName"],
        licenseNumber: json["licenseNumber"],
        licenseExpireDate: json["licenseExpireDate"],
        isAvailable: json["isAvailable"],
        rating: json["rating"],
        totalDeliveries: json["totalDeliveries"],
        profileImage: json["profileImage"],
        nbiClearanceUrl: json["nbiClearanceUrl"],
        driverLicenseUrl: json["driverLicenseUrl"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "currentLocation": currentLocation.toJson(),
        "walletBalance": walletBalance,
        "walletTransactions":
        List<dynamic>.from(walletTransactions.map((x) => x.toJson())),
        "verification": verification,
        "verificationMessage": verificationMessage,
        "_id": id,
        "vehicleType": vehicleType,
        "phone": phone,
        "vehicleNumber": vehicleNumber,
        "vehicleName": vehicleName,
        "licenseNumber": licenseNumber,
        "licenseExpireDate": licenseExpireDate,
        "isAvailable": isAvailable,
        "rating": rating,
        "totalDeliveries": totalDeliveries,
        "profileImage": profileImage,
        "nbiClearanceUrl": nbiClearanceUrl,
        "driverLicenseUrl": driverLicenseUrl,
        "isActive": isActive,
    };
}


class CurrentLocation {
    final double latitude;
    final double longitude;

    CurrentLocation({
        required this.latitude,
        required this.longitude,
    });

    factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class UserId {
    final String id;
    final String phone;
    final String profile;
    final String username;

    UserId({
        required this.id,
        required this.phone,
        required this.profile,
        required this.username,
    });

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        phone: json["phone"],
        profile: json["profile"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "profile": profile,
        "username": username,
    };
}