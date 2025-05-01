part of 'doctors_list_cubit.dart';

enum DoctorsListStates { loading, initState, error, success }

extension DoctorsListStateX on DoctorsListState {
  bool get isInitial => status == DoctorsListStates.initState;
  bool get isLoading => status == DoctorsListStates.loading;
  bool get isError => status == DoctorsListStates.error;
  bool get isSuccess => status == DoctorsListStates.success;
}

class DoctorsListState {
  final DoctorsListStates? status;
  final Failure? failure;
  final bool? isLast;
  final List<DoctorEntity>? doctors;
  final List<MostBookingEntity>? doctorsList;

  const DoctorsListState({
    this.status,
    this.failure,
    this.doctors,
    this.isLast,
    this.doctorsList,
  });
  DoctorsListState copyWith({
    DoctorsListStates? status,
    Failure? failure,
    List<DoctorEntity>? doctors,
    List<MostBookingEntity>? doctorsList,
  }) {
    return DoctorsListState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      doctors: doctors ?? this.doctors,
      doctorsList: doctorsList ?? this.doctorsList,
    );
  }
}
