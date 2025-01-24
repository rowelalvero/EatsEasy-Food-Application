class User {
  String? id;
  String? username;
  String email;
  String? fcm;
  String? otp;
  bool verification;
  String password;
  String? phone;
  String? validIdUrl;
  String? proofOfResidenceUrl;
  bool phoneVerification;
  String? address;
  String userType;
  String profile;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    this.fcm,
    this.otp,
    required this.verification,
    required this.password,
    this.phone,
    this.validIdUrl,
    this.proofOfResidenceUrl,
    required this.phoneVerification,
    this.address,
    required this.userType,
    required this.profile,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      profile: json['profile'] ?? 'default-profile-url', // Provide a default if necessary
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
