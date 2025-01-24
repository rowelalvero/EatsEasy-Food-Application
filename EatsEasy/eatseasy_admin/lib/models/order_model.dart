import 'dart:convert';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
    final List<Order> orders;
    final int currentPage;
    final int totalPages;

    Orders({
        required this.orders,
        required this.currentPage,
        required this.totalPages,
    });

    factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
    };
}

class Order {
    final String? driverId;
    final int? rating;
    final String id;
    final String userId;
    final List<OrderItem> orderItems;
    final double orderTotal;
    final double deliveryFee;
    final double grandTotal;
    final String deliveryAddress;
    final String restaurantAddress;
    final String paymentMethod;
    final String paymentStatus;
    final String orderStatus;
    final String restaurantId;
    final String orderDate;

    Order({
        this.driverId,
        this.rating,
        required this.id,
        required this.userId,
        required this.orderItems,
        required this.orderTotal,
        required this.deliveryFee,
        required this.grandTotal,
        required this.deliveryAddress,
        required this.restaurantAddress,
        required this.paymentMethod,
        required this.paymentStatus,
        required this.orderStatus,
        required this.restaurantId,
        required this.orderDate,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        driverId: json["driverId"],
        rating: json["rating"],
        id: json["_id"],
        userId: json["userId"],
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"]?.toDouble(),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        grandTotal: json["grandTotal"]?.toDouble(),
        deliveryAddress: json["deliveryAddress"],
        restaurantAddress: json["restaurantAddress"],
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"],
        orderStatus: json["orderStatus"],
        restaurantId: json["restaurantId"],
        orderDate: json["orderDate"],
    );

    Map<String, dynamic> toJson() => {
        "driverId": driverId,
        "rating": rating,
        "_id": id,
        "userId": userId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "deliveryFee": deliveryFee,
        "grandTotal": grandTotal,
        "deliveryAddress": deliveryAddress,
        "restaurantAddress": restaurantAddress,
        "paymentMethod": paymentMethod,
        "paymentStatus": paymentStatus,
        "orderStatus": orderStatus,
        "restaurantId": restaurantId,
        "orderDate": orderDate,
    };
}

class OrderItem {
    final FoodId foodId;
    final int quantity;
    final double price;
    final String instructions;
    final String id;
    final Map<String, dynamic> customAdditives;

    OrderItem({
        required this.foodId,
        required this.quantity,
        required this.price,
        required this.instructions,
        required this.id,
        required this.customAdditives,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: FoodId.fromJson(json["foodId"]),
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        instructions: json["instructions"],
        id: json["_id"],
        customAdditives: Map<String, dynamic>.from(json["customAdditives"]),
    );

    Map<String, dynamic> toJson() => {
        "foodId": foodId.toJson(),
        "quantity": quantity,
        "price": price,
        "instructions": instructions,
        "_id": id,
        "customAdditives": customAdditives,
    };
}

class FoodId {
    final String id;
    final String title;
    final double rating;
    final List<String> imageUrl;
    final String time;

    FoodId({
        required this.id,
        required this.title,
        required this.rating,
        required this.imageUrl,
        required this.time,
    });

    factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json["_id"],
        title: json["title"],
        rating: json["rating"]?.toDouble(),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "rating": rating,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "time": time,
    };
}
