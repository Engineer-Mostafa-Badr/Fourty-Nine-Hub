part of 'create_resturant_cubit.dart';

sealed class CreateRestaurantState {}

final class CreateRestaurantInitial extends CreateRestaurantState {}

final class CreateResturantLoading extends CreateRestaurantState {
  final String message;
  CreateResturantLoading(this.message);
}

final class CreateResturantCloseLoading extends CreateRestaurantState {}

final class CreateResturantLoaded extends CreateRestaurantState {}

final class CreateResturantSuccess extends CreateRestaurantState {
  final String message;
  CreateResturantSuccess(this.message);
}

final class CreateResturantError extends CreateRestaurantState {
  final String message;
  CreateResturantError(this.message);
}

final class CreateRestaurantCitiesLoaded extends CreateRestaurantState {
  final List<CityEntity> cities;
  CreateRestaurantCitiesLoaded(this.cities);
}

final class CreateAddMneuToRestaurant extends CreateRestaurantState {
  final List<RestaurantMneu> mneu;
  CreateAddMneuToRestaurant(this.mneu);
}

final class CreateUploadMneuImageLoading extends CreateRestaurantState {
  final XFile file;
  CreateUploadMneuImageLoading(this.file);
}

final class CreateRestaurantCitiesLoading extends CreateRestaurantState {}

final class CreateRestaurantGovernoratesLoaded extends CreateRestaurantState {
  final List<GovernorateEntity> governorates;
  CreateRestaurantGovernoratesLoaded(this.governorates);
}

final class CreateResturantSubCategoriesLoaded extends CreateRestaurantState {
  final List<FoodCategoryEntity> subCategories;
  CreateResturantSubCategoriesLoaded(this.subCategories);
}

final class CreateRestaurantUploadProfileImage extends CreateRestaurantState {
  final List<XFile> files;
  CreateRestaurantUploadProfileImage(this.files);
}

final class CreateRestaurantUploadLicenseFirstPageImage
    extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadLicenseFirstPageImage(this.file);
}

final class CreateRestaurantUploadLicenseSecondPageImage
    extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadLicenseSecondPageImage(this.file);
}

final class CreateRestaurantUploadLicenseThiredPageImage
    extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadLicenseThiredPageImage(this.file);
}
