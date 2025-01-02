import 'package:fourtyninehub/features/account_taps/wallet/data/models/competitons_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/gift_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/wheel_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';

class GiftModelModel extends GiftEntity {
  GiftModelModel({
    required super.giftWallet,
    required super.competitionsWallet,
    required super.wheelWinner,
     required super.wheel,
  });

  factory GiftModelModel.fromJson(Map<String, dynamic> json) {
    return GiftModelModel(
      giftWallet: GiftWalletModel.fromJson(json['giftWallet']),
      wheelWinner: json['wheelWinner'] ?? false,
      competitionsWallet: (json['competitionWallets'] as List)
          .map((e) => CompetitionsWalletModel.fromJson(e))
          .toList(),
      wheel: WheelWalletModel.fromJson(json['wheelWallet']),
    );
  }
}
