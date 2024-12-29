part of 'doctor_details_cubit.dart';

enum DoctorDetailsStates { loading, initState, error, success }

extension DoctorDetailsStateX on DoctorDetailsState {
  bool get isInitial => status == DoctorDetailsStates.initState;
  bool get isLoading => status == DoctorDetailsStates.loading;
  bool get isError => status == DoctorDetailsStates.error;
  bool get isSuccess => status == DoctorDetailsStates.success;
}

class DoctorDetailsState {
  final DoctorDetailsStates? status;
  final Failure? failure;
  final bool? enabled;
  final DoctorEntity? doctor;
  final List<UserDoctorRateEntity>? rates;
  const DoctorDetailsState({
    this.status,
    this.failure,
    this.rates,
    this.enabled,
    this.doctor,
  });
  DoctorDetailsState copyWith({
    DoctorDetailsStates? status,
    Failure? failure,
    bool? enabled,
    DoctorEntity? doctor,
    List<UserDoctorRateEntity>? rates,
  }) {
    return DoctorDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      rates: rates ?? this.rates,
      enabled: enabled ?? this.enabled,
      doctor: doctor ?? this.doctor,
    );
  }
}
