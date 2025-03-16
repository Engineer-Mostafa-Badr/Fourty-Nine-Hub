import 'package:fourtyninehub/features/account_taps/wallet/data/models/wheel_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_and_competition_entity.dart';

import 'gift_competition_model.dart';
import 'gift_wallet_model.dart';

class GiftAndCompetitionModel extends GiftAndCompetitionEntity {
  GiftAndCompetitionModel({
    required super.giftWallet,
    required super.wheelWallet,
    required super.competitionsWallet,
    required super.wheelWinner,
    required super.isFIVE,
    required super.isTen,
  });

  factory GiftAndCompetitionModel.fromJson(Map<String, dynamic> json) {
    return GiftAndCompetitionModel(
      giftWallet: GiftWalletModel.fromJson(json['giftWallet']),
      wheelWallet: WheelWalletModel.fromJson(json['wheelWallet']),
      competitionsWallet: (json['competitionWallets'] as List)
          .map((c) => GiftCompetitionModel.fromJson(c))
          .toList(),
      wheelWinner: json['wheelWinner'],
      isFIVE: json['isFIVE'],
      isTen: json['isTen'],
    );
  }
}
