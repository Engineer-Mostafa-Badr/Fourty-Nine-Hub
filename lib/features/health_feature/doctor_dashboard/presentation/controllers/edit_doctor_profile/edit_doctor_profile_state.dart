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
  final bool? update;
  EditDoctorProfileState({
    this.status = EditDoctorProfileStateStatus.initial,
    this.failure,
    this.update=false,
    this.doctor,
  });
  EditDoctorProfileState copyWith({
    EditDoctorProfileStateStatus? status,
    Failure? failure,
    DoctorEntity? doctor,
    bool? update,
  }) {
    return EditDoctorProfileState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      doctor: doctor ?? this.doctor,
      update: update ?? this.update,
    );
  }
}
