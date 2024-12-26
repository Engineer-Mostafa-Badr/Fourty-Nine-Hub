part of 'all_appointments_cubit.dart';

enum AllAppointmentsStates {
  loading,
  startLoading,
  endLoading,
  initState,
  error,
  success
}

extension AllAppointmentsStateX on AllAppointmentsState {
  bool get isInitial => status == AllAppointmentsStates.initState;
  bool get isLoading => status == AllAppointmentsStates.loading;
  bool get isStartLoading => status == AllAppointmentsStates.startLoading;
  bool get isEndLoading => status == AllAppointmentsStates.endLoading;
  bool get isError => status == AllAppointmentsStates.error;
  bool get isSuccess => status == AllAppointmentsStates.success;
}

class AllAppointmentsState {
  final AllAppointmentsStates? status;
  final Failure? failure;
  final bool? isLast;
  final List<AdRequestEntity>? requests;
  const AllAppointmentsState({
    this.status,
    this.failure,
    this.requests,
    this.isLast,
  });
  AllAppointmentsState copyWith({
    AllAppointmentsStates? status,
    Failure? failure,
    bool? isLast,
    List<AdRequestEntity>? requests,
  }) {
    return AllAppointmentsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      requests: requests ?? this.requests,
      isLast: isLast ?? this.isLast,
    );
  }
}
