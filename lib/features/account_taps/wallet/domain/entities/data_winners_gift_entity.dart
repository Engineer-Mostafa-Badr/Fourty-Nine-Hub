import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/pagination_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/winners_gift_entity.dart';

class DataWinnersGiftEntity {
  final List<WinnersGiftEntity> winnersGift;
  final PaginationEntity pagination;

  DataWinnersGiftEntity({
    required this.winnersGift,
    required this.pagination,
  });
}
