part of 'doctor_details_cubit.dart';

enum DoctorDetailsStates { loading, error, initState }

extension DoctorDetailsStateX on DoctorDetailsState {
  bool get isLoading => status == DoctorDetailsStates.loading;
  bool get isInitState => status == DoctorDetailsStates.initState;
  bool get isError => status == DoctorDetailsStates.error;
}

class DoctorDetailsState {
  final DoctorDetailsStates status;
  final Failure? failure;
  final DoctorEntity? doctor;

  const DoctorDetailsState({
    this.status = DoctorDetailsStates.loading,
    this.failure,
    this.doctor,
  });

  DoctorDetailsState copyWith(
      {DoctorDetailsStates? status, Failure? failure, DoctorEntity? doctor}) {
    return DoctorDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      doctor: doctor ?? this.doctor,
    );
  }
}
