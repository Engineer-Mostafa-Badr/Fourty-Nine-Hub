import 'package:fourtyninehub/features/account_taps/wallet/data/models/competitons_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/gift_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';

class GiftModelModel extends GiftEntity {
  GiftModelModel({
    required super.giftWallet,
    required super.competitionsWallet,
  });

  factory GiftModelModel.fromJson(Map<String, dynamic> json) {
    return GiftModelModel(
      giftWallet: json['giftWallet'] != null
          ? GiftWalletModel.fromJson(json['giftWallet'] as Map<String, dynamic>)
          : throw Exception('GiftWallet data is null'),
      competitionsWallet: json['competitionsWallet'] != null
          ? (json['competitionsWallet'] as List)
          .map((e) => CompetitionsWalletModel.fromJson(e as Map<String, dynamic>))
          .toList()
          : [],
    );
  }
}
