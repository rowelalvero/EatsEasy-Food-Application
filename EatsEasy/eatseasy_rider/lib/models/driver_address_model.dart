
import 'dart:convert';

List<AddressesList> addressesListFromJson(String str) => List<AddressesList>.from(json.decode(str).map((x) => AddressesList.fromJson(x)));

String addressesListToJson(List<AddressesList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressesList {
  final String id;
  final String userId;
  final String addressLine1;
  final String postalCode;
  final bool addressesListDefault;
  final String deliveryInstructions;
  final double latitude;
  final double longitude;

  AddressesList({
    required this.id,
    required this.userId,
    required this.addressLine1,
    required this.postalCode,
    required this.addressesListDefault,
    required this.deliveryInstructions,
    required this.latitude,
    required this.longitude,
  });

  factory AddressesList.fromJson(Map<String, dynamic> json) => AddressesList(
    id: json["_id"],
    userId: json["userId"],
    addressLine1: json["addressLine1"],
    postalCode: json["postalCode"],
    addressesListDefault: json["default"],
    deliveryInstructions: json["deliveryInstructions"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "addressLine1": addressLine1,
    "postalCode": postalCode,
    "default": addressesListDefault,
    "deliveryInstructions": deliveryInstructions,
    "latitude": latitude,
    "longitude": longitude,
  };
}
