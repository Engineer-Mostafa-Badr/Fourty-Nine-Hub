part of 'subcategories_cubit.dart';

class SubcategoriesState {
  final Failure? failure;
  final SubcategoriesStates status;
  final int? subCatIndex;
  final String? selectedSubCatId;
  final List<AdModel>? ads;
  String? city;
  String? governorate;
  final FilterModel? filterModel;
  final List<AdModel>? myAds;
  final List<AdRequestEntity>? adsRequestsLog;

  final List<SubCategoryEntity>? subCategories;
  final List<SubCategoryEntity>? customPageSubCategories;
  final List<SubCategoryEntity>? marriageSubCategories;
  final MainCategoryEntity? mainCategory;

  SubcategoriesState(
      {this.failure,
      this.subCategories,
      this.ads,
      this.city = '',
      this.governorate = '',
      this.customPageSubCategories,
      this.filterModel,
      this.myAds,
      this.adsRequestsLog,
      this.mainCategory,
      this.marriageSubCategories,
      this.subCatIndex = 0,
      this.status = SubcategoriesStates.loading,
      this.selectedSubCatId});

  SubcategoriesState copyWith({
    Failure? failure,
    SubcategoriesStates? status,
    MainCategoryEntity? mainCategory,
    int? subCatIndex,
    String? selectedSubCatId,
    String? city,
    String? governorate,
    FilterModel? filterModel,
    List<SubCategoryEntity>? subCategories,
    List<SubCategoryEntity>? customPageSubCategories,
    List<SubCategoryEntity>? marriageSubCategories,
    List<AdModel>? ads,
    List<AdModel>? myAds,
    List<AdRequestEntity>? adsRequestsLog,
  }) {
    return SubcategoriesState(
      failure: failure ?? this.failure,
      status: status ?? this.status,
      ads: ads ?? this.ads,
      subCategories: subCategories ?? this.subCategories,
      customPageSubCategories:
          customPageSubCategories ?? this.customPageSubCategories,
      subCatIndex: subCatIndex ?? this.subCatIndex,
      mainCategory: mainCategory ?? this.mainCategory,
      marriageSubCategories:
          marriageSubCategories ?? this.marriageSubCategories,
      myAds: myAds ?? this.myAds,
      adsRequestsLog: adsRequestsLog ?? this.adsRequestsLog,
      selectedSubCatId: selectedSubCatId ?? this.selectedSubCatId,
    );
  }
}

enum SubcategoriesStates { loading, loadingAds, adsSuccess, initState, error }

extension SubcategoriesStateX on SubcategoriesState {
  bool get isLoading => status == SubcategoriesStates.loading;

  bool get isInitState => status == SubcategoriesStates.initState;

  bool get isError => status == SubcategoriesStates.error;

  bool get isLoadingAds => status == SubcategoriesStates.loadingAds;

  bool get isAdsSuccess => status == SubcategoriesStates.adsSuccess;
}
