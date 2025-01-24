// To parse this JSON data, do
//
//     final userCart = userCartFromJson(jsonString);

import 'dart:convert';

List<UserCart> userCartFromJson(String str) => List<UserCart>.from(json.decode(str).map((x) => UserCart.fromJson(x)));

String userCartToJson(List<UserCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserCart {
    final String id;
    final String userId;
    final ProductId productId;
    final List<String> additives;
    final String instructions;
    final double totalPrice;
    final int quantity;

    UserCart({
        required this.id,
        required this.userId,
        required this.productId,
        required this.additives,
        required this.instructions,
        required this.totalPrice,
        required this.quantity,
    });

    factory UserCart.fromJson(Map<String, dynamic> json) => UserCart(
        id: json["_id"],
        userId: json["userId"],
        productId: ProductId.fromJson(json["productId"]),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instructions: json["instructions"],
        totalPrice: json["totalPrice"]?.toDouble(),
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "productId": productId.toJson(),
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instructions": instructions,
        "totalPrice": totalPrice,
        "quantity": quantity,
    };
}

class ProductId {
    final String id;
    final String title;
    final Restaurant restaurant;
    final double rating;
    final String ratingCount;
    final List<String> imageUrl;

    ProductId({
        required this.id,
        required this.title,
        required this.restaurant,
        required this.rating,
        required this.ratingCount,
        required this.imageUrl,
    });

    factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        title: json["title"],
        restaurant: Restaurant.fromJson(json["restaurant"]),
        rating: json["rating"]?.toDouble(),
        ratingCount: json["ratingCount"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "restaurant": restaurant.toJson(),
        "rating": rating,
        "ratingCount": ratingCount,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
    };
}

class Restaurant {
    final Coords coords;
    final String id;
    final String time;

    Restaurant({
        required this.coords,
        required this.id,
        required this.time,
    });

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        coords: Coords.fromJson(json["coords"]),
        id: json["_id"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "coords": coords.toJson(),
        "_id": id,
        "time": time,
    };
}

class Coords {
    final String id;
    final double latitude;
    final double longitude;
    final String address;
    final String title;
    final double latitudeDelta;
    final double longitudeDelta;

    Coords({
        required this.id,
        required this.latitude,
        required this.longitude,
        required this.address,
        required this.title,
        required this.latitudeDelta,
        required this.longitudeDelta,
    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        title: json["title"],
        latitudeDelta: json["latitudeDelta"]?.toDouble(),
        longitudeDelta: json["longitudeDelta"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,
        "latitudeDelta": latitudeDelta,
        "longitudeDelta": longitudeDelta,
    };
}
