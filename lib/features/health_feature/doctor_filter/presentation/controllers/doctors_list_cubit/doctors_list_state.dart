part of 'doctors_list_cubit.dart';

sealed class DoctorsListState {}

class DoctorsListInitial extends DoctorsListState {}

class DoctorsListLoading extends DoctorsListState {}

class DoctorsListLoaded extends DoctorsListState {
  final List<DoctorEntity> doctors;

  DoctorsListLoaded(this.doctors);
}

class DoctorsListError extends DoctorsListState {
  final String message;

  DoctorsListError(this.message);
}
