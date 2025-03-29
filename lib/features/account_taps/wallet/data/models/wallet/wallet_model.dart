import '../../../domain/entities/wallet/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.realAmount,
    required super.isWaitingApproval,
    required super.currencyEn,
    required super.currencyAr,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      realAmount: json['realAmount'] ?? 0,
      isWaitingApproval: json['isWaitingApproval'] ?? '',
      currencyEn: json['currencyEn'] ?? '',
      currencyAr: json['currencyAr'] ?? '',
    );
  }
}
