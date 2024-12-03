part of 'emergency_requests_cubit.dart';

enum EmergencyRequestsStates { loading, initState, error, success }

extension EmergencyRequestsStateX on EmergencyRequestsState {
  bool get isInitial => status == EmergencyRequestsStates.initState;
  bool get isLoading => status == EmergencyRequestsStates.loading;
  bool get isError => status == EmergencyRequestsStates.error;
  bool get isSuccess => status == EmergencyRequestsStates.success;
}

class EmergencyRequestsState {
  final EmergencyRequestsStates? status;
  final Failure? failure;
  final bool? isLast;
  final List<EmergencyEntity>? emergencies;
  const EmergencyRequestsState({
    this.status,
    this.failure,
    this.emergencies,
    this.isLast,
  });
  EmergencyRequestsState copyWith({
    EmergencyRequestsStates? status,
    Failure? failure,
    bool? isLast,
    List<EmergencyEntity>? emergencies,
  }) {
    return EmergencyRequestsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      emergencies: emergencies ?? this.emergencies,
      isLast: isLast ?? this.isLast,
    );
  }
}
