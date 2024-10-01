part of 'create_ad_cubit.dart';

enum CreateAdStates { loading, error, initState, success, loadCities, loadCitiesSuccess, imageUploading }

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
  final List<CityEntity>? cities;
  final List<MainCategoryEntity>? mainCategories;
  final List<SubCategoryEntity>? subCategories;
  final List<AdPropertiesEntity>? adProperties;
  final List<SelectionEntity>? selections;
  final MainCategoryEntity? selectedCategory;
  final SubCategoryEntity? selectedSubCategory;
  final List<GovernorateEntity>? governorates;
  bool? isUser;
  bool? isSale;
  final List<UploadFileEntity>? images;

  CreateAdState(
      {this.failure,
      this.mainCategories,
      this.adProperties,
      this.selectedCategory,
      this.selections,
      this.selectedSubCategory,
      this.status,
      this.cities,
      this.isUser = true,
      this.isSale = true,
      this.isPrice = true,
      this.images,
      this.governorates,
      this.subCategories});

  CreateAdState copyWith({
    CreateAdStates? status,
    Failure? failure,
    List<MainCategoryEntity>? mainCategories,
    List<SubCategoryEntity>? subCategories,
    List<AdPropertiesEntity>? adProperties,
    MainCategoryEntity? selectedCategory,
    List<SelectionEntity>? selections,
    List<GovernorateEntity>? governorates,
    bool? isUser,
    bool? isSale,
    bool? isPrice,
    List<CityEntity>? cities,
    SubCategoryEntity? selectedSubCategory,
    List<UploadFileEntity>? images,
  }) {
    return CreateAdState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      adProperties: adProperties ?? this.adProperties,
      mainCategories: mainCategories ?? this.mainCategories,
      subCategories: subCategories ?? this.subCategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      images: images ?? this.images,
      isUser: isUser ?? this.isUser,
      isSale: isSale ?? this.isSale,
      isPrice: isPrice ?? this.isPrice,
      cities: cities ?? this.cities,
      governorates: governorates ?? this.governorates,
      selections: selections ?? this.selections,
    );
  }
}
