import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../doctor_details/domain/entities/doctor_entity.dart';

class DoctorInfoEntity {
  final int remainingDaysToExpiryId;
  final int remainingDaysToExpiryPracticingId;
  final int remainingDaysToEndSubscription;
  final List<EarnedMoneyEntity> totalEarnedMoney;

  DoctorInfoEntity(
      {required this.remainingDaysToExpiryId,
      required this.remainingDaysToExpiryPracticingId,
      required this.remainingDaysToEndSubscription,
      required this.totalEarnedMoney,
      });
}
