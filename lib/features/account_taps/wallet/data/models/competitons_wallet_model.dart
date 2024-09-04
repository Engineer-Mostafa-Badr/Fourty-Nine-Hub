import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competitions_wallet_entity.dart';

class CompetitionsWalletModel extends CompetitionsWalletEntity {
  CompetitionsWalletModel(
      {required super.id,
      required super.maxRequests,
      required super.countOfRequest});

  factory CompetitionsWalletModel.fromJson(Map<String, dynamic> json) {
    return CompetitionsWalletModel(
      id: json['competition_id']['_id']??'',
      maxRequests: json['competition_id']['maxRequests']??'',
      countOfRequest: json['countOfRequest']??0,
    );
  }
}
