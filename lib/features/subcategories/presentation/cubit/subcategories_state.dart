part of 'subcategories_cubit.dart';

class SubcategoriesState {
  final Failure? failure;
  final SubcategoriesStates status;
  final int? subCatIndex;
  final List<SubCategoryEntity>? subCategories;
  final List<SubCategoryEntity>? marriageSubCategories;
  final MainCategoryEntity? mainCategory;
  const SubcategoriesState(
      {this.failure,
      this.subCategories,
      this.mainCategory,
      this.marriageSubCategories,
      this.subCatIndex=0,
      this.status = SubcategoriesStates.loading});

  SubcategoriesState copyWith({
    Failure? failure,
    SubcategoriesStates? status,
    MainCategoryEntity? mainCategory,
    int? subCatIndex,
    List<SubCategoryEntity>? subCategories,
    List<SubCategoryEntity>? marriageSubCategories,
  }) {
    return SubcategoriesState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      subCategories: subCategories ?? this.subCategories,
      subCatIndex: subCatIndex ?? this.subCatIndex,
      mainCategory: mainCategory ?? this.mainCategory,
      marriageSubCategories: marriageSubCategories ?? this.marriageSubCategories,
    );
  }
}

enum SubcategoriesStates {
  loading,
  loadingAds,
  initState, error }

extension SubcategoriesStateX on SubcategoriesState {
  bool get isLoading => status == SubcategoriesStates.loading;
  bool get isInitState => status == SubcategoriesStates.initState;
  bool get isError => status == SubcategoriesStates.error;
}
