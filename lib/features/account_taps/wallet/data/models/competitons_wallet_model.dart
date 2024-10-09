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

    return CompetitionsWalletModel(
      id: json['competition_id']['_id'] ?? '',
      nameAr: json['competition_id']['nameAr'] ?? '',
      nameEn: json['competition_id']['nameEn'] ?? '',
      maxRequests: json['competition_id']['maxRequests'] ?? 0,
      countOfRequest: json['countOfRequest'] ?? 0,
      isWinner: json['isWinner'] ?? false,
    );
  }
}
