// To parse this JSON data, do
//
//     final readyOrders = readyOrdersFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<ReadyOrders> readyOrdersFromJson(String str) => List<ReadyOrders>.from(
    json.decode(str).map((x) => ReadyOrders.fromJson(x)));

String readyOrdersToJson(List<ReadyOrders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReadyOrders {
  final String id;
  final UserId userId;
  final List<OrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final String deliveryOption;
  final DeliveryAddress deliveryAddress;
  // Make orderStatus observable
  final RxString orderStatus;
  final RxString driverStatus;
  final String paymentMethod;
  final RestaurantId restaurantId;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final String? driverId;
  final String? orderDate;

  ReadyOrders({
    required this.id,
    required this.userId,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.deliveryAddress,
    required String orderStatus,
    required String driverStatus,
    required this.restaurantId,
    required this.restaurantCoords,
    required this.recipientCoords,
    required this.driverId,
    required this.orderDate,
  }) : orderStatus = RxString(orderStatus), driverStatus = RxString(driverStatus);

  void updateOrderStatus(String newStatus) {
    orderStatus.value = newStatus;
  }

  factory ReadyOrders.fromJson(Map<String, dynamic> json) => ReadyOrders(
        id: json["_id"],
        userId: UserId.fromJson(json["userId"]),
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"]?.toDouble(),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        orderStatus: json["orderStatus"],
        deliveryOption: json["deliveryOption"],
        driverStatus: json["driverStatus"],
        deliveryAddress: DeliveryAddress.fromJson(json["deliveryAddress"]),
        paymentMethod: json["paymentMethod"],
        restaurantId: RestaurantId.fromJson(json["restaurantId"]),
        restaurantCoords: List<double>.from(
            json["restaurantCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(
            json["recipientCoords"].map((x) => x?.toDouble())),
        driverId: json["driverId"],
        orderDate: json["orderDate"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId.toJson(),
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "deliveryFee": deliveryFee,
        "deliveryOption": deliveryOption,
        "paymentMethod": paymentMethod,
        "deliveryAddress": deliveryAddress.toJson(),
        "orderStatus": orderStatus.value,
        "driverStatus": driverStatus.value,
        "restaurantId": restaurantId.toJson(),
        "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
        "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
        "driverId": driverId,
        "orderDate": orderDate
      };
}

class DeliveryAddress {
  final String id;
  final String addressLine1;
  final String deliveryInstructions;

  DeliveryAddress({
    required this.id,
    required this.addressLine1,
    required this.deliveryInstructions,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json["_id"],
        addressLine1: json["addressLine1"],
        deliveryInstructions: json["deliveryInstructions"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "addressLine1": addressLine1,
        "deliveryInstructions": deliveryInstructions
      };
}

class OrderItem {
  final FoodId foodId;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instructions;
  final String id;
  final Map<String, dynamic> customAdditives;

  OrderItem({
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instructions,
    required this.id,
    required this.customAdditives,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: FoodId.fromJson(json["foodId"]),
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instructions: json["instructions"],
        id: json["_id"],
        customAdditives: Map<String, dynamic>.from(json["customAdditives"]),
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId.toJson(),
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instructions": instructions,
        "_id": id,
        "customAdditives": customAdditives,
      };
}

class FoodId {
    final String id;
    final String title;
    final List<String> imageUrl;
    final String time;

    FoodId({
        required this.id,
        required this.title,
        required this.imageUrl,
        required this.time,
    });

    factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json["_id"],
        title: json["title"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "time": time,
    };
}

class RestaurantId {
    final Coords coords;
    final String id;
    final String title;
    final String time;
    final String imageUrl;
    final String logoUrl;

    RestaurantId({
        required this.coords,
        required this.id,
        required this.title,
        required this.time,
        required this.imageUrl,
        required this.logoUrl,
    });

    factory RestaurantId.fromJson(Map<String, dynamic> json) => RestaurantId(
        coords: Coords.fromJson(json["coords"]),
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        logoUrl: json["logoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "coords": coords.toJson(),
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "logoUrl": logoUrl,
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

class UserId {
  String id;
  String phone;
  String profile;
  String username;
  String? proofOfResidenceUrl;

  UserId({
    required this.id,
    required this.phone,
    required this.profile,
    required this.username,
    this.proofOfResidenceUrl,
  });

  UserId copyWith({
    String? id,
    String? phone,
    String? profile,
    String? username,
    String? proofOfResidenceUrl,
  }) {
    return UserId(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      profile: profile ?? this.profile,
      username: username ?? this.username,
      proofOfResidenceUrl: proofOfResidenceUrl ?? this.proofOfResidenceUrl,
    );
  }

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    phone: json["phone"],
    profile: json["profile"],
    username: json["username"],
    proofOfResidenceUrl: json["proofOfResidenceUrl"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "phone": phone,
    "profile": profile,
    "username": username,
    "proofOfResidenceUrl": proofOfResidenceUrl,
  };
}

