part of 'create_doctor_cubit.dart';

sealed class CreateDoctorState {}

final class CreateDoctorInitial extends CreateDoctorState {}

final class CreateDoctorLoading extends CreateDoctorState {}

final class CreateDoctorLoaded extends CreateDoctorState {}

final class CreateDoctorError extends CreateDoctorState {
  final String message;
  CreateDoctorError(this.message);
}

final class CreateDoctorCityLoaded extends CreateDoctorState {
  final List<String> cities;
  CreateDoctorCityLoaded(this.cities);
}

final class CreateDoctorGovernorateLoaded extends CreateDoctorState {
  final List<String> governorates;
  CreateDoctorGovernorateLoaded(this.governorates);
}

final class CreateDoctorShowClinic extends CreateDoctorState {
  final bool check;
  CreateDoctorShowClinic(this.check);
}

final class CreateDoctorShowCall extends CreateDoctorState {
  final bool check;
  CreateDoctorShowCall(this.check);
}

final class CreateDoctorShowHomeVisit extends CreateDoctorState {
  final bool check;
  CreateDoctorShowHomeVisit(this.check);
}
