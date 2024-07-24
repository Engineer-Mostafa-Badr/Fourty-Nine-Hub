import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/work_day_entity.dart';

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
      day: json['day'],
      from: json['workFrom'],
      to: json['workTo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'workFrom': from,
      'workTo': to,
    };
  }
}
