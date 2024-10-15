import 'package:fourtyninehub/features/account_taps/wallet/data/models/competitons_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/gift_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';

class GiftModelModel extends GiftEntity {
  GiftModelModel({
    required super.giftWallet,
    required super.competitionsWallet,
    required super.id,
    required super.amount,
    required super.wheelWinner,
    required super.currency,
  });

  factory GiftModelModel.fromJson(Map<String, dynamic> json) {
    return GiftModelModel(
      giftWallet: GiftWalletModel.fromJson(json['giftWallet']),
      id: json['wheelWallet']['_id'] ?? '',
      currency: json['wheelWallet']['currency'] ?? '',
      amount: json['wheelWallet']['amount'] ?? 0,
      wheelWinner: json['wheelWinner'] ?? false,
      competitionsWallet: (json['competitionWallets'] as List)
        .map((e) => CompetitionsWalletModel.fromJson(e))
        .toList(),
    );
  }
}
