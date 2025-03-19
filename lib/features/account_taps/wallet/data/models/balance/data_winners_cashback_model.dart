import 'package:fourtyninehub/features/account_taps/wallet/data/models/balance/winners_cashback_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/data_winners_cashback_entity.dart';

import '../pagination_model.dart';

class DataWinnersCashbackModel extends DataWinnersCashbackEntity {
  DataWinnersCashbackModel(
      {required super.winnersCashback, required super.pagination});

  factory DataWinnersCashbackModel.fromJson(Map<String, dynamic> json) {
    return DataWinnersCashbackModel(
      winnersCashback: (json['winners'] as List)
              .map((e) => WinnersCashbackModel.fromJson(e)).toList(),
      pagination: PaginationModel.fromJson(json["pagination"]),
    );
  }
}
