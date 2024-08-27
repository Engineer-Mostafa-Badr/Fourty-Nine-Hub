part of 'create_resturant_cubit.dart';

sealed class CreateResturantState {}

final class CreateResturantInitial extends CreateResturantState {}

final class CreateResturantLoading extends CreateResturantState {
  final String message;
  CreateResturantLoading(this.message);
}

final class CreateResturantCloseLoading extends CreateResturantState {}

final class CreateResturantLoaded extends CreateResturantState {}

final class CreateResturantSuccess extends CreateResturantState {
  final String message;
  CreateResturantSuccess(this.message);
}

final class CreateResturantError extends CreateResturantState {
  final String message;
  CreateResturantError(this.message);
}

final class CreateResturantCitiesLoaded extends CreateResturantState {
  final List<CityEntity> cities;
  CreateResturantCitiesLoaded(this.cities);
}

final class CreateResturantCitiesLoading extends CreateResturantState {}

final class CreateResturantGovernoratesLoaded extends CreateResturantState {
  final List<GovernorateEntity> governorates;
  CreateResturantGovernoratesLoaded(this.governorates);
}

final class CreateResturantSubCategoriesLoaded extends CreateResturantState {
  final List<SubCategoryEntity> subCategories;
  CreateResturantSubCategoriesLoaded(this.subCategories);
}

final class CreateResturantUploadProfileImage extends CreateResturantState {
  final XFile file;
  CreateResturantUploadProfileImage(this.file);
}

final class CreateResturantUploadIdFrontImage extends CreateResturantState {
  final XFile file;
  CreateResturantUploadIdFrontImage(this.file);
}

final class CreateResturantUploadIdBehindImage extends CreateResturantState {
  final XFile file;
  CreateResturantUploadIdBehindImage(this.file);
}

final class CreateResturantUploadPracticingFrontImage
    extends CreateResturantState {
  final XFile file;
  CreateResturantUploadPracticingFrontImage(this.file);
}

final class CreateResturantUploadPracticingBehindImage
    extends CreateResturantState {
  final XFile file;
  CreateResturantUploadPracticingBehindImage(this.file);
}

final class CreateResturantShowClinic extends CreateResturantState {
  final bool check;
  CreateResturantShowClinic(this.check);
}

final class CreateResturantShowCall extends CreateResturantState {
  final bool check;
  CreateResturantShowCall(this.check);
}

final class CreateResturantShowHomeVisit extends CreateResturantState {
  final bool check;
  CreateResturantShowHomeVisit(this.check);
}
