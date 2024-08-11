part of 'edit_doctor_profile_cubit.dart';

sealed class EditDoctorProfileState {}

final class EditDoctorProfileInitial extends EditDoctorProfileState {}

final class EditDoctorProfileLoading extends EditDoctorProfileState {}

final class EditDoctorProfileLoaded extends EditDoctorProfileState {
  final DoctorEntity doctor;
  EditDoctorProfileLoaded(this.doctor);
}

final class EditDoctorProfileError extends EditDoctorProfileState {
  final String message;
  EditDoctorProfileError(this.message);
}
