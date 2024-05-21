import 'dart:convert';

class ReviewModel {
  final int productId;
  final double rate;
  final String? message;
  ReviewModel({
    required this.productId,
    required this.rate,
    this.message,
  });

  ReviewModel copyWith({
    int? productId,
    double? rate,
    String? message,
  }) {
    return ReviewModel(
      productId: productId ?? this.productId,
      rate: rate ?? this.rate,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'rate': rate,
      'message': message,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      productId: map['productId']?.toInt() ?? 0,
      rate: map['rate']?.toDouble() ?? 0.0,
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ReviewModel(productId: $productId, rate: $rate, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewModel &&
        other.productId == productId &&
        other.rate == rate &&
        other.message == message;
  }

  @override
  int get hashCode => productId.hashCode ^ rate.hashCode ^ message.hashCode;
}
