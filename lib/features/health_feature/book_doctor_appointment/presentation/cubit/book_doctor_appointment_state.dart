part of 'book_doctor_appointment_cubit.dart';

enum BookDoctorAppointmentStates { loading, error, initState }



extension BookDoctorAppointmentStateX on BookDoctorAppointmentState {
  bool get isLoading => status == BookDoctorAppointmentStates.loading;
  bool get isInitState => status == BookDoctorAppointmentStates.initState;
  bool get isError => status == BookDoctorAppointmentStates.error;
}

class BookDoctorAppointmentState {
  final BookDoctorAppointmentStates status;
  final Failure? failure;
  final DoctorEntity? doctor;
  final DateTime? date;
  final List<AppointmentEntity>? appointments;
  final AppointmentEntity? selectedAppointment;
  final BookingTypes bookingType;
  const BookDoctorAppointmentState(
      {this.status = BookDoctorAppointmentStates.loading,
      this.failure,
      this.doctor,
      this.appointments,
      this.bookingType = BookingTypes.clinic,
      this.selectedAppointment,
      this.date});

  BookDoctorAppointmentState copyWith(
      {BookDoctorAppointmentStates? status,
      Failure? failure,
      DoctorEntity? doctor,
      DateTime? date,
      AppointmentEntity? selectedAppointment,
      BookingTypes? bookingType,
      List<AppointmentEntity>? appointments}) {
    return BookDoctorAppointmentState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        doctor: doctor ?? this.doctor,
        date: date ?? this.date,
        bookingType: bookingType ?? this.bookingType,
        appointments: appointments ?? this.appointments,
        selectedAppointment: selectedAppointment ?? this.selectedAppointment);
  }
}
