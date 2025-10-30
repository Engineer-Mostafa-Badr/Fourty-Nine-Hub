part of 'create_restaurant_cubit.dart';

sealed class CreateRestaurantState {}

final class CreateRestaurantInitial extends CreateRestaurantState {}

final class CreateRestaurantFinish extends CreateRestaurantState {}

final class CreateRestaurantLoading extends CreateRestaurantState {
  final String? message;

  CreateRestaurantLoading([this.message]);
}

final class CreateRestaurantCloseLoading extends CreateRestaurantState {}

final class CreateRestaurantLoaded extends CreateRestaurantState {}

final class CreateRestaurantSuccess extends CreateRestaurantState {
  final String message;

  CreateRestaurantSuccess(this.message);
}
final class CreateRestaurantRefreshUI extends CreateRestaurantState {}

final class CreateRestaurantError extends CreateRestaurantState {
  final String message;

  CreateRestaurantError(this.message);
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
  final bool? isMenu;

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
    this.isMenu,
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
    bool? isMenu,
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
      isMenu: isMenu ?? this.isMenu,
    );
  }
}

final class CreateRestaurantCitiesLoaded extends CreateRestaurantState {
  final List<CityEntity> cities;

  CreateRestaurantCitiesLoaded(this.cities);
}

final class CreateAddMenuToRestaurant extends CreateRestaurantState {
  final List<RestaurantMenu> menu;

  CreateAddMenuToRestaurant(this.menu);
}

final class CreateUploadMenuImageLoading extends CreateRestaurantState {
  final XFile file;

  CreateUploadMenuImageLoading(this.file);
}

final class CreateRestaurantCitiesLoading extends CreateRestaurantState {}

final class CreateRestaurantGovernoratesLoaded extends CreateRestaurantState {
  final List<GovernorateEntity> governorates;

  CreateRestaurantGovernoratesLoaded(this.governorates);
}

final class CreateRestaurantSubCategoriesLoaded extends CreateRestaurantState {
  final List<FoodCategoryEntity> subCategories;

  CreateRestaurantSubCategoriesLoaded(this.subCategories);
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
