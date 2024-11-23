part of 'doctor_dashboard_cubit.dart';

sealed class DoctorDashboardState {}

final class DoctorDashboardInitial extends DoctorDashboardState {}

final class DoctorDashboardSupscriptionRemainingDays
    extends DoctorDashboardState {
  final int days;
  DoctorDashboardSupscriptionRemainingDays(this.days);
}

final class DoctorInfoSuccessState extends DoctorDashboardState {
  final DoctorInfoEntity info;
  DoctorInfoSuccessState(this.info);
}

final class DoctorDashboardIDRemainingDays extends DoctorDashboardState {
  final int days;
  DoctorDashboardIDRemainingDays(this.days);
}

final class DoctorDashboardPracticingRemainingDays
    extends DoctorDashboardState {
  final int days;
  DoctorDashboardPracticingRemainingDays(this.days);
}

final class DoctorDashboardError extends DoctorDashboardState {
  final String message;
  DoctorDashboardError(this.message);
}

final class DoctorDashboardTodayAppointments extends DoctorDashboardState {
  final List<DoctorAppointmentEntity> appointments;
  DoctorDashboardTodayAppointments(this.appointments);
}

final class DoctorDashboardUnhandledAppointments extends DoctorDashboardState {
  final List<DoctorAppointmentEntity> appointments;
  DoctorDashboardUnhandledAppointments(this.appointments);
}

final class DoctorDashboardStartLoading extends DoctorDashboardState {}

final class DoctorDashboardStopLoading extends DoctorDashboardState {}

final class DoctorDashboardShowSuccessfulMessage extends DoctorDashboardState {
  final String message;
  DoctorDashboardShowSuccessfulMessage(this.message);
}
