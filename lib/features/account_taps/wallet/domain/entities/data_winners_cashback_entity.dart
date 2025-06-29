import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/winners_cashback_entity.dart';

class DataWinnersCashbackEntity {
  final List<WinnersCashbackEntity> winnersCashback;
  final num totalAmount;
  final num totalWinners;
  final String currencyEn;
  final String currencyAr;
  final PaginationEntity pagination;

  DataWinnersCashbackEntity({
    required this.winnersCashback,
    required this.totalAmount,
    required this.totalWinners,
    required this.currencyEn,
    required this.currencyAr,
    required this.pagination,
  });
}
