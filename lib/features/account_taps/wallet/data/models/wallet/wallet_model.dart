import '../../../domain/entities/wallet/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({required super.realAmount, required super.currency});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      realAmount: json['realAmount'] ?? 0,
      currency: json['currency'] ?? '',
    );
  }
}
