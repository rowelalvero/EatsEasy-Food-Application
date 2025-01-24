// models/earnings_model.dart
class Earnings {
  final double totalEarnings;
  final double commission;

  Earnings({required this.totalEarnings, required this.commission});

  factory Earnings.fromJson(Map<String, dynamic> json) {
    // Parse totalEarnings, handling the MongoDB decimal structure if necessary
    double parseEarnings(dynamic earnings) {
      if (earnings is Map<String, dynamic> && earnings.containsKey('\$numberDecimal')) {
        return double.parse(earnings['\$numberDecimal']);
      } else if (earnings is num) {
        return earnings.toDouble();
      } else {
        throw FormatException("Invalid format for earnings");
      }
    }

    return Earnings(
      totalEarnings: parseEarnings(json['totalEarnings']),
      commission: (json['commission'] as num).toDouble(),
    );
  }
}
