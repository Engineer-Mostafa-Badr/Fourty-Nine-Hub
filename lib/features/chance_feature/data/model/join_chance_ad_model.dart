class JoinChanceAdModel {
  final String adId;
  final double amount;

  JoinChanceAdModel({
    required this.adId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'adId': adId,
      'amount': amount,
    };
  }

  factory JoinChanceAdModel.fromJson(Map<String, dynamic> json) {
    return JoinChanceAdModel(
      adId: json['adId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
