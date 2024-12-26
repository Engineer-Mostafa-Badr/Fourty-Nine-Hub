part of 'doctor_unhandled_appotinments_cubit.dart';

enum DoctorUnhandledAppointmentsStates { loading, initState, error, success }

extension DoctorUnhandledAppointmentsStateX
    on DoctorUnhandledAppointmentsState {
  bool get isInitial => status == DoctorUnhandledAppointmentsStates.initState;
  bool get isLoading => status == DoctorUnhandledAppointmentsStates.loading;
  bool get isError => status == DoctorUnhandledAppointmentsStates.error;
  bool get isSuccess => status == DoctorUnhandledAppointmentsStates.success;
}

class DoctorUnhandledAppointmentsState {
  final DoctorUnhandledAppointmentsStates? status;
  final Failure? failure;
  final bool? isLast;
  final List<DoctorAppointmentEntity>? appointments;
  const DoctorUnhandledAppointmentsState({
    this.status,
    this.failure,
    this.appointments,
    this.isLast,
  });
  DoctorUnhandledAppointmentsState copyWith({
    DoctorUnhandledAppointmentsStates? status,
    Failure? failure,
    bool? isLast,
    List<DoctorAppointmentEntity>? appointments,
  }) {
    return DoctorUnhandledAppointmentsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      appointments: appointments ?? this.appointments,
      isLast: isLast ?? this.isLast,
    );
  }
}
