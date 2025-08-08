part of 'edit_profile_cubit.dart';

enum EditProfileStates { loading, initial, success, error }

class EditProfileState {
  final EditProfileStates status;
  final EditProfileStates getGovernmentStatus;
  final List<GovernorateEntity>? governorates;
  String? selectedCity;
  final Failure? failure;
  bool? isMale;
  String? selectedCityPrivacy;
  String? selectedBioPrivacy;
  String? selectedPhonePrivacy;
  String? selectedStatus;
  String? selectedJobPrivacy;
  String? selectedCountryPrivacy;
  String? selectedStatusPrivacy;
  bool? isDriverLady;

  EditProfileState({
    this.status = EditProfileStates.initial,
    this.getGovernmentStatus = EditProfileStates.initial,
    this.failure,
    this.isMale = true,
    this.selectedCityPrivacy,
    this.selectedBioPrivacy,
    this.selectedPhonePrivacy,
    this.selectedStatus,
    this.selectedJobPrivacy,
    this.selectedStatusPrivacy,
    this.selectedCountryPrivacy,
    this.governorates,
    this.selectedCity,
    this.isDriverLady,
  });

  EditProfileState copyWith({
    EditProfileStates? status,
    EditProfileStates? getGovernmentStatus,
    Failure? failure,
    bool? isMale,
    String? selectedCityPrivacy,
    String? selectedBioPrivacy,
    String? selectedPhonePrivacy,
    String? selectedJobPrivacy,
    String? selectedStatus,
    String? selectedStatusPrivacy,
    String? selectedCountryPrivacy,
    String? selectedCity,
    bool? isDriverLady,
    List<GovernorateEntity>? governorates,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      isDriverLady: isDriverLady ?? this.isDriverLady,
      getGovernmentStatus: getGovernmentStatus ?? this.getGovernmentStatus,
      failure: failure ?? this.failure,
      isMale: isMale ?? this.isMale,
      selectedCityPrivacy: selectedCityPrivacy ?? this.selectedCityPrivacy,
      selectedBioPrivacy: selectedBioPrivacy ?? this.selectedBioPrivacy,
      selectedPhonePrivacy: selectedPhonePrivacy ?? this.selectedPhonePrivacy,
      selectedJobPrivacy: selectedJobPrivacy ?? this.selectedJobPrivacy,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedStatusPrivacy:
          selectedStatusPrivacy ?? this.selectedStatusPrivacy,
      selectedCountryPrivacy:
          selectedCountryPrivacy ?? this.selectedCountryPrivacy,
      selectedCity: selectedCity ?? this.selectedCity,
      governorates: governorates ?? this.governorates,
    );
  }
}
