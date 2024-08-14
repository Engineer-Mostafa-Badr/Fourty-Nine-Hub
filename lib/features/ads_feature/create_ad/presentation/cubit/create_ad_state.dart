part of 'create_ad_cubit.dart';

enum CreateAdStates { loading, error, initState, imageUploading }

extension CreateAdStateX on CreateAdState {
  bool get isLoading => status == CreateAdStates.loading;
  bool get isError => status == CreateAdStates.error;
  bool get isInitial => status == CreateAdStates.initState;
  bool get isImageUploading => status == CreateAdStates.imageUploading;
}

class CreateAdState {
  final CreateAdStates? status;
  final Failure? failure;
  final List<MainCategoryEntity>? mainCategories;
  final List<SubCategoryEntity>? subCategories;
  final List<AdPropertiesEntity>? adProperties;
  final MainCategoryEntity? selectedCategory;
  final SubCategoryEntity? selectedSubCategory;
  final List<UploadFileEntity>? images;

  const CreateAdState(
      {this.failure,
      this.mainCategories,
      this.adProperties,
      this.selectedCategory,
      this.selectedSubCategory,
      this.status,
      this.images,
      this.subCategories});

  CreateAdState copyWith({
    CreateAdStates? status,
    Failure? failure,
    List<MainCategoryEntity>? mainCategories,
    List<SubCategoryEntity>? subCategories,
    List<AdPropertiesEntity>? adProperties,
    MainCategoryEntity? selectedCategory,
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
    );
  }
}
