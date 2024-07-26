import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/work_day_entity.dart';

class DoctorWorkDayModel extends DoctorWorkDayEntity {
  DoctorWorkDayModel({required super.day, super.from, super.to});

  factory DoctorWorkDayModel.fromEntity(DoctorWorkDayEntity entity) {
    return DoctorWorkDayModel(
      day: entity.day,
      from: entity.from,
      to: entity.to,
    );
  }

  factory DoctorWorkDayModel.fromJson(Map<String, dynamic> json) {
    return DoctorWorkDayModel(
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
