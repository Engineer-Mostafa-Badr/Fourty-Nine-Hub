part of 'doctor_city_filter_cubit.dart';
sealed class DoctorCityFilterState {}

final class DoctorCityFilterInitial
    extends DoctorCityFilterState {}

final class DoctorCityFilterLoading
    extends DoctorCityFilterState {}

final class DoctorCityFilterLoaded extends DoctorCityFilterState {
  final List<String> cities;
  DoctorCityFilterLoaded({required this.cities});
}

class Entity {}

final class DoctorCityFilterError extends DoctorCityFilterState {
  final String message;
  DoctorCityFilterError({required this.message});
}
