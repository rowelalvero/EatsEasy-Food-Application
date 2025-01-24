// To parse this JSON data, do
//
//     final restaurantRequest = restaurantRequestFromJson(jsonString);

import 'dart:convert';

RestaurantRequest restaurantRequestFromJson(String str) => RestaurantRequest.fromJson(json.decode(str));

String restaurantRequestToJson(RestaurantRequest data) => json.encode(data.toJson());

class RestaurantRequest {
    final String title;
    final String time;
    final String? owner;
    final String code;
    final String logoUrl;
    final String imageUrl;
    final String? ownerName;
    final String phoneNumber;
    final bool? phoneVerification;
    final String? image1Url;
    final String? image2Url;
    final Coords coords;

    RestaurantRequest({
        required this.title,
        required this.time,
        this.owner,
        required this.code,
        required this.logoUrl,
        required this.imageUrl,
        required this.coords,
        this.image1Url,
        this.image2Url,
        this.ownerName,
        this.phoneVerification,
        required this.phoneNumber,
    });

    factory RestaurantRequest.fromJson(Map<String, dynamic> json) => RestaurantRequest(
        title: json["title"],
        time: json["time"],
        owner: json["owner"],
        code: json["code"],
        logoUrl: json["logoUrl"],
        imageUrl: json["imageUrl"],
        ownerName: json["ownerName"],
        phoneVerification: json["phoneVerification"],
        phoneNumber: json["phoneNumber"],
        image1Url: json["image1Url"],
        image2Url: json["image2Url"],
        coords: Coords.fromJson(json["coords"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "time": time,
        "owner": owner,
        "code": code,
        "logoUrl": logoUrl,
        "imageUrl": imageUrl,
        "ownerName": ownerName,
        "phoneVerification": phoneVerification,
        "phoneNumber": phoneNumber,
        "image1Url": image1Url,
        "image2Url": image2Url,
        "coords": coords.toJson(),
    };
}

class Coords {
    final int id;
    final double latitude;
    final double longitude;
    final String address;
    final String title;

    Coords({
        required this.id,
        required this.latitude,
        required this.longitude,
        required this.address,
        required this.title,
    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,
    };
}
