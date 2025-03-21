import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wheel_wallet_entity.dart';

class WheelWalletModel extends WheelWalletEntity {
  WheelWalletModel({
    required super.id,
    required super.amount,
    required super.point,
    required super.count,
    required super.descriptionEn,
    required super.descriptionAr,
    required super.limit,
    required super.descriptionGiftWalletEn,
    required super.descriptionGiftWalletAr,
    required super.currencyEn,
    required super.currencyAr,
  });

  factory WheelWalletModel.fromJson(Map<String, dynamic> json) {
    return WheelWalletModel(
      id: json['_id'] ?? '',
      amount: json['amount'] ?? 0,
      point: json['points'] ?? 0,
      count: json['count'] ?? 0,
      limit: json['limit'] ?? 0,
      descriptionEn: json['descriptionEn'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      descriptionGiftWalletEn: json['descriptionGiftWalletEn'] ?? '',
      descriptionGiftWalletAr: json['descriptionGiftWalletAr'] ?? '',
      currencyEn: json['currencyEn'] ?? '',
      currencyAr: json['currencyAr'] ?? '',
    );
  }
}
