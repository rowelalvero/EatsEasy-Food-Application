import 'dart:convert';

List<ReadyOrders> readyOrdersFromJson(String str) => List<ReadyOrders>.from(json.decode(str).map((x) => ReadyOrders.fromJson(x)));

String readyOrdersToJson(List<ReadyOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class ReadyOrders {
    final String id;
    final UserId? userId;
    final List<OrderItem> orderItems;
    final double? deliveryFee;
    final double? orderTotal;
    final String? deliveryOption;
    final String? deliveryDate;
    final String? paymentStatus;
    final DeliveryAddress? deliveryAddress;
    final String orderStatus;
    final RestaurantId? restaurantId;
    final List<double>? restaurantCoords;
    final List<double>? recipientCoords;
    final DateTime? orderDate; // Added field

    ReadyOrders({
        required this.id,
        this.userId,
        required this.orderItems,
        this.deliveryFee,
        this.orderTotal,
        this.deliveryOption,
        this.deliveryDate,
        this.paymentStatus,
        this.deliveryAddress,
        required this.orderStatus,
        this.restaurantId,
        this.restaurantCoords,
        this.recipientCoords,
        this.orderDate, // Added field
    });

    factory ReadyOrders.fromJson(Map<String, dynamic> json) => ReadyOrders(
        id: json["_id"] ?? "",
        userId: json["userId"] != null ? UserId.fromJson(json["userId"]) : null,
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        orderTotal: json["orderTotal"]?.toDouble(),
        deliveryOption: json["deliveryOption"] ?? "",
        deliveryDate: json["deliveryDate"] ?? "",
        paymentStatus: json["paymentStatus"] ?? "",
        deliveryAddress: json["deliveryAddress"] != null ? DeliveryAddress.fromJson(json["deliveryAddress"]) : null,
        orderStatus: json["orderStatus"] ?? "",
        restaurantId: json["restaurantId"] != null ? RestaurantId.fromJson(json["restaurantId"]) : null,
        restaurantCoords: json["restaurantCoords"] != null ? List<double>.from(json["restaurantCoords"].map((x) => x?.toDouble())) : null,
        recipientCoords: json["recipientCoords"] != null ? List<double>.from(json["recipientCoords"].map((x) => x?.toDouble())) : null,
        orderDate: json["orderDate"] != null ? DateTime.parse(json["orderDate"]) : null, // Parse date
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId?.toJson(),
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "deliveryFee": deliveryFee,
        "orderTotal": orderTotal,
        "deliveryOption": deliveryOption,
        "deliveryDate": deliveryDate,
        "paymentStatus": paymentStatus,
        "deliveryAddress": deliveryAddress?.toJson(),
        "orderStatus": orderStatus,
        "restaurantId": restaurantId?.toJson(),
        "restaurantCoords": restaurantCoords != null ? List<dynamic>.from(restaurantCoords!.map((x) => x)) : null,
        "recipientCoords": recipientCoords != null ? List<dynamic>.from(recipientCoords!.map((x) => x)) : null,
        "orderDate": orderDate?.toIso8601String(), // Serialize date
    };
}

class DeliveryAddress {
    final String id;
    final String addressLine1;

    DeliveryAddress({
        required this.id,
        required this.addressLine1,
    });

    factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
        addressLine1: json["addressLine1"] ?? "", id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "addressLine1": addressLine1,
    };
}

class OrderItem {
    final FoodId foodId;
    final int quantity;
    final double price;
    final List<String> additives;
    final String instructions;
    final String id;
    final Map<String, dynamic> customAdditives; // Added customAdditives field
    //final double unitPrice;

    OrderItem({
        required this.foodId,
        required this.quantity,
        required this.price,
        required this.additives,
        required this.instructions,
        required this.id,
        required this.customAdditives,
       // required this.unitPrice,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: FoodId.fromJson(json["foodId"]),
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instructions: json["instructions"] ?? "",
        id: json["_id"] ?? "",
        customAdditives: Map<String, dynamic>.from(json["customAdditives"]),
        //unitPrice: json["unitPrice"]??0.0,
    );

    Map<String, dynamic> toJson() => {
        "foodId": foodId.toJson(),
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instructions": instructions,
        "_id": id,
        "customAdditives": customAdditives,
       // "unitPrice":unitPrice
    };
}

class FoodId {
    final String id;
    final String title;
    final String time;
    final List<String> imageUrl;

    FoodId({
        required this.id,
        required this.title,
        required this.time,
        required this.imageUrl,
    });

    factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        time: json["time"] ?? "",
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
    };
}

class RestaurantId {
    final String id;
    final String title;
    final String time;
    final String imageUrl;
    final String logoUrl;

    RestaurantId({
        required this.id,
        required this.title,
        required this.time,
        required this.imageUrl,
        required this.logoUrl,
    });

    factory RestaurantId.fromJson(Map<String, dynamic> json) => RestaurantId(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        time: json["time"] ?? "",
        imageUrl: json["imageUrl"] ?? "",
        logoUrl: json["logoUrl"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "logoUrl": logoUrl,
    };
}

class UserId {
    final String id;
    final String phone;
    final String profile;

    UserId({
        required this.id,
        required this.phone,
        required this.profile,
    });

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"] ?? "",
        phone: json["phone"] ?? "",
        profile: json["profile"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "profile": profile,
    };
}
