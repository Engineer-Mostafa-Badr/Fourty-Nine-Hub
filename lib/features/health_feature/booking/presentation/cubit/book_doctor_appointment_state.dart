part of 'book_doctor_appointment_cubit.dart';

sealed class BookDoctorAppointmentState {}

final class BookDoctorAppointmentInitialState
    extends BookDoctorAppointmentState {}

final class BookDoctorAppointmentSuccessState
    extends BookDoctorAppointmentState {}

final class BookDoctorAppointmentErrorState extends BookDoctorAppointmentState {
  final String message;
  BookDoctorAppointmentErrorState(this.message);
}

final class BookDoctorAppointmentStartLoadingState
    extends BookDoctorAppointmentState {}

final class BookDoctorAppointmentEndLoadingState
    extends BookDoctorAppointmentState {}

final class BookDoctorAppointmentShowSubscriptionPlansState
    extends BookDoctorAppointmentState {}
