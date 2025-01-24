import 'dart:convert';

Restaurants restaurantsFromJson(String str) => Restaurants.fromJson(json.decode(str));


class Restaurants {
    final List<Restaurant> restaurants;
    final int currentPage;
    final int totalPages;

    Restaurants({
        required this.restaurants,
        required this.currentPage,
        required this.totalPages,
    });

    factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
    );

}

class Restaurant {
    final Coords coords;
    final String id;
    final String title;
    final String time;
    final bool isAvailable;
    final String logoUrl;
    final double rating;
    final String ratingCount;

    Restaurant({
        required this.coords,
        required this.id,
        required this.title,
        required this.time,
        required this.isAvailable,
        required this.logoUrl,
        required this.rating,
        required this.ratingCount,
    });

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        coords: Coords.fromJson(json["coords"]),
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        isAvailable: json["isAvailable"],
        logoUrl: json["logoUrl"],
        rating: json["rating"].toDouble(),
        ratingCount: json["ratingCount"],
    );

}

class Coords {
    final String address;

    Coords({
        required this.address,
    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        address: json["address"],
    );

}
