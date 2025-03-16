import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wheel_wallet_entity.dart';

import 'gift_competitions_entity.dart';
import 'gift_wallet_entity.dart';

class GiftAndCompetitionEntity {
  final GiftWalletEntity giftWallet;
  final WheelWalletEntity wheelWallet;
  final List<GiftCompetitionEntity> competitionsWallet;
  final bool wheelWinner;
  final bool isFIVE;
  final bool isTen;

  GiftAndCompetitionEntity({
    required this.giftWallet,
    required this.wheelWallet,
    required this.competitionsWallet,
    required this.wheelWinner,
    required this.isFIVE,
    required this.isTen,
  });
}