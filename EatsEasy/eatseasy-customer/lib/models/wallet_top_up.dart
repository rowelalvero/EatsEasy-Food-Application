import 'dart:convert';

UserWallet driverWalletFromJson(String str) => UserWallet.fromJson(json.decode(str));
String driverWallerToJson(UserWallet data) => json.encode(data.toJson());

class UserWallet {
  final String userId;
  final List<WalletTransactions>? walletTransactions;
  final double? walletBalance;

  UserWallet({
    required this.userId,
    required this.walletTransactions,
    required this.walletBalance,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
    userId: json["userId"],
    walletTransactions: json["walletTransactions"] != null
        ? List<WalletTransactions>.from(
        json["walletTransactions"].map((x) => WalletTransactions.fromJson(x)))
        : null,
    walletBalance: json["walletBalance"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "walletTransactions": walletTransactions?.map((x) => x.toJson()).toList() ?? [],
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

