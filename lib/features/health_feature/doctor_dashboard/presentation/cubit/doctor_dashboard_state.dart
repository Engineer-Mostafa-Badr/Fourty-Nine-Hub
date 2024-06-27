part of 'doctor_dashboard_cubit.dart';

enum DoctorDashboardStates { loading, error, initState, success }

extension DoctorDashboardStateX on DoctorDashboardState {
  bool get isLoading => status == DoctorDashboardStates.loading;
  bool get isError => status == DoctorDashboardStates.error;
  bool get isInitState => status == DoctorDashboardStates.initState;
  bool get isSuccess => status == DoctorDashboardStates.success;
}

class DoctorDashboardState {
  final DoctorDashboardStates status;
  final Failure? failure;
  final String? successMessage;
  final List<AppointmentBookingEntity>? bookings;
  final DateTime? date;
  const DoctorDashboardState(
      {this.status = DoctorDashboardStates.loading,
      this.failure,
      this.bookings,
      this.date,
      this.successMessage});
  DoctorDashboardState copyWith({
    DoctorDashboardStates? status,
    Failure? failure,
    String? successMessage,
    DateTime? date,
    List<AppointmentBookingEntity>? bookings,
  }) {
    return DoctorDashboardState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      bookings: bookings ?? this.bookings,
      date: date?? this.date,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
