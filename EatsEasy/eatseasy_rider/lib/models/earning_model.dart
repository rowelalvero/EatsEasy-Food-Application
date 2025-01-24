class EarningsData {
  final List<Earning> dailyEarnings;
  final List<Earning> weeklyEarnings;
  final List<Earning> monthlyEarnings;

  EarningsData({
    required this.dailyEarnings,
    required this.weeklyEarnings,
    required this.monthlyEarnings,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      dailyEarnings: (json['dailyEarnings'] as List)
          .map((e) => Earning.fromJson(e))
          .toList(),
      weeklyEarnings: (json['weeklyEarnings'] as List)
          .map((e) => Earning.fromJson(e))
          .toList(),
      monthlyEarnings: (json['monthlyEarnings'] as List)
          .map((e) => Earning.fromJson(e))
          .toList(),
    );
  }
}

class Earning {
  final double totalEarnings;
  final int year;
  final int? month;
  final int? week;
  final int? day;

  Earning({
    required this.totalEarnings,
    required this.year,
    this.month,
    this.week,
    this.day,
  });

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
      totalEarnings: json['totalEarnings'].toDouble(),
      year: json['year'],
      month: json['month'],
      week: json['week'],
      day: json['day'],
    );
  }
}
