part of 'edit_doctor_profile_cubit.dart';

enum EditDoctorProfileStateStatus {
  initial,
  startLoading,
  endLoading,
  getDoctor,
  error,
  doctorDeleted,
  updated,
}

class EditDoctorProfileState {
  final EditDoctorProfileStateStatus status;
  final DoctorEntity? doctor;
  final Failure? failure;
  EditDoctorProfileState({
    this.status = EditDoctorProfileStateStatus.initial,
    this.failure,
    this.doctor,
  });
  EditDoctorProfileState copyWith({
    EditDoctorProfileStateStatus? status,
    Failure? failure,
    DoctorEntity? doctor,
  }) {
    return EditDoctorProfileState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      doctor: doctor ?? this.doctor,
    );
  }
}
