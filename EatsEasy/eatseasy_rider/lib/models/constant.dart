import 'dart:convert';

class Constant {
  final double commissionRate;
  final double driverBaseRate;

  Constant({required this.commissionRate, required this.driverBaseRate});

  // Factory method to create an instance of Constant from a JSON object
  factory Constant.fromJson(Map<String, dynamic> json) {
    return Constant(
      commissionRate: json['commissionRate']?.toDouble() ?? 10.0, // Default to 10 if null
      driverBaseRate: json['driverBaseRate']?.toDouble() ?? 20.0, // Default to 20 if null
    );
  }

  // Method to convert the Constant instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'commissionRate': commissionRate,
      'driverBaseRate': driverBaseRate,
    };
  }
}
