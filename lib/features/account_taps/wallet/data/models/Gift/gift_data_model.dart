import '../../../domain/entities/gift_entities.dart';
import 'competition_wallet_model.dart';
import 'gift_wallet_model.dart';

class DataModel extends DataEntity {
  const DataModel({
    required GiftWalletModel giftWallet,
    required List<CompetitionWalletModel> competitionsWallet,
  }) : super(
    giftWallet: giftWallet,
    competitionsWallet: competitionsWallet,
  );

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      giftWallet: GiftWalletModel.fromJson(json['giftWallet']),
      competitionsWallet: List<CompetitionWalletModel>.from(
        json['competitionsWallet'].map((x) => CompetitionWalletModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'giftWallet': (giftWallet as GiftWalletModel).toJson(),
      'competitionsWallet': competitionsWallet
          .map((item) => (item as CompetitionWalletModel).toJson())
          .toList(),
    };
  }
}
