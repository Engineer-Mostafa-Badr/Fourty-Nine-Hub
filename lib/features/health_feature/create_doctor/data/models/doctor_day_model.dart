import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';

class DoctorDayModel extends DoctorDayEntity {
  DoctorDayModel({required super.day, super.from, super.to, super.isAvailable});

  factory DoctorDayModel.fromEntity(DoctorDayEntity entity) {
    return DoctorDayModel(
      day: entity.day,
      from: entity.from,
      to: entity.to,
      isAvailable: entity.isAvailable,
    );
  }

  factory DoctorDayModel.fromJson(Map<String, dynamic> json) {
    return DoctorDayModel(
      day: (json['day'] as String).toWeekDay,
      from: (json['workFrom'] as String).toTimeOfDay,
      to: (json['workTo'] as String).toTimeOfDay,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'day': day.name.toLowerCase(),
      'workFrom': from.formattedIn12Hour,
      'workTo': to.formattedIn12Hour,
      'isAvailable': isAvailable
    };
  }
}
