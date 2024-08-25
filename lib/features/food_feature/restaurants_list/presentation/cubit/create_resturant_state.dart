part of 'create_resturant_cubit.dart';

sealed class CreateRestaurantState {}

final class CreateRestaurantInitial extends CreateRestaurantState {}

final class CreateResturantLoading extends CreateRestaurantState {
  final String message;
  CreateResturantLoading(this.message);
}

final class CreateRestaurantCloseLoading extends CreateRestaurantState {}

final class CreateResturantLoaded extends CreateRestaurantState {}

final class CreateRestaurantSuccess extends CreateRestaurantState {
  final String message;
  CreateRestaurantSuccess(this.message);
}

final class CreateResturantError extends CreateRestaurantState {
  final String message;
  CreateResturantError(this.message);
}

class ValidationState extends CreateRestaurantState {
  final bool? isName;
  final bool? isSubCategory;
  final bool? isRestaurantPhoto;
  final bool? isCommercialPhoto;
  final bool? isCommercialFirstPage;
  final bool? isCommercialSecondPage;
  final bool? isCommercialThirdPage;
  final bool? isGovernorate;
  final bool? isCity;
  final bool? isMneu;
  ValidationState({
    this.isName,
    this.isSubCategory,
    this.isRestaurantPhoto,
    this.isCommercialPhoto,
    this.isCommercialFirstPage,
    this.isCommercialSecondPage,
    this.isCommercialThirdPage,
    this.isGovernorate,
    this.isCity,
    this.isMneu,
  });

  ValidationState copyWith({
    bool? isName,
    bool? isSubCategory,
    bool? isRestaurantPhoto,
    bool? isCommercialPhoto,
    bool? isCommercialFirstPage,
    bool? isCommercialSecondPage,
    bool? isCommercialThirdPage,
    bool? isGovernorate,
    bool? isCity,
    bool? isMneu,
  }) {
    return ValidationState(
      isName: isName ?? this.isName,
      isSubCategory: isSubCategory ?? this.isSubCategory,
      isRestaurantPhoto: isRestaurantPhoto ?? this.isRestaurantPhoto,
      isCommercialPhoto: isCommercialPhoto ?? this.isCommercialPhoto,
      isCommercialFirstPage:
          isCommercialFirstPage ?? this.isCommercialFirstPage,
      isCommercialSecondPage:
          isCommercialSecondPage ?? this.isCommercialSecondPage,
      isCommercialThirdPage:
          isCommercialThirdPage ?? this.isCommercialThirdPage,
      isGovernorate: isGovernorate ?? this.isGovernorate,
      isCity: isCity ?? this.isCity,
      isMneu: isMneu ?? this.isMneu,
    );
  }
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
