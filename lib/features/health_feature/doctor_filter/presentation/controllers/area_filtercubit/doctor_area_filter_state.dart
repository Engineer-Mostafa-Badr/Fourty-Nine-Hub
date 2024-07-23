part of 'doctor_area_filter_cubit.dart';

sealed class DoctorAreaFilterState {}

final class DoctorAreaFilterInitial extends DoctorAreaFilterState {}

final class DoctorAreaFilterLoading extends DoctorAreaFilterState {}

final class DoctorAreaFilterLoaded extends DoctorAreaFilterState {
  final List<String> areas;
  DoctorAreaFilterLoaded({required this.areas});
}

class Entity {}

final class DoctorAreaFilterError extends DoctorAreaFilterState {
  final String message;
  DoctorAreaFilterError({required this.message});
}
