import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';

class DoctorInfoEntity {
  final int remainingDaysToExpiryId;
  final int remainingDaysToExpiryPracticingId;
  final int remainingDaysToEndSubscription;
  final String subCategoryId;
  final List<EarnedMoneyEntity> totalEarnedMoney;

  DoctorInfoEntity({
    required this.remainingDaysToExpiryId,
    required this.remainingDaysToExpiryPracticingId,
    required this.remainingDaysToEndSubscription,
    required this.subCategoryId,
    required this.totalEarnedMoney,
  });
}
