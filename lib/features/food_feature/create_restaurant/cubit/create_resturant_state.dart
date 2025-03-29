part of 'create_resturant_cubit.dart';

sealed class CreateRestaurantState {}

final class CreateRestaurantInitial extends CreateRestaurantState {}

final class CreateRestaurantLoading extends CreateRestaurantState {}

final class CreateRestaurantFinish extends CreateRestaurantState {}

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
final class CreateRestaurantRefreshUI extends CreateRestaurantState {}

final class CreateResturantError extends CreateRestaurantState {
  final String message;

  CreateResturantError(this.message);
}

enum ValidationStates {
  loading,
  filterLoading,
  initState,
  error,
  success,
  requestSuccess,
  requestLoading
}

extension ValidationStateX on ValidationState {
  bool get isInitial => status == ValidationStates.initState;
  bool get isLoading => status == ValidationStates.loading;
  bool get isFilterLoading => status == ValidationStates.filterLoading;
  bool get isError => status == ValidationStates.error;
  bool get isSuccess => status == ValidationStates.success;
  bool get isRequestSuccess => status == ValidationStates.requestSuccess;
  bool get isRequestLoading => status == ValidationStates.requestLoading;
}

class ValidationState extends CreateRestaurantState {
  final bool? isName;
  final bool? isNumber;
  final bool? isSubCategory;
  final bool? isRestaurantPhoto;
  final bool? isCommercialPhoto;
  final bool? isCommercialFirstPage;
  final bool? isCommercialSecondPage;
  final bool? isCommercialThirdPage;
  final bool? isGovernorate;
  final bool? isCity;
  final ValidationStates? status;
  final bool? isMneu;

  ValidationState({
    this.isNumber,
    this.isName,
    this.isSubCategory,
    this.isRestaurantPhoto,
    this.isCommercialPhoto,
    this.status,
    this.isCommercialFirstPage,
    this.isCommercialSecondPage,
    this.isCommercialThirdPage,
    this.isGovernorate,
    this.isCity,
    this.isMneu,
  });

  ValidationState copyWith({
    bool? isNumber,
    bool? isName,
    bool? isSubCategory,
    bool? isRestaurantPhoto,
    bool? isCommercialPhoto,
    ValidationStates? status,
    bool? isCommercialFirstPage,
    bool? isCommercialSecondPage,
    bool? isCommercialThirdPage,
    bool? isGovernorate,
    bool? isCity,
    bool? isMneu,
  }) {
    return ValidationState(
      isName: isName ?? this.isName,
      status: status ?? this.status,
      isNumber: isNumber ?? this.isNumber,
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
  final List<RestaurantMenu> mneu;

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
