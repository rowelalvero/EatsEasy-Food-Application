import 'dart:convert';

CartResponse cartResponseFromJson(String str) => CartResponse.fromJson(json.decode(str));

class CartResponse {
    final int count;

    CartResponse({
        required this.count,
    });

    factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        count: json["count"],
    );

}
