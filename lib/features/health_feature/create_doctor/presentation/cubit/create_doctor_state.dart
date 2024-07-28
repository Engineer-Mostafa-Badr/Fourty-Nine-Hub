part of 'create_doctor_cubit.dart';

sealed class CreateDoctorState {}

final class CreateDoctorInitial extends CreateDoctorState {}

final class CreateDoctorLoading extends CreateDoctorState {
  final String message;
  CreateDoctorLoading(this.message);
}

final class CreateDoctorCloseLoading extends CreateDoctorState {}

final class CreateDoctorLoaded extends CreateDoctorState {}

final class CreateDoctorSuccess extends CreateDoctorState {
  final String message;
  CreateDoctorSuccess(this.message);
}

final class CreateDoctorError extends CreateDoctorState {
  final String message;
  CreateDoctorError(this.message);
}

final class CreateDoctorCitiesLoaded extends CreateDoctorState {
  final List<CityEntity> cities;
  CreateDoctorCitiesLoaded(this.cities);
}

final class CreateDoctorCitiesLoading extends CreateDoctorState {}

final class CreateDoctorGovernoratesLoaded extends CreateDoctorState {
  final List<GovernorateEntity> governorates;
  CreateDoctorGovernoratesLoaded(this.governorates);
}

final class CreateDoctorSubCategoriesLoaded extends CreateDoctorState {
  final List<SubCategoryEntity> subCategories;
  CreateDoctorSubCategoriesLoaded(this.subCategories);
}

final class CreateDoctorUploadProfileImage extends CreateDoctorState {
  final XFile file;
  CreateDoctorUploadProfileImage(this.file);
}

final class CreateDoctorUploadIdFrontImage extends CreateDoctorState {
  final XFile file;
  CreateDoctorUploadIdFrontImage(this.file);
}

final class CreateDoctorUploadIdBehindImage extends CreateDoctorState {
  final XFile file;
  CreateDoctorUploadIdBehindImage(this.file);
}

final class CreateDoctorUploadPracticingFrontImage extends CreateDoctorState {
  final XFile file;
  CreateDoctorUploadPracticingFrontImage(this.file);
}

final class CreateDoctorUploadPracticingBehindImage extends CreateDoctorState {
  final XFile file;
  CreateDoctorUploadPracticingBehindImage(this.file);
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
