import 'dart:convert';

String driverRegistrationRequestToJson(DriverRegistrationRequest data) => json.encode(data.toJson());

class DriverRegistrationRequest {
    final String username;
    final String vehicleType;
    final String phone;
    final bool? phoneVerification;
    final String vehicleNumber;
    final String vehicleName;
    final String licenseNumber;
    final String? licenseExpireDate;
    final String driverLicenseUrl;
    final String nbiClearanceUrl;
    final double latitude;
    final double longitude;
    final String profileImage;

    DriverRegistrationRequest({
        required this.username,
        required this.vehicleType,
        required this.phone,
        this.phoneVerification,
        required this.vehicleNumber,
        required this.latitude,
        required this.longitude,
        required this.driverLicenseUrl,
        required this.nbiClearanceUrl,
        required this.vehicleName,
        required this.licenseNumber,
        this.licenseExpireDate,
        required this.profileImage,
    });

    Map<String, dynamic> toJson() => {
        "username": username,
        "vehicleType": vehicleType,
        "phone": phone,
        "phoneVerification": phoneVerification,
        "vehicleNumber": vehicleNumber,
        "vehicleName": vehicleName,
        "licenseNumber": licenseNumber,
        "licenseExpireDate": licenseExpireDate,
        "driverLicenseUrl": driverLicenseUrl,
        "nbiClearanceUrl": nbiClearanceUrl,
        "latitude": latitude,
        "longitude": longitude,
        "profileImage": profileImage,
    };
}
