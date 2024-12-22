import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/work_day_entity.dart';

class DoctorWorkDaysEntity {
  final String id;
  final List<WorkDayEntity> clinic;
  final List<WorkDayEntity> visitHome;
  final List<WorkDayEntity> calls;
  final String doctorId;
  final String clinicPrice;
  final String waitingTime;
  final String detectionPeriodClinic;
  final String visitHomePrice;
  final String detectionPeriodVisitHome;
  final String callsPrice;
  final String detectionPeriodCalls;
  final String createdAt;
  final String updatedAt;

  DoctorWorkDaysEntity({required this.id, required this.clinic, required this.visitHome, required this.calls, required this.doctorId, required this.clinicPrice, required this.waitingTime, required this.detectionPeriodClinic, required this.visitHomePrice, required this.detectionPeriodVisitHome, required this.callsPrice, required this.detectionPeriodCalls, required this.createdAt, required this.updatedAt});
}