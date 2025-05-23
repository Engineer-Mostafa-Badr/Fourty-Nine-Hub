import 'package:fourtyninehub/features/account_taps/wallet/data/models/Gift/winners_gift_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/pagination_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/data_winners_gift_entity.dart';

class DataWinnersGiftModel extends DataWinnersGiftEntity {
  DataWinnersGiftModel({
    required super.winnersGift,
    required super.totalAmount,
    required super.totalWinners,
    required super.currencyEn,
    required super.currencyAr,
    required super.pagination,
  });

  factory DataWinnersGiftModel.fromJson(Map<String, dynamic> json) {
    return DataWinnersGiftModel(
      winnersGift: (json['winners'] as List)
          .map((e) => WinnersGiftModel.fromJson(e))
          .toList(),
      totalAmount: json['totalAmount'],
      totalWinners: json['totalWinners'],
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
      pagination: PaginationModel.fromJson(json["pagination"]),
    );
  }
}
