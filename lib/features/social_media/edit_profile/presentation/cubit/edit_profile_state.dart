part of 'edit_profile_cubit.dart';

enum EditProfileStates { loading, initial, success, error }

class EditProfileState {
  final EditProfileStates status;
  final Failure? failure;
  bool? isMale;
  String? selectedCityPrivacy;
  String? selectedBioPrivacy;
  String? selectedPhonePrivacy;
  String? selectedJobPrivacy;
  String? selectedCountryPrivacy;

  EditProfileState(
      {this.status = EditProfileStates.error,
      this.failure,
      this.isMale=true,
  this.selectedCityPrivacy,
  this.selectedBioPrivacy,
  this.selectedPhonePrivacy,
  this.selectedJobPrivacy,
  this.selectedCountryPrivacy,
      });
  EditProfileState copyWith({
    EditProfileStates? status,
    Failure? failure,
    bool? isMale,
    String? selectedCityPrivacy,
    String? selectedBioPrivacy,
    String? selectedPhonePrivacy,
    String? selectedJobPrivacy,
    String? selectedCountryPrivacy,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isMale: isMale ?? this.isMale,
      selectedCityPrivacy: selectedCityPrivacy ?? this.selectedCityPrivacy,
      selectedBioPrivacy: selectedBioPrivacy ?? this.selectedBioPrivacy,
      selectedPhonePrivacy: selectedPhonePrivacy ?? this.selectedPhonePrivacy,
      selectedJobPrivacy: selectedJobPrivacy ?? this.selectedJobPrivacy,
      selectedCountryPrivacy: selectedCountryPrivacy ?? this.selectedCountryPrivacy,
    );
  }
}
