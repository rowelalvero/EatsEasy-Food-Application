
import 'dart:convert';

Payout payoutFromJson(String str) => Payout.fromJson(json.decode(str));

String payoutToJson(Payout data) => json.encode(data.toJson());

class Payout {
    final List<PayoutElement> payouts;
    final int currentPage;
    final int totalPages;

    Payout({
        required this.payouts,
        required this.currentPage,
        required this.totalPages,
    });

    factory Payout.fromJson(Map<String, dynamic> json) => Payout(
        payouts: List<PayoutElement>.from(json["payouts"].map((x) => PayoutElement.fromJson(x))),
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
    );

    Map<String, dynamic> toJson() => {
        "payouts": List<dynamic>.from(payouts.map((x) => x.toJson())),
        "currentPage": currentPage,
        "totalPages": totalPages,
    };
}

class PayoutElement {
    final String accountNumber;
    final String accountName;
    final String accountBank;
    final String id;
    final Restaurant restaurant;
    final double amount;
    final String status;
    final String method;
    final DateTime createdAt;

    PayoutElement({
        required this.accountNumber,
        required this.accountName,
        required this.accountBank,
        required this.id,
        required this.restaurant,
        required this.amount,
        required this.status,
        required this.method,
        required this.createdAt,
    });

    factory PayoutElement.fromJson(Map<String, dynamic> json) => PayoutElement(
        accountNumber: json["accountNumber"],
        accountName: json["accountName"],
        accountBank: json["accountBank"],
        id: json["_id"],
        restaurant: Restaurant.fromJson(json["restaurant"]),
        amount: json["amount"]?.toDouble(),
        status: json["status"],
        method: json["method"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "accountNumber": accountNumber,
        "accountName": accountName,
        "accountBank": accountBank,
        "_id": id,
        "restaurant": restaurant.toJson(),
        "amount": amount,
        "status": status,
        "method": method,
        "createdAt": createdAt.toIso8601String(),
    };
}

class Restaurant {
    final String id;
    final String title;
    final String logoUrl;
    final double earnings;

    Restaurant({
        required this.id,
        required this.title,
        required this.logoUrl,
        required this.earnings,
    });

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["_id"],
        title: json["title"],
        logoUrl: json["logoUrl"],
        earnings: json["earnings"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "logoUrl": logoUrl,
        "earnings": earnings,
    };
}
