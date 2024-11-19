part of 'create_ad_cubit.dart';

enum CreateAdStates {
  loading,
  error,
  initState,
  success,
  loadCities,
  loadCitiesSuccess,
  imageUploading
}

extension CreateAdStateX on CreateAdState {
  bool get isLoading => status == CreateAdStates.loading;
  bool get isSuccess => status == CreateAdStates.success;
  bool get isCitiesLoaded => status == CreateAdStates.loadCities;
  bool get isError => status == CreateAdStates.error;
  bool get isInitial => status == CreateAdStates.initState;
  bool get isLoadCitiesSuccess => status == CreateAdStates.loadCitiesSuccess;
  bool get isImageUploading => status == CreateAdStates.imageUploading;
}

class CreateAdState {
  final CreateAdStates? status;
  final Failure? failure;
  final bool? isPrice;
  String? city;
  String? governorate;
  final List<CityEntity>? cities;
  final List<MainCategoryEntity>? mainCategories;
  final List<SubCategoryEntity>? subCategories;
  final List<AdPropertiesEntity>? adProperties;
  final List<AdPropertiesEntity>? filterAdProperties;
  final List<SelectionEntity>? selections;
  final MainCategoryEntity? selectedCategory;
  final SubCategoryEntity? selectedSubCategory;
  final List<GovernorateEntity>? governorates;
  bool? isUser;
  bool? isSale;
  bool? isMale;
  final List<UploadFileEntity>? images;

  CreateAdState(
      {this.failure,
      this.mainCategories,
      this.adProperties,
      this.filterAdProperties,
      this.selectedCategory,
      this.selections,
      this.selectedSubCategory,
      this.status,
      this.cities,
      this.city = '',
      this.governorates,
      this.isUser = true,
      this.isSale = true,
      this.isPrice = true,
      this.isMale = true,
      this.images,
      this.governorate = '',
      this.subCategories});

  CreateAdState copyWith({
    CreateAdStates? status,
    Failure? failure,
    List<MainCategoryEntity>? mainCategories,
    List<SubCategoryEntity>? subCategories,
    List<AdPropertiesEntity>? adProperties,
    List<AdPropertiesEntity>? filterAdProperties,
    MainCategoryEntity? selectedCategory,
    List<SelectionEntity>? selections,
    List<GovernorateEntity>? governorates,
    bool? isUser,
    bool? isSale,
    bool? isMale,
    bool? isPrice,
    String? city,
    String? governorate,
    List<CityEntity>? cities,
    SubCategoryEntity? selectedSubCategory,
    List<UploadFileEntity>? images,
  }) {
    return CreateAdState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      adProperties: adProperties ?? this.adProperties,
      filterAdProperties: filterAdProperties ?? this.filterAdProperties,
      mainCategories: mainCategories ?? this.mainCategories,
      subCategories: subCategories ?? this.subCategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      images: images ?? this.images,
      isUser: isUser ?? this.isUser,
      isSale: isSale ?? this.isSale,
      isMale: isMale ?? this.isMale,
      isPrice: isPrice ?? this.isPrice,
      cities: cities ?? this.cities,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      governorates: governorates ?? this.governorates,
      selections: selections ?? this.selections,
    );
  }
}
