part of 'edit_doctor_timetable_cubit.dart';


enum EditDoctorTimetableStateStatus {
  initial,
  startLoading,
  endLoading,
  getDoctor,
  error,
  doctorDeleted,
  updated,
}

class EditDoctorTimetableState {
  final EditDoctorTimetableStateStatus status;
  final Failure? failure;
  final List<DoctorDayEntity>? callTimetable;
  final List<DoctorDayEntity>? clinicTimetable;
  final List<DoctorDayEntity>? homeVisitTimetable;
  final DoctorWorkDaysEntity? doctorWorkDays;
  final bool? showCall;
  final bool? showHomeVisit;
  final bool? showClinic;
  EditDoctorTimetableState({
    this.status = EditDoctorTimetableStateStatus.initial,
    this.failure,
    this.callTimetable,
    this.clinicTimetable,
    this.doctorWorkDays,
    this.homeVisitTimetable,
    this.showCall=false,
    this.showHomeVisit=false,
    this.showClinic=false,
  });
  EditDoctorTimetableState copyWith({
    EditDoctorTimetableStateStatus? status,
    Failure? failure,
    List<DoctorDayEntity>? callTimetable,
    List<DoctorDayEntity>? clinicTimetable,
    List<DoctorDayEntity>? homeVisitTimetable,
    DoctorWorkDaysEntity? doctorWorkDays,
    bool? showCall,
    bool? showHomeVisit,
    bool? showClinic,
  }) {
    return EditDoctorTimetableState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      callTimetable: callTimetable ?? this.callTimetable,
      clinicTimetable: clinicTimetable ?? this.clinicTimetable,
      homeVisitTimetable: homeVisitTimetable ?? this.homeVisitTimetable,
      showCall: showCall ?? this.showCall,
      showHomeVisit: showHomeVisit ?? this.showHomeVisit,
      showClinic: showClinic ?? this.showClinic,
      doctorWorkDays: doctorWorkDays ?? this.doctorWorkDays
    );
  }
}
