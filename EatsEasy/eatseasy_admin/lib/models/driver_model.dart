// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
    final List<DriverElement> drivers;
    final int currentPage;
    final int totalPages;

    Driver({
        required this.drivers,
        required this.currentPage,
        required this.totalPages,
    });

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        drivers: List<DriverElement>.from(json["drivers"].map((x) => DriverElement.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "drivers": List<dynamic>.from(drivers.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
    };
}

class DriverElement {
    final CurrentLocation currentLocation;
    final String id;
    final DriverDriver driver;
    final String vehicleType;
    final String vehicleName;
    final String licenseNumber;
    final String licenseExpireDate;
    final String driverLicenseUrl;
    final String nbiClearanceUrl;
    final String phone;
    final String vehicleNumber;
    final bool isAvailable;
    final int rating;
    final int totalDeliveries;
    final String profileImage;
    final bool isActive;
    final String verification;
    final String verificationMessage;

    DriverElement({
        required this.currentLocation,
        required this.id,
        required this.driver,
        required this.vehicleType,
        required this.vehicleName,
        required this.licenseNumber,
        required this.licenseExpireDate,
        required this.driverLicenseUrl,
        required this.nbiClearanceUrl,
        required this.phone,
        required this.vehicleNumber,
        required this.isAvailable,
        required this.rating,
        required this.totalDeliveries,
        required this.profileImage,
        required this.isActive,
        required this.verification,
        required this.verificationMessage,
    });

    factory DriverElement.fromJson(Map<String, dynamic> json) => DriverElement(
        currentLocation: CurrentLocation.fromJson(json["currentLocation"]),
        id: json["_id"],
        driver: DriverDriver.fromJson(json["driver"]),
        vehicleType: json["vehicleType"],
        vehicleName: json["vehicleName"],
        licenseNumber: json["licenseNumber"],
        licenseExpireDate: json["licenseExpireDate"],
        driverLicenseUrl: json["driverLicenseUrl"],
        nbiClearanceUrl: json["nbiClearanceUrl"],
        phone: json["phone"],
        vehicleNumber: json["vehicleNumber"],
        isAvailable: json["isAvailable"],
        rating: json["rating"],
        totalDeliveries: json["totalDeliveries"],
        profileImage: json["profileImage"],
        isActive: json["isActive"],
        verification: json["verification"],
        verificationMessage: json["verificationMessage"],
    );

    Map<String, dynamic> toJson() => {
        "currentLocation": currentLocation.toJson(),
        "_id": id,
        "driver": driver.toJson(),
        "vehicleType": vehicleType,
        "vehicleName": vehicleName,
        "licenseNumber": licenseNumber,
        "licenseExpireDate": licenseExpireDate,
        "driverLicenseUrl": driverLicenseUrl,
        "nbiClearanceUrl": nbiClearanceUrl,
        "phone": phone,
        "vehicleNumber": vehicleNumber,
        "isAvailable": isAvailable,
        "rating": rating,
        "totalDeliveries": totalDeliveries,
        "profileImage": profileImage,
        "isActive": isActive,
        "verification": verification,
        "verificationMessage": verificationMessage,
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

class DriverDriver {
    final String? id;
    final String? username;
    final String? fcm;

    DriverDriver({
        required this.id,
        required this.username,
        required this.fcm,
    });

    factory DriverDriver.fromJson(Map<String, dynamic> json) => DriverDriver(
        id: json["_id"],
        username: json["username"],
        fcm: json["fcm"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "fcm": fcm,
    };
}
