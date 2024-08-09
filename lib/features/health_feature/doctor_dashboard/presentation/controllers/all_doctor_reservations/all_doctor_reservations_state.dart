part of 'all_doctor_reservations_cubit.dart';

sealed class AllDoctorReservationsState {}

final class AllDoctorReservationsInitial extends AllDoctorReservationsState {}

final class AllDoctorReservationsLoading extends AllDoctorReservationsState {}

final class AllDoctorReservationsLoaded extends AllDoctorReservationsState {
  final List<DoctorAppointmentEntity> reservations;
  AllDoctorReservationsLoaded(this.reservations);
}

final class AllDoctorReservationsError extends AllDoctorReservationsState {
  final String message;
  AllDoctorReservationsError(this.message);
}
