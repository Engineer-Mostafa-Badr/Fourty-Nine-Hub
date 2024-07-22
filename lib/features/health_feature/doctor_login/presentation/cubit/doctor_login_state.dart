part of 'doctor_login_cubit.dart';

enum DoctorLoginStates { loading, initState, error }

class DoctorLoginState {
  final DoctorLoginStates status;
  final Failure? failure;
  final bool hasCall;
  final bool hasHomeVisit;
   DoctorLoginState({
    this.status = DoctorLoginStates.loading,
    this.failure,
    this.hasCall = false,
    this.hasHomeVisit = false,
  });
  DoctorLoginState copyWith({
    DoctorLoginStates? status,
    Failure? failure,
    bool? hasCall,
    bool? hasHomeVisit,
  }) {
    return DoctorLoginState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      hasCall: hasCall ?? this.hasCall,
      hasHomeVisit: hasHomeVisit ?? this.hasHomeVisit,
    );
  }
}
