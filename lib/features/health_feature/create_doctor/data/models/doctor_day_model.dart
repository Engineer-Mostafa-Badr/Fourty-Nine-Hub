import 'package:fourtyninehub/common/functions/helper/time_of_day_helper.dart';
import 'package:fourtyninehub/core/enums/week_days.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/doctor_day_entity.dart';

class DoctorDayModel extends DoctorDayEntity {
  DoctorDayModel({required super.day, super.from, super.to});

  factory DoctorDayModel.fromEntity(DoctorDayEntity entity) {
    return DoctorDayModel(
      day: entity.day,
      from: entity.from,
      to: entity.to,
    );
  }

  factory DoctorDayModel.fromJson(Map<String, dynamic> json) {
    return DoctorDayModel(
      day: (json['day'] as String).weekDay,
      from: json['workFrom'],
      to: json['workTo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day.name.toLowerCase(),
      'workFrom': from.display,
      'workTo': to.display,
    };
  }
}
