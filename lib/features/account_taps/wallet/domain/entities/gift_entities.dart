import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competitions_wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_wallet_entity.dart';

class GiftEntity {
  final GiftWalletEntity giftWallet;
  final String id;
  final String currency;
  final num? amount;
  final bool? wheelWinner;
  final List<CompetitionsWalletEntity> competitionsWallet;

  GiftEntity({
    required this.giftWallet,
    required this.id,
    required this.amount,
    required this.competitionsWallet,
    required this.wheelWinner,
    required this.currency,
  });
}
