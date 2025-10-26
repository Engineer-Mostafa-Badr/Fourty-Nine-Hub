part of 'create_restaurant_cubit.dart';

sealed class CreateRestaurantState {}

final class CreateRestaurantInitial extends CreateRestaurantState {}

final class CreateRestaurantLoading extends CreateRestaurantState {
  final String message;
  CreateRestaurantLoading(this.message);
}

final class CreateRestaurantCloseLoading extends CreateRestaurantState {}

final class CreateRestaurantLoaded extends CreateRestaurantState {}

final class CreateRestaurantSuccess extends CreateRestaurantState {
  final String message;
  CreateRestaurantSuccess(this.message);
}

final class CreateRestaurantError extends CreateRestaurantState {
  final String message;
  CreateRestaurantError(this.message);
}

final class CreateRestaurantCitiesLoaded extends CreateRestaurantState {
  final List<CityEntity> cities;
  CreateRestaurantCitiesLoaded(this.cities);
}

final class CreateRestaurantCitiesLoading extends CreateRestaurantState {}

final class CreateRestaurantGovernoratesLoaded extends CreateRestaurantState {
  final List<GovernorateEntity> governorates;
  CreateRestaurantGovernoratesLoaded(this.governorates);
}

final class CreateRestaurantSubCategoriesLoaded extends CreateRestaurantState {
  final List<SubCategoryEntity> subCategories;
  CreateRestaurantSubCategoriesLoaded(this.subCategories);
}

final class CreateRestaurantUploadProfileImage extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadProfileImage(this.file);
}

final class CreateRestaurantUploadIdFrontImage extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadIdFrontImage(this.file);
}

final class CreateRestaurantUploadIdBehindImage extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadIdBehindImage(this.file);
}

final class CreateRestaurantUploadPracticingFrontImage
    extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadPracticingFrontImage(this.file);
}

final class CreateRestaurantUploadPracticingBehindImage
    extends CreateRestaurantState {
  final XFile file;
  CreateRestaurantUploadPracticingBehindImage(this.file);
}

final class CreateRestaurantShowClinic extends CreateRestaurantState {
  final bool check;
  CreateRestaurantShowClinic(this.check);
}

final class CreateRestaurantShowCall extends CreateRestaurantState {
  final bool check;
  CreateRestaurantShowCall(this.check);
}

final class CreateRestaurantShowHomeVisit extends CreateRestaurantState {
  final bool check;
  CreateRestaurantShowHomeVisit(this.check);
}
