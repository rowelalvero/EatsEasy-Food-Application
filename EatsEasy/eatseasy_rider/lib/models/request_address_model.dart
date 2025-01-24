
import 'dart:convert';

AddressRequest addressRequestFromJson(String str) => AddressRequest.fromJson(json.decode(str));

String addressRequestToJson(AddressRequest data) => json.encode(data.toJson());

class AddressRequest {
  final String addressLine1;
  final String postalCode;
  final bool addressRequestDefault;
  final String deliveryInstructions;
  final double latitude;
  final double longitude;

  AddressRequest({
    required this.addressLine1,
    required this.postalCode,
    required this.addressRequestDefault,
    required this.deliveryInstructions,
    required this.latitude,
    required this.longitude,
  });

  factory AddressRequest.fromJson(Map<String, dynamic> json) => AddressRequest(
    addressLine1: json["addressLine1"],
    postalCode: json["postalCode"],
    addressRequestDefault: json["default"],
    deliveryInstructions: json["deliveryInstructions"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "addressLine1": addressLine1,
    "postalCode": postalCode,
    "default": addressRequestDefault,
    "deliveryInstructions": deliveryInstructions,
    "latitude": latitude,
    "longitude": longitude,
  };
}
