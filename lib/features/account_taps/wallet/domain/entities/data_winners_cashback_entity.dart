import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/winners_cashback_entity.dart';

class DataWinnersCashbackEntity {
  final List<WinnersCashbackEntity> winnersCashback;
  final PaginationEntity pagination;

  DataWinnersCashbackEntity({
    required this.winnersCashback,
    required this.pagination,
});
}