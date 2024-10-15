import '../../domain/entities/wallet_home_entity.dart';

class WalletHomeModel extends WalletHomeEntity {
  WalletHomeModel(
      {required super.realAmount,
      required super.balance,
      required super.giftWallet,
      required super.currency,
      });

  factory WalletHomeModel.fromJson(Map<String, dynamic> json) {
    return WalletHomeModel(
      realAmount: json['realAmount'] ?? '',
      balance: json['balance'] ?? '',
      giftWallet: json['giftWallet'] ?? '',
      currency: json['currency'] ?? '',
    );
  }
}
