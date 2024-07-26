part of 'doctors_list_cubit.dart';

enum DoctorsListStates { loading, error, initState }

class DoctorsListState {
  final DoctorsListStates status;
  final Failure? failure;
  final List<DoctorEntity>? doctors;
  final List<CityModel>? cities;
  final CityModel? selectedCity;
  final List<StateModel>? states;
  final StateModel? selectedState;
  const DoctorsListState(
      {this.status = DoctorsListStates.loading,
      this.failure,
      this.doctors,
      this.cities,
      this.states, this.selectedCity, this.selectedState});
  DoctorsListState copyWith({
    DoctorsListStates? status,
    Failure? failure,
    List<DoctorEntity>? doctors,
    List<CityModel>? cities,
    CityModel? selectedCity,
    List<StateModel>? states,
    StateModel? selectedState,
  }) {
    return DoctorsListState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      doctors: doctors ?? this.doctors,
      cities: cities ?? this.cities,
      states: states ?? this.states,
      selectedCity: selectedCity?? this.selectedCity,
      selectedState: selectedState?? this.selectedState,
    );
  }
}
