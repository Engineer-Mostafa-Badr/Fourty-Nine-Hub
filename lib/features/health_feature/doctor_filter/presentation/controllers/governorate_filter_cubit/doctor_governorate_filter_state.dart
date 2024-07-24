part of 'doctor_governorate_filter_cubit.dart';

sealed class DoctorGovernorateFilterState {}

final class DoctorGovernorateFilterInitial
    extends DoctorGovernorateFilterState {}

final class DoctorGovernorateFilterLoading
    extends DoctorGovernorateFilterState {}

final class DoctorGovernorateFilterLoaded extends DoctorGovernorateFilterState {
  final List<GovernorateEntity> governorates;
  DoctorGovernorateFilterLoaded( this.governorates);
}

class Entity {}

final class DoctorGovernorateFilterError extends DoctorGovernorateFilterState {
  final String message;
  DoctorGovernorateFilterError(this.message);
}
