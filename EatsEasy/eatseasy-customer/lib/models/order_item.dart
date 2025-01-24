import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());

class Order {
    final String userId;
    final List<OrderItem> orderItems;
    final String orderTotal;
    final String restaurantAddress;
    final List<double> restaurantCoords;
    final List<double> recipientCoords;
    final String deliveryDate;
    final String deliveryFee;
    final String grandTotal;
    final String deliveryAddress;
    final String paymentMethod;
    final String restaurantId;
    final String deliveryOption;

    Order({
        required this.userId,
        required this.orderItems,
        required this.orderTotal,
        required this.restaurantAddress,
        required this.restaurantCoords,
        required this.recipientCoords,
        required this.deliveryDate,
        required this.deliveryFee,
        required this.grandTotal,
        required this.deliveryAddress,
        required this.paymentMethod,
        required this.restaurantId,
        required this.deliveryOption,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        userId: json["userId"],
        orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"],
        restaurantAddress: json["restaurantAddress"],
        restaurantCoords: List<double>.from(json["restaurantCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(json["recipientCoords"].map((x) => x?.toDouble())),
        deliveryDate: json["deliveryDate"],
        deliveryFee: json["deliveryFee"],
        grandTotal: json["grandTotal"],
        deliveryAddress: json["deliveryAddress"],
        paymentMethod: json["paymentMethod"],
        restaurantId: json["restaurantId"],
        deliveryOption: json["deliveryOption"]
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "restaurantAddress": restaurantAddress,
        "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
        "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
        "deliveryDate": deliveryDate,
        "deliveryFee": deliveryFee,
        "grandTotal": grandTotal,
        "deliveryAddress": deliveryAddress,
        "paymentMethod": paymentMethod,
        "restaurantId": restaurantId,
        "deliveryOption": deliveryOption
    };
}

class OrderItem {
    final String foodId;
    //final List<String> additives;
    final String quantity;
    final String price;
    final String instructions;
    final String? cartItemId;
    final Map<String, dynamic> customAdditives;

    OrderItem({
        required this.foodId,
        //required this.additives,
        required this.quantity,
        required this.price,
        required this.instructions,
        this.cartItemId,
        required this.customAdditives,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: json["foodId"],
        //additives: List<String>.from(json["additives"].map((x) => x)),
        quantity: json["quantity"],
        price: json["price"],
        instructions: json["instructions"],
        cartItemId: json["cartItemId"],
        customAdditives: Map<String, dynamic>.from(json["customAdditives"]),
    );


    Map<String, dynamic> toJson() => {
        "foodId": foodId,
        //"additives": List<dynamic>.from(additives.map((x) => x)),
        "quantity": quantity,
        "price": price,
        "instructions": instructions,
        "cartItemId": cartItemId,
        "customAdditives": customAdditives, // Include customAdditives in the output
    };

}
