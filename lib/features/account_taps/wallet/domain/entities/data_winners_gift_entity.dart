import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/winners_gift_entity.dart';

class DataWinnersGiftEntity {
  final List<WinnersGiftEntity> winnersGift;
  final num totalAmount;
  final num totalWinners;
  final String currencyEn;
  final String currencyAr;
  final PaginationEntity pagination;

  DataWinnersGiftEntity({
    required this.winnersGift,
    required this.totalAmount,
    required this.totalWinners,
    required this.currencyEn,
    required this.currencyAr,
    required this.pagination,
  });
}
