part of 'doctor_today_appointments_cubit.dart';

enum DoctorTodayAppointmentsStates { loading,startCancelLoading,endCancelLoading, initState, error, success }

extension DoctorTodayAppointmentsStateX on DoctorTodayAppointmentsState {
  bool get isInitial => status == DoctorTodayAppointmentsStates.initState;
  bool get isLoading => status == DoctorTodayAppointmentsStates.loading;
  bool get isError => status == DoctorTodayAppointmentsStates.error;
  bool get isSuccess => status == DoctorTodayAppointmentsStates.success;
}

class DoctorTodayAppointmentsState {
  final DoctorTodayAppointmentsStates? status;
  final Failure? failure;
  final bool? isLast;
  final List<DoctorAppointmentEntity>? appointments;
  const DoctorTodayAppointmentsState({
    this.status,
    this.failure,
    this.appointments,
    this.isLast,
  });
  DoctorTodayAppointmentsState copyWith({
    DoctorTodayAppointmentsStates? status,
    Failure? failure,
    bool? isLast,
    List<DoctorAppointmentEntity>? appointments,
  }) {
    return DoctorTodayAppointmentsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      appointments: appointments ?? this.appointments,
      isLast: isLast ?? this.isLast,
    );
  }
}