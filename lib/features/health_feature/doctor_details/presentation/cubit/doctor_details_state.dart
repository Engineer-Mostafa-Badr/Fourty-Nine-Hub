part of 'doctor_details_cubit.dart';

sealed class DoctorDetailsState {}

final class DoctorDetailsInitial extends DoctorDetailsState {}

final class DoctorDetailsLoading extends DoctorDetailsState {}

final class DoctorDetailsLoaded extends DoctorDetailsState {
  final List<UserDoctorRateEntity> rates;
  DoctorDetailsLoaded(this.rates);
} 

final class DoctorDetailsError extends DoctorDetailsState {
  final String message;
  DoctorDetailsError(this.message);
}