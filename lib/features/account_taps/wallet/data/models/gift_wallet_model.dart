import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_wallet_entity.dart';

class GiftWalletModel extends GiftWalletEntity {
  GiftWalletModel({
    required super.id,
    required super.userId,
    super.amount,
    required super.isActive,
    required super.fiveYearsComplete,
    required super.tenYearsComplete,
    required super.tenYears,
    required super.fiveYears,
    required super.createdAt,
    required super.updatedAt,
    required super.currency,
    required super.fiveYearsTransfer,
    required super.tenYearsTransfer,
    required super.fiveYearsLeft,
    required super.tenYearsLeft,
  });
  factory GiftWalletModel.fromJson(Map<String, dynamic> json) {
    return GiftWalletModel(
      id: json['_id'] ?? '',
      userId: json['user_id']['_id'] ?? '',
      amount: json['amount'] ?? 0,
      fiveYears: json['fiveYears'] ?? 0,
      tenYears: json['tenYears'] ?? 0,
      isActive: json['isActive'] ?? false,
      fiveYearsComplete: json['fiveYearsComplete'] ?? false,
      tenYearsComplete: json['tenYearsComplete'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      currency: json['currency'] ?? '',
      fiveYearsTransfer: json['fiveYearsTransfer'] ?? false,
      tenYearsTransfer: json['tenYearsTransfer'] ?? false,
      fiveYearsLeft: json['fiveYearsLeft'] ?? 0,
      tenYearsLeft: json['tenYearsLeft'] ?? 0,
    );
  }
}
