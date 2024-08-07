part of 'doctor_unhandled_appotinments_cubit.dart';

sealed class DoctorUnhandledAppointmentsState {
  const DoctorUnhandledAppointmentsState();
}

final class DoctorUnhandledAppointmentsInitial
    extends DoctorUnhandledAppointmentsState {}

final class DoctorUnhandledAppointmentsLoading
    extends DoctorUnhandledAppointmentsState {}

final class DoctorUnhandledAppointmentsLoaded
    extends DoctorUnhandledAppointmentsState {
  final List<DoctorAppointmentEntity> appointments;
  const DoctorUnhandledAppointmentsLoaded(this.appointments);
}

final class DoctorUnhandledAppointmentsError
    extends DoctorUnhandledAppointmentsState {
  final String message;
  const DoctorUnhandledAppointmentsError(this.message);
}

final class DoctorUnhandledAppotinmentsShowSuccessfulMessage
    extends DoctorUnhandledAppointmentsState {
  final String message;
  const DoctorUnhandledAppotinmentsShowSuccessfulMessage(this.message);
}
