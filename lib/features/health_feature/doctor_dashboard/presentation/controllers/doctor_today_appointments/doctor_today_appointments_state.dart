part of 'doctor_today_appointments_cubit.dart';

sealed class DoctorTodayAppointmentsState extends Equatable {
  const DoctorTodayAppointmentsState();

  @override
  List<Object> get props => [];
}

final class DoctorTodayAppointmentsInitial
    extends DoctorTodayAppointmentsState {}

final class DoctorTodayAppointmentsLoading
    extends DoctorTodayAppointmentsState {}

final class DoctorTodayAppointmentsLoaded extends DoctorTodayAppointmentsState {
  final List<DoctorAppointmentEntity> appointments;
  const DoctorTodayAppointmentsLoaded(this.appointments);
}

final class DoctorTodayAppointmentsError extends DoctorTodayAppointmentsState {
  final String message;
  const DoctorTodayAppointmentsError(this.message);
}
