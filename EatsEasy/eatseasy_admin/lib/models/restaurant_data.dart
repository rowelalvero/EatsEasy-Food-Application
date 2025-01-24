
import 'dart:convert';

RestaurantData restaurantDataFromJson(String str) => RestaurantData.fromJson(json.decode(str));


class RestaurantData {
    final Data data;
    final int ordersTotal;
    final int cancelledOrders;
    final double revenueTotal;
    final int processingOrders;
    final RestaurantToken restaurantToken;

    RestaurantData({
        required this.data,
        required this.ordersTotal,
        required this.cancelledOrders,
        required this.revenueTotal,
        required this.processingOrders,
        required this.restaurantToken,
    });

    factory RestaurantData.fromJson(Map<String, dynamic> json) => RestaurantData(
        data: Data.fromJson(json["data"]),
        ordersTotal: json["ordersTotal"],
        cancelledOrders: json["cancelledOrders"],
        revenueTotal: json["revenueTotal"]?.toDouble(),
        processingOrders: json["processingOrders"],
        restaurantToken: RestaurantToken.fromJson(json["restaurantToken"]),
    );

}

class Data {
    final String id;
    final String title;
    final String time;
    final String imageUrl;
    final String image1Url;
    final String image2Url;
    final String phoneNumber;
    final String ownerName;
    final String owner;
    final String code;
    final bool isAvailable;
    final bool pickup;
    final bool delivery;
    final List<dynamic> foods;
    final String logoUrl;
    final int rating;
    final String ratingCount;
    final String verification;
    final String verificationMessage;
    final double earnings;
    final Coords coords;

    Data({
        required this.id,
        required this.title,
        required this.time,
        required this.imageUrl,
        required this.image1Url,
        required this.image2Url,
        required this.phoneNumber,
        required this.ownerName,
        required this.owner,
        required this.code,
        required this.isAvailable,
        required this.pickup,
        required this.delivery,
        required this.foods,
        required this.logoUrl,
        required this.rating,
        required this.ratingCount,
        required this.verification,
        required this.verificationMessage,
        required this.earnings,
        required this.coords,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        image1Url: json["image1Url"],
        image2Url: json["image2Url"],
        phoneNumber: json["phoneNumber"],
        ownerName: json["ownerName"],
        owner: json["owner"],
        code: json["code"],
        isAvailable: json["isAvailable"],
        pickup: json["pickup"],
        delivery: json["delivery"],
        foods: List<dynamic>.from(json["foods"].map((x) => x)),
        logoUrl: json["logoUrl"],
        rating: json["rating"],
        ratingCount: json["ratingCount"],
        verification: json["verification"],
        verificationMessage: json["verificationMessage"],
        earnings: json["earnings"].toDouble(),
        coords: Coords.fromJson(json["coords"]),
    );

}

class RestaurantToken {
    final String id;
    final String fcm;

    RestaurantToken({
        required this.id,
        required this.fcm,
    });

    factory RestaurantToken.fromJson(Map<String, dynamic> json) => RestaurantToken(
        id: json["_id"],
        fcm: json["fcm"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "fcm": fcm,
    };
}

class Coords {
    final String id;
    final double latitude;
    final double longitude;
    final String address;
    final String title;
    final double? latitudeDelta;
    final double? longitudeDelta;

    Coords({
        required this.id,
        required this.latitude,
        required this.longitude,
        required this.address,
        required this.title,
        this.latitudeDelta,
        this.longitudeDelta,
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
