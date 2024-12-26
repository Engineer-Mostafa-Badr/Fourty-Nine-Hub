import 'package:fourtyninehub/features/health_feature/doctor_dashboard/data/models/work_day_model.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_work_days_entity.dart';

class DoctorWorkDaysModel extends DoctorWorkDaysEntity {
  DoctorWorkDaysModel(
      {required super.id,
      required super.clinic,
      required super.visitHome,
      required super.calls,
      required super.doctorId,
      required super.clinicPrice,
      required super.waitingTime,
      required super.detectionPeriodClinic,
      required super.visitHomePrice,
      required super.detectionPeriodVisitHome,
      required super.callsPrice,
      required super.detectionPeriodCalls,
      required super.createdAt,
      required super.updatedAt});

  //fromJson
  factory DoctorWorkDaysModel.fromJson(Map<String, dynamic> json) =>
      DoctorWorkDaysModel(
          id: json['_id'] ?? '',
          clinic: List.from(json['clinic']['workDays'])
              .map((e) => WorkDayModel.fromJson(e))
              .toList(),
          visitHome: List.from(json['visitHome']['workDays'])
              .map((e) => WorkDayModel.fromJson(e))
              .toList(),
          calls: List.from(json['calls']['workDays'])
              .map((e) => WorkDayModel.fromJson(e))
              .toList(),
          doctorId: json['doctorId'] ?? '',
          clinicPrice: json['clinicPrice'] ?? '',
          waitingTime: json['waitingTime'] ?? '',
          detectionPeriodClinic: json['detectionPeriodClinic'] ?? '',
          visitHomePrice: json['visitHomePrice'] ?? '',
          detectionPeriodVisitHome: json['detectionPeriodVisitHome'] ?? '',
          callsPrice: json['callsPrice'] ?? '',
          detectionPeriodCalls: json['detectionPeriodCalls'] ?? '',
          createdAt: json['createdAt'] ?? '',
          updatedAt: json['updatedAt' ?? '']);
}
