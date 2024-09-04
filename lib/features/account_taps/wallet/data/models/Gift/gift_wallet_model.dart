import '../../../domain/entities/gift_entities.dart';

class GiftWalletModel extends GiftWallet {
  const GiftWalletModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GiftWalletModel.fromJson(Map<String, dynamic> json) {
    return GiftWalletModel(
      id: json['_id'],
      userId: json['user_id'],
      amount: json['amount'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'amount': amount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
