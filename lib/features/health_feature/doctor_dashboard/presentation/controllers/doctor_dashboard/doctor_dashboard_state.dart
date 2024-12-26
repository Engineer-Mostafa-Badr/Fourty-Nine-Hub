part of 'doctor_dashboard_cubit.dart';

enum DoctorDashboardStateStatus {
  initial,
  startLoading,
  startCancelLoading,
  endCancelLoading,
  startAcceptLoading,
  endAcceptLoading,
  editLoading,
  editSuccess,
  getDoctor,
  error,
  doctorDeleted,
  updated,
}

class DoctorDashboardState {
  final DoctorDashboardStateStatus status;
  final Failure? failure;
  final int? subscriptionRemainingDays;
  final int? practicingRemainingDays;
  final int? iDRemainingDays;
  final DoctorInfoEntity? info;
  final List<DoctorAppointmentEntity>? todayAppointments;
  final List<DoctorAppointmentEntity>? unhandledAppointments;
  DoctorDashboardState({
    this.status = DoctorDashboardStateStatus.initial,
    this.failure,
    this.subscriptionRemainingDays,
    this.practicingRemainingDays,
    this.iDRemainingDays,
    this.info,
    this.todayAppointments,
    this.unhandledAppointments,
  });
  DoctorDashboardState copyWith({
    DoctorDashboardStateStatus? status,
    Failure? failure,
    int? subscriptionRemainingDays,
    int? practicingRemainingDays,
    int? iDRemainingDays,
    DoctorInfoEntity? info,
    List<DoctorAppointmentEntity>? todayAppointments,
    List<DoctorAppointmentEntity>? unhandledAppointments,
  }) {
    return DoctorDashboardState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        subscriptionRemainingDays:
            subscriptionRemainingDays ?? this.subscriptionRemainingDays,
        practicingRemainingDays:
            practicingRemainingDays ?? this.practicingRemainingDays,
        iDRemainingDays: iDRemainingDays ?? this.iDRemainingDays,
        info: info ?? this.info,
        todayAppointments: todayAppointments ?? this.todayAppointments,
        unhandledAppointments:
            unhandledAppointments ?? this.unhandledAppointments);
  }
}
