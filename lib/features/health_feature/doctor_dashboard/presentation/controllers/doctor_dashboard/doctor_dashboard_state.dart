part of 'doctor_dashboard_cubit.dart';

sealed class DoctorDashboardState {}

final class DoctorDashboardInitial extends DoctorDashboardState {}

final class DoctorDAshboardSupscriptionRemainingDays
    extends DoctorDashboardState {
  final int days;
  DoctorDAshboardSupscriptionRemainingDays(this.days);
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
