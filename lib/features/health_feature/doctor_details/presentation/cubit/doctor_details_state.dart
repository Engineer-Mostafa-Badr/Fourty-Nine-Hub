part of 'doctor_details_cubit.dart';

sealed class DoctorDetailsState {}

final class DoctorDetailsInitial extends DoctorDetailsState {}

final class DoctorDetailsStartLoading extends DoctorDetailsState {}

final class DoctorDetailsReviewsLoaded extends DoctorDetailsState {
  final List<UserDoctorRateEntity> rates;
  DoctorDetailsReviewsLoaded(this.rates);
}

final class DoctorDetailsCheckCallAndMessage extends DoctorDetailsState {
  final bool enabled;
  DoctorDetailsCheckCallAndMessage(this.enabled);
}

final class DoctorDetailsLoaded extends DoctorDetailsState {
  DoctorDetailsLoaded();
}

final class DoctorDetailsError extends DoctorDetailsState {
  final String message;
  DoctorDetailsError(this.message);
}
