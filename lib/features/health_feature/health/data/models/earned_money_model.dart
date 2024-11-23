import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';

class EarnedMoneyModel extends EarnedMoneyEntity {
  EarnedMoneyModel(
      {required super.count,
      required super.appointmentType,
      required super.totalEarned});

  factory EarnedMoneyModel.fromJson(Map<String, dynamic> json) {
    return EarnedMoneyModel(
      count: json['count'] ?? 0,
      appointmentType: json['appointmentType'] ?? '',
      totalEarned: json['totalEarned'] ?? 0,
    );
  }
}
