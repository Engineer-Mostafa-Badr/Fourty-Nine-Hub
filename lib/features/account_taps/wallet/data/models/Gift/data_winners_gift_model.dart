import 'package:fourtyninehub/features/account_taps/wallet/data/models/Gift/winners_gift_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/pagination_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/data_winners_gift_entity.dart';

class DataWinnersGiftModel extends DataWinnersGiftEntity {
  DataWinnersGiftModel({
    required super.winnersGift,
    required super.pagination,
  });

  factory DataWinnersGiftModel.fromJson(Map<String, dynamic> json) {
    return DataWinnersGiftModel(
      winnersGift: (json['winners'] as List)
          .map((e) => WinnersGiftModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json["pagination"]),
    );
  }
}
