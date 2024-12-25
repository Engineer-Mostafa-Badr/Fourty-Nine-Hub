part of 'edit_doctor_personal_info_cubit.dart';

enum EditDoctorPersonalInfoStates {
  loading,
  loadCities,
  loadCitiesSuccess,
  error,
  success,
  initState,
  addCart
}

extension EditDoctorPersonalInfoStateX on EditDoctorPersonalInfoState {
  bool get isInitial => status == EditDoctorPersonalInfoStates.initState;
  bool get isSuccess => status == EditDoctorPersonalInfoStates.success;
  bool get isAddToCart => status == EditDoctorPersonalInfoStates.addCart;
  bool get isLoadingCities => status == EditDoctorPersonalInfoStates.loadCities;
  bool get isLoadingCitiesSuccess =>
      status == EditDoctorPersonalInfoStates.loadCitiesSuccess;

  bool get isLoading => status == EditDoctorPersonalInfoStates.loading;

  bool get isError => status == EditDoctorPersonalInfoStates.error;
}

class EditDoctorPersonalInfoState {
  final EditDoctorPersonalInfoStates? status;
  final Failure? failure;
  final String? selectedSpeciality;
  final List<GovernorateEntity>? governorates;
  final List<HealthSubcategoryEntity>? speciality;
  final List<CityEntity>? cities;
  final String? selectedGovernorateId;
  final String? selectedCityId;

  const EditDoctorPersonalInfoState({
    this.status,
    this.failure,
    this.selectedSpeciality,
    this.selectedGovernorateId,
    this.speciality,
    this.governorates,
    this.cities,
    this.selectedCityId,
  });

  EditDoctorPersonalInfoState copyWith({
    EditDoctorPersonalInfoStates? status,
    Failure? failure,
    List<GovernorateEntity>? governorates,
    List<CityEntity>? cities,
    List<HealthSubcategoryEntity>? speciality,
    String? selectedSpeciality,
    String? selectedGovernorateId,
    String? selectedCityId,
  }) {
    return EditDoctorPersonalInfoState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      selectedSpeciality: selectedSpeciality ?? this.selectedSpeciality,
      selectedGovernorateId:
          selectedGovernorateId ?? this.selectedGovernorateId,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      speciality: speciality ?? this.speciality,
    );
  }
}
