import 'package:fourtyninehub/features/competition/domain/entity/competition_entity.dart';

class CompetitionModel extends CompetitionEntity {
  CompetitionModel(
      {required super.id,
      required super.CompetitionId,
      required super.withdrawLimit,
      required super.maxRequests,
      required super.nameAr,
      required super.nameEn,
      required super.descriptionEn,
      required super.descriptionAr,
      required super.countOfRequest,
      required super.amount});

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['_id'] ?? '',
      CompetitionId: json['competition_id']['_id'] ?? '',
      withdrawLimit: json['competition_id']['withdrawLimit'] ?? 0,
      maxRequests: json['competition_id']['maxRequests'] ?? 0,
      nameAr: json['competition_id']['nameAr'] ?? '',
      nameEn: json['competition_id']['nameEn'] ?? '',
      descriptionEn: json['competition_id']['descriptionEn'] ?? '',
      descriptionAr: json['competition_id']['descriptionAr'] ?? '',
      countOfRequest: json['countOfRequest'] ?? 0,
      amount: json['amount'] ?? 0,
    );
  }
}
