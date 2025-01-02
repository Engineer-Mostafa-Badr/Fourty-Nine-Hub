import 'package:fourtyninehub/features/competition/domain/entity/winner_competition_entity.dart';

class WinnerCompetitionModel extends WinnerCompetitionEntity {
  WinnerCompetitionModel(
      {required super.id,
      required super.competitionId,
      required super.withdrawLimit,
      required super.maxRequests,
      required super.nameAr,
      required super.nameEn,
      required super.firstName,
      required super.lastName,
      required super.image,
      required super.profit,
      required super.createdAt,
      required super.numberOfWins});

  factory WinnerCompetitionModel.fromJson(Map<String, dynamic> json) {
    return WinnerCompetitionModel(
      id: json['_id'] ?? '',
      competitionId: json['competition_id']['_id'] ?? '',
      withdrawLimit: json['competition_id']['withdrawLimit'] ?? 0,
      maxRequests: json['competition_id']['maxRequests'] ?? 0,
      nameAr: json['competition_id']['nameAr'] ?? '',
      nameEn: json['competition_id']['nameEn'] ?? '',
      firstName: json['user_id']['firstName'] ?? '',
      lastName: json['user_id']['lastName'] ?? '',
      image: json['user_id']['USER_PROFILE']['profilePictureKey']['mediaKey'] ?? '',
      profit: json['profit'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      numberOfWins: json['numberOfWins'] ?? 0,
    );
  }
}
