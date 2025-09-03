import '../../domain/entities/wallet_home_entity.dart';

class WalletHomeModel extends WalletHomeEntity {
  WalletHomeModel({
    required super.realAmount,
    required super.realAmountRatio,
    required super.balance,
    required super.balanceRatio,
    required super.giftWallet,
    required super.holdingAmount,
    required super.giftWalletRatio,
    required super.currencyEn,
    required super.currencyAr,
  });

  factory WalletHomeModel.fromJson(Map<String, dynamic> json) {
    return WalletHomeModel(
      realAmount: json['realAmount'] ?? 0,
      realAmountRatio: json['realAmountRatio'] ?? 0,
      balance: json['balance'] ?? 0,
      holdingAmount: json['holdingAmount'] ?? 0,
      balanceRatio: json['balanceRatio'] ?? 0,
      giftWallet: json['giftWallet'] ?? 0,
      giftWalletRatio: json['giftWalletRatio'] ?? 0,
      currencyEn: json['currencyEn'] ?? '',
      currencyAr: json['currencyAr'] ?? '',
    );
  }
}
