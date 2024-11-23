import 'package:fourtyninehub/features/health_feature/health/data/models/earned_money_model.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/doctor_info_entity.dart';

class DoctorInfoModel extends DoctorInfoEntity {
  DoctorInfoModel(
      {required super.remainingDaysToExpiryId,
      required super.remainingDaysToExpiryPracticingId,
      required super.remainingDaysToEndSubscription,
      required super.totalEarnedMoney});

  factory DoctorInfoModel.fromJson(Map<String, dynamic> json) {
    return DoctorInfoModel(
      remainingDaysToExpiryId: json['remainingDaysToExpiryId'] ?? 0,
      remainingDaysToExpiryPracticingId:
          json['remainingDaysToExpiryPracticingId'] ?? 0,
      remainingDaysToEndSubscription:
          json['remainingDaysToEndSubscription'] ?? 0,
      totalEarnedMoney: (json['totalEarnedMony'] as List)
          .map((i) => EarnedMoneyModel.fromJson(i))
          .toList(),
    );
  }
}
