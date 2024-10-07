import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competitions_wallet_entity.dart';

class CompetitionsWalletModel extends CompetitionsWalletEntity {
  CompetitionsWalletModel({
    required super.id,
    required super.maxRequests,
    required super.countOfRequest,
    required super.nameAr,
    required super.nameEn,
    required super.isWinner,
  });

  factory CompetitionsWalletModel.fromJson(Map<String, dynamic> json) {
    // Check if 'competition_id' exists and is not null
    final competitionData = json['competition_id'] ?? {};

    return CompetitionsWalletModel(
      id: competitionData['_id'] ?? '',
      nameAr: competitionData['nameAr'] ?? '',
      nameEn: competitionData['nameEn'] ?? '',
      maxRequests: competitionData['maxRequests'] ?? 0,
      countOfRequest: json['countOfRequest'] ?? 0,
      isWinner: json['isWinner'] ?? false,
    );
  }
}
