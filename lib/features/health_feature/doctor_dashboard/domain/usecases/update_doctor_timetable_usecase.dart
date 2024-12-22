import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/create_doctor.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/repositories/doctor_dashboard_repo.dart';

class UpdateDoctorTimetableUsecase
    extends UseCase<bool, DoctorTimetableParams> {
  final DoctorDashboardRepo _repo;

  UpdateDoctorTimetableUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(params) {
    return _repo.updateTimetable(params);
  }
}

class DoctorTimetableParams {
  final bool hasClinic;
  final bool hasHomeVisit;
  final bool hasCalls;
  final WorkDaysParams? clinic ;
  final WorkDaysParams? calls ;
  final WorkDaysParams? visitHome ;
  final String? detectionPeriodClinic ;
  final String? detectionPeriodCalls ;
  final String? detectionPeriodvisitHome ;
  final String? clinicPrice ;
  final String? callsPrice ;
  final String? visitHomePrice ;
  final String? waitingTime ;

  DoctorTimetableParams({required this.hasClinic, required this.hasHomeVisit, required this.hasCalls, required this.clinic, required this.calls, required this.visitHome, required this.detectionPeriodClinic, required this.detectionPeriodCalls, required this.detectionPeriodvisitHome, required this.clinicPrice, required this.callsPrice, required this.visitHomePrice, required this.waitingTime});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hasClinic && clinic != null && clinic!.workDays.isNotEmpty) {
      data['clinic'] = clinic!.toJson();
    }
    if (hasCalls && calls != null && calls!.workDays.isNotEmpty) {
      data['calls'] = calls!.toJson();
    }
    if (hasHomeVisit && visitHome != null && visitHome!.workDays.isNotEmpty) {
      data['visitHome'] = visitHome!.toJson();
    }
    if (hasClinic &&
        detectionPeriodClinic != null &&
        detectionPeriodClinic!.isNotEmpty) {
      data['detectionPeriodClinic'] = '$detectionPeriodClinic min';
    }
    if (hasCalls &&
        detectionPeriodCalls != null &&
        detectionPeriodCalls!.isNotEmpty) {
      data['detectionPeriodCalls'] = '$detectionPeriodCalls min';
    }
    if (hasHomeVisit &&
        detectionPeriodvisitHome != null &&
        detectionPeriodvisitHome!.isNotEmpty) {
      data['detectionPeriodVisitHome'] = '$detectionPeriodvisitHome min';
    }
    if (hasClinic && clinicPrice != null && clinicPrice!.isNotEmpty) {
      data['clinicPrice'] = '$clinicPrice EGP';
    }
    if (hasCalls && callsPrice != null && callsPrice!.isNotEmpty) {
      data['callsPrice'] = '$callsPrice EGP';
    }
    if (hasHomeVisit && visitHomePrice != null && visitHomePrice!.isNotEmpty) {
      data['visitHomePrice'] = '$visitHomePrice EGP';
    }
    data['waitingTime'] = '$waitingTime min';
    return data;
  }

  String? isFilled() {
    // work days
    if (!hasClinic && !hasHomeVisit && !hasCalls) {
      return "Select at least one service (clinic or home visit or calls)";
    }
    if (hasClinic && (clinic == null || clinic!.workDays.isEmpty)) {
      return "Please choose your clinic days";
    }
    if (hasClinic &&
        ((clinicPrice ?? '').isEmpty ||
            (waitingTime?.isEmpty!=null&&waitingTime?.isEmpty!=[]) ||
            (detectionPeriodClinic ?? '').isEmpty)) {
      return "Please enter your clinic price, waiting time and examination period";
    }
    if (hasHomeVisit && (visitHome == null || visitHome!.workDays.isEmpty)) {
      return "Please choose your home visit days";
    }
    if (hasHomeVisit &&
        ((visitHomePrice ?? '').isEmpty ||
            (detectionPeriodvisitHome ?? '').isEmpty)) {
      return "Please enter your home visit price and examination period";
    }
    if (hasCalls && (calls == null || calls!.workDays.isEmpty)) {
      return "Please choose your calls days";
    }
    if (hasCalls &&
        ((callsPrice ?? "").isEmpty || (detectionPeriodCalls ?? "").isEmpty)) {
      return "Please enter your calls price and examination period";
    }

    return null;
  }
}


