
import 'dart:convert';

GetOrder getOrderFromJson(String str) => GetOrder.fromJson(json.decode(str));

String getOrderToJson(GetOrder data) => json.encode(data.toJson());

class GetOrder {
    String? id;
    UserId? userId;
    List<OrderItem>? orderItems;
    double? deliveryFee;
    final double grandTotal;
    final double orderTotal;
    DeliveryAddress? deliveryAddress;
    String? orderStatus;
    RestaurantId? restaurantId;
    List<double>? restaurantCoords;
    List<double>? recipientCoords;
    DriverId? driverId;

    GetOrder({
        this.id,
        this.userId,
        this.orderItems,
        this.deliveryFee,
        required this.grandTotal,
        required this.orderTotal,
        this.deliveryAddress,
        this.orderStatus,
        this.restaurantId,
        this.restaurantCoords,
        this.recipientCoords,
        this.driverId,
    });

    factory GetOrder.fromJson(Map<String, dynamic> json) => GetOrder(
        id: json['_id'],
        userId: json['userId'] != null ? UserId.fromJson(json['userId']) : null,
        orderItems: json['orderItems'] != null
            ? (json['orderItems'] as List).map((item) => OrderItem.fromJson(item)).toList()
            : null,
        deliveryFee: json['deliveryFee']?.toDouble(),
        grandTotal: json["grandTotal"].toDouble(),
        orderTotal: json["orderTotal"].toDouble(),
        deliveryAddress: json['deliveryAddress'] != null ? DeliveryAddress.fromJson(json['deliveryAddress']) : null,
        orderStatus: json['orderStatus'],
        restaurantId: json['restaurantId'] != null ? RestaurantId.fromJson(json['restaurantId']) : null,
        restaurantCoords: json['restaurantCoords'] != null ? List<double>.from(json['restaurantCoords']) : null,
        recipientCoords: json['recipientCoords'] != null ? List<double>.from(json['recipientCoords']) : null,
        driverId: json['driverId'] != null ? DriverId.fromJson(json['driverId']) : null,
    );

    Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId?.toJson(),
        'orderItems': orderItems?.map((item) => item.toJson()).toList(),
        'deliveryFee': deliveryFee,
        'orderTotal': orderTotal,
        'grandTotal': grandTotal,
        'deliveryAddress': deliveryAddress?.toJson(),
        'orderStatus': orderStatus,
        'restaurantId': restaurantId?.toJson(),
        'restaurantCoords': restaurantCoords,
        'recipientCoords': recipientCoords,
        'driverId': driverId?.toJson(),
    };
}

class UserId {
    String? id;
    String? phone;
    String? profile;

    UserId({this.id, this.phone, this.profile});

    factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json['_id'],
        phone: json['phone'],
        profile: json['profile'],
    );

    Map<String, dynamic> toJson() => {
        '_id': id,
        'phone': phone,
        'profile': profile,
    };
}

class OrderItem {
    FoodId? foodId;
    int? quantity;
    double? price;
    double? unitPrice;
    List<String>? additives;
    String? instructions;
    String? cartItemId;
    String? id;

    OrderItem({
        this.foodId,
        this.quantity,
        this.price,
        this.unitPrice,
        this.additives,
        this.instructions,
        this.cartItemId,
        this.id,
    });

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: json['foodId'] != null ? FoodId.fromJson(json['foodId']) : null,
        quantity: json['quantity'],
        price: json['price']?.toDouble(),
        unitPrice: json['unitPrice']?.toDouble(),
        additives: json['additives'] != null ? List<String>.from(json['additives']) : null,
        instructions: json['instructions'],
        cartItemId: json['cartItemId'],
        id: json['_id'],
    );

    Map<String, dynamic> toJson() => {
        'foodId': foodId?.toJson(),
        'quantity': quantity,
        'price': price,
        'unitPrice': unitPrice,
        'additives': additives,
        'instructions': instructions,
        'cartItemId': cartItemId,
        '_id': id,
    };
}

class FoodId {
    String? id;
    String? title;
    String? time;
    List<String>? imageUrl;

    FoodId({this.id, this.title, this.time, this.imageUrl});

    factory FoodId.fromJson(Map<String, dynamic> json) => FoodId(
        id: json['_id'],
        title: json['title'],
        time: json['time'],
        imageUrl: json['imageUrl'] != null ? List<String>.from(json['imageUrl']) : null,
    );

    Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'time': time,
        'imageUrl': imageUrl,
    };
}

class DeliveryAddress {
    String? id;
    String? addressLine1;

    DeliveryAddress({this.id, this.addressLine1});

    factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
        id: json['_id'],
        addressLine1: json['addressLine1'],
    );

    Map<String, dynamic> toJson() => {
        '_id': id,
        'addressLine1': addressLine1,
    };
}

class RestaurantId {
    Coords? coords;
    String? id;
    String? title;
    String? time;
    String? imageUrl;
    String? logoUrl;

    RestaurantId({
        this.coords,
        this.id,
        this.title,
        this.time,
        this.imageUrl,
        this.logoUrl,
    });

    factory RestaurantId.fromJson(Map<String, dynamic> json) => RestaurantId(
        coords: json['coords'] != null ? Coords.fromJson(json['coords']) : null,
        id: json['_id'],
        title: json['title'],
        time: json['time'],
        imageUrl: json['imageUrl'],
        logoUrl: json['logoUrl'],
    );

    Map<String, dynamic> toJson() => {
        'coords': coords?.toJson(),
        '_id': id,
        'title': title,
        'time': time,
        'imageUrl': imageUrl,
        'logoUrl': logoUrl,
    };
}

class Coords {
    String? id;
    double? latitude;
    double? longitude;
    String? address;
    String? title;
    double? latitudeDelta;
    double? longitudeDelta;

    Coords({
        this.id,
        this.latitude,
        this.longitude,
        this.address,
        this.title,
        this.latitudeDelta,
        this.longitudeDelta,
    });

    factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json['id'],
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
        address: json['address'],
        title: json['title'],
        latitudeDelta: json['latitudeDelta']?.toDouble(),
        longitudeDelta: json['longitudeDelta']?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'title': title,
        'latitudeDelta': latitudeDelta,
        'longitudeDelta': longitudeDelta,
    };
}

class DriverId {
    CurrentLocation? currentLocation;
    String? id;
    Driver? driver;
    String? phone;
    String? vehicleNumber;
    String? profileImage;

    DriverId({this.currentLocation, this.id, this.driver, this.phone, this.vehicleNumber, this.profileImage});

    factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        currentLocation: json['currentLocation'] != null ? CurrentLocation.fromJson(json['currentLocation']) : null,
        id: json['_id'],
        driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
        phone: json['phone'],
        vehicleNumber: json['vehicleNumber'],
        profileImage: json['profileImage'],
    );

    Map<String, dynamic> toJson() => {
        'currentLocation': currentLocation?.toJson(),
        '_id': id,
        'driver': driver?.toJson(),
        'phone': phone,
        'vehicleNumber': vehicleNumber,
        'profileImage': profileImage
    };
}

class CurrentLocation {
    double? latitude;
    double? longitude;

    CurrentLocation({this.latitude, this.longitude});

    factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
    };
}

class Driver {
    String? id;
    String? username;
    String? email;
    String? fcm;
    String? otp;
    bool? verification;
    String? password;
    String? phone;
    String? validIdUrl;
    String? proofOfResidenceUrl;
    bool? phoneVerification;
    String? address;
    String? userType;
    String? profile;
    DateTime? createdAt;
    DateTime? updatedAt;

    Driver({
        this.id,
        this.username,
        this.email,
        this.fcm,
        this.otp,
        this.verification,
        this.password,
        this.phone,
        this.validIdUrl,
        this.proofOfResidenceUrl,
        this.phoneVerification,
        this.address,
        this.userType,
        this.profile,
        this.createdAt,
        this.updatedAt,
    });

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['_id'],
        username: json['username'],
        email: json['email'],
        fcm: json['fcm'],
        otp: json['otp'],
        verification: json['verification'] ?? false,
        password: json['password'],
        phone: json['phone'],
        validIdUrl: json['validIdUrl'],
        proofOfResidenceUrl: json['proofOfResidenceUrl'],
        phoneVerification: json['phoneVerification'] ?? false,
        address: json['address'],
        userType: json['userType'],
        profile: json['profile'] ?? 'default-profile-url',
    );

    Map<String, dynamic> toJson() => {
        '_id': id,
        'username': username,
        'email': email,
        'fcm': fcm,
        'otp': otp,
        'verification': verification,
        'password': password,
        'phone': phone,
        'validIdUrl': validIdUrl,
        'proofOfResidenceUrl': proofOfResidenceUrl,
        'phoneVerification': phoneVerification,
        'address': address,
        'userType': userType,
        'profile': profile,
    };
}
