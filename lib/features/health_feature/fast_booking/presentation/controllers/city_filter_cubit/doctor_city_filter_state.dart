part of 'doctor_city_filter_cubit.dart';

sealed class DoctorCityFilterState {}

final class DoctorCityFilterInitial extends DoctorCityFilterState {}

final class DoctorCityFilterLoading extends DoctorCityFilterState {}

final class DoctorCityFilterLoaded extends DoctorCityFilterState {
  final List<CityEntity> cities;
  DoctorCityFilterLoaded(this.cities);
}

final class DoctorCityFilterError extends DoctorCityFilterState {
  final String message;
  DoctorCityFilterError(this.message);
}
