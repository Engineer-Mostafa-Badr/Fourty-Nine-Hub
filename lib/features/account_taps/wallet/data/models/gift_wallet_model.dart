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
    required super.fiveYearsTransfer,
    required super.tenYearsTransfer,
    required super.fiveYearsLeft,
    required super.tenYearsLeft,
    required super.currencyEn,
    required super.currencyAr,
  });
  factory GiftWalletModel.fromJson(Map<String, dynamic> json) {
    return GiftWalletModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      amount: json['amount'] ?? 0,
      fiveYears: json['five_years'] ?? 0,
      tenYears: json['ten_years'] ?? 0,
      isActive: json['isActive'] ?? false,
      fiveYearsComplete: json['fiveYearsComplete'] ?? false,
      tenYearsComplete: json['tenYearsComplete'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      currencyEn: json['currencyEn'] ?? '',
      currencyAr: json['currencyAr'] ?? '',
      fiveYearsTransfer: json['fiveYearsTransfer'] ?? false,
      tenYearsTransfer: json['tenYearsTransfer'] ?? false,
      fiveYearsLeft: json['fiveYearsLeft'] ?? 0,
      tenYearsLeft: json['tenYearsLeft'] ?? 0,
    );
  }
}
