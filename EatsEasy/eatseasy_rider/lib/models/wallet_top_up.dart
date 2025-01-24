import 'dart:convert';

DriverWallet driverWalletFromJson(String str) => DriverWallet.fromJson(json.decode(str));
String driverWallerToJson(DriverWallet data) => json.encode(data.toJson());

class DriverWallet {
  final String userId;
  final List<WalletTransactions> walletTransactions;
  final double walletBalance;

  DriverWallet({
    required this.userId,
    required this.walletTransactions,
    required this.walletBalance,
  });

  factory DriverWallet.fromJson(Map<String, dynamic> json) => DriverWallet(
    userId: json["userId"],
    walletTransactions: List<WalletTransactions>.from(json["walletTransactions"].map((x) => WalletTransactions.fromJson(x))),
    walletBalance: json["walletBalance"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "walletTransactions": List<dynamic>.from(walletTransactions.map((x) => x.toJson())),
    "walletBalance": walletBalance,
  };
}

class WalletTransactions {
  final double amount;
  final String paymentMethod;
  final String? id; // Optional _id field
  final DateTime? transactionDate; // Optional transaction date field

  WalletTransactions({
    required this.amount,
    required this.paymentMethod,
    this.id,
    this.transactionDate,
  });

  factory WalletTransactions.fromJson(Map<String, dynamic> json) => WalletTransactions(
    amount: json["amount"].toDouble(),
    paymentMethod: json["paymentMethod"],
    id: json["_id"], // Access the _id field if present
    transactionDate: json["transactionDate"] != null
        ? DateTime.parse(json["transactionDate"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "paymentMethod": paymentMethod,
    "_id": id, // Include _id if present
    "transactionDate": transactionDate?.toIso8601String(),
  };
}

