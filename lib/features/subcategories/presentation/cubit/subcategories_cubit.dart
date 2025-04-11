import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/filter_ad_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import '../../../ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';
import '../../../ads_feature/ads/domain/usecases/get_my_ad_by_id_usecase.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecases/get_custom_page_sub_categories_use_case.dart';
import '../../domain/usecases/get_sub_categories_use_case.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final GetSubCategoriesUseCase _getSubcategoriesUsecase;
  final GetCustomPageSubCategoriesUseCase _getCustomPageSubCategoriesUseCase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;
  final GetAdsUseCase _getAdsUseCase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final FilterAdUseCase _filterAdUseCase;
  final GetMyAdByIdUseCase _getMyAdByIdUseCase;
  final GetAdRequestsUseCase _getAdRequestsUseCase;

  SubcategoriesCubit(
    this._getSubcategoriesUsecase,
    this._toggleSubCategoryToFavoritesUseCase,
    this._getMainCategoryDetailsUseCase,
    this._getAdsUseCase,
    this._filterAdUseCase,
    this._getCustomPageSubCategoriesUseCase,
    this._getMyAdByIdUseCase,
    this._getAdRequestsUseCase,
  ) : super(SubcategoriesState());

  String _mainCategoryId = '';

  bool isMyAdsOpen = false;
  bool isRequestLogOpen = false;
  bool isFavouriteAdsOpen = false;

  void toggleMyAds(String openThis) {
    if (openThis == 'isMyAdsOpen') {
      isMyAdsOpen = !isMyAdsOpen;
      isRequestLogOpen = false;
      isFavouriteAdsOpen = false;
    } else if (openThis == 'isRequestLogOpen') {
      isRequestLogOpen = !isRequestLogOpen;
      isMyAdsOpen = false;
      isFavouriteAdsOpen = false;
    } else if (openThis == 'isFavouriteAdsOpen') {
      isFavouriteAdsOpen = !isFavouriteAdsOpen;
      isMyAdsOpen = false;
      isRequestLogOpen = false;
    }
    // if (!isMyAdsOpen) {
    //   isMyAdsOpen = true;
    //   isRequestLogOpen = false;
    // } else {
    //   isMyAdsOpen = false;
    // }
    emit(state.copyWith());
  }

  // void toggleRequestLog() {
  //   if (!isRequestLogOpen) {
  //     isRequestLogOpen = true;
  //     isMyAdsOpen = false;
  //   } else {
  //     isRequestLogOpen = false;
  //   }
  //   emit(state.copyWith());
  // }

  init({required String mainCategoryId}) {
    _mainCategoryId = mainCategoryId;
  }

  changeSubCatIndex(int index) async {
    if (index == state.subCatIndex) return;
    List<SubCategoryEntity> marriageSubCategories = state.subCategories ?? [];
    marriageSubCategories
        .where((element) => element.isSelected = false)
        .toList();
    marriageSubCategories[index].isSelected = true;
    emit(state.copyWith(
        status: SubcategoriesStates.loadingAds,
        subCatIndex: index,
        selectedSubCatId: marriageSubCategories[index].id,
        subCategories: marriageSubCategories));
    await loadFilterData(
        model: FilterModel(
            limit: 15, page: 1, subCategoryId: marriageSubCategories[index].id),
        filter: "user");
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
    // loadInitialData(subCategoryId:widget.mainCategory.id);
  }

  MainCategoryEntity? mainCategory;

  Future<void> getMainCategoryDetails() async {
    // if (user != null) {
    final response =
        await _getMainCategoryDetailsUseCase('62c8b5b09332225799fe335e');
    await getMarriageAds(
        subCategoryId: state.selectedSubCatId ?? '62c8be728e28a58a3edf5f55');

    response.fold(
        (failure) => emit(state.copyWith(status: SubcategoriesStates.error)),
        (data) async {
      print("state.mainCategory?.nameEn ${data.nameEn}");
      mainCategory = data;
      print("mainCategory ${mainCategory?.nameEn}");
      emit(state.copyWith(
          mainCategory: data, status: SubcategoriesStates.initState));
      print("state.mainCategory?.nameEn ${state.mainCategory?.nameEn}");
      print("mainCategory ${mainCategory?.nameEn}");
    });
  }

  loadData(String id) async {
    emit(state.copyWith(status: SubcategoriesStates.loading));
    await Future.wait([
      getMainCategoryDetails(),
      getMarriageSubcategories(),
    ]);
    emit(state.copyWith(status: SubcategoriesStates.initState));
  }

  Future<List<SubCategoryEntity>> getSubcategories(
      {required PaginationParams paginationParams}) async {
    List<SubCategoryEntity> data = [];
    emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: _mainCategoryId,
        paginationParams: paginationParams,
        userId: user ?? ''));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)), (r) {
      data = r;
      emit(state.copyWith(subCategories: r));
    });

    return data;
  }

  Future<List<SubCategoryEntity>> getCustomPageSubcategories() async {
    List<SubCategoryEntity> data = [];
    emit(state.copyWith(status: SubcategoriesStates.loading));
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user in getCustomPageSubcategories $_mainCategoryId');
    final response = await _getCustomPageSubCategoriesUseCase(
      GetCustomPageSubCategoriesParams(
        mainCategoryId: _mainCategoryId,
      ),
    );
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)), (r) {
      data = r;
      print("customPageSubCategories data ${r}");
      emit(state.copyWith(customPageSubCategories: r));
    });

    return data;
  }

  Future<List<SubCategoryEntity>> getMarriageSubcategories() async {
    List<SubCategoryEntity> data = [];
    // emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: '62c8b5b09332225799fe335e',
        paginationParams: PaginationParams(page: 1, limit: 200),
        userId: user ?? ''));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)), (r) async {
      if (r.isNotEmpty) {
        await loadFilterData(
            model: FilterModel(limit: 15, page: 1, subCategoryId: r[0].id),
            filter: "user");
      }
      data = r;
      r.first.isSelected = true;
      emit(state.copyWith(subCategories: r));
    });

    return data;
  }

  Future<List<SubCategoryEntity>> getMyMarriage(String id) async {
    List<SubCategoryEntity> data = [];
    // emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: id,
        paginationParams: PaginationParams(page: 1, limit: 200),
        userId: user ?? ''));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)), (r) async {
      if (r.isNotEmpty)
        // await loadFilterData(
        //     model: FilterModel(limit: 15, page: 1, subCategoryId: r[0].id),
        //     filter: "user");
        data = r;
      r.first.isSelected = true;
      emit(state.copyWith(subCategories: r));
    });

    return data;
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleSubCategoryToFavoritesUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)), (data) {
      result = data;
      emit(state.copyWith(status: SubcategoriesStates.initState));
    });
    return result;
  }

  Future loadMarriageData({required String subCategoryId}) async {
    // if (fromTab == true) {
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    // }
    await getMarriageAds(
      subCategoryId: subCategoryId,
    );
    await getMarriageMyAds();
    await getRequestsLog(subCategoryId);
    adsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getMarriageAds(
        subCategoryId: subCategoryId,
      );
      getMarriageMyAds();
      getRequestsLog(subCategoryId);
    });
    emit(state.copyWith(status: SubcategoriesStates.initState));
  }

  final PagingController<int, AdModel> adsPagingController =
      PagingController(firstPageKey: 1);

  void loadInitialData({required String subCategoryId}) async {
    print("Yaneeeeeeee");
    emit(state.copyWith(status: SubcategoriesStates.loading));
    marriageAds.clear();
    currentPage = 1;
    hasMoreData = true;
    await Future.wait([
      getMainCategoryDetails(),
      getMarriageSubcategories(),
    ]);
    emit(state.copyWith(status: SubcategoriesStates.initState));
  }

  loadInitMarriage({required String subCategoryId}) async {
    print("Yaneeeeeeee");
    marriageAds.clear();
    currentPage = 1;
    hasMoreData = true;
    await getMarriageAds(
        subCategoryId: state.selectedSubCatId ?? '62c8be728e28a58a3edf5f55');
    await getMarriageMyAds();
    await getRequestsLog('62c8b5b09332225799fe335e');
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
  }

  List<AdModel> marriageAds = [];
  List<AdModel> marriageMyAds = [];
  List<AdRequestEntity> adsRequestsLog = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  Future getMarriageAds({
    required String subCategoryId,
  }) async {
    print('getMarriageAds');
    final userId = UserCubit.to.isLoggedIn ? UserCubit.to.state.data?.id : '';
    print('return is ${!hasMoreData || isLoadingMore}');

    // if (!hasMoreData || isLoadingMore) return;

    // emit(state.copyWith(status: SubcategoriesStates.loading));
    isLoadingMore = true;

    final response = await _getAdsUseCase(
      GetAdsParams(
        subCategoryId: subCategoryId,
        page: currentPage,
        limit: 10,
        filter: '',
        userId: userId,
      ),
    );

    response.fold(
      (failure) => emit(
          state.copyWith(failure: failure, status: SubcategoriesStates.error)),
      (data) async {
        marriageAds.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        print("objectmarriageAds${marriageAds.length}");
        emit(state.copyWith(ads: data, status: SubcategoriesStates.adsSuccess));
      },
    );
  }

  Future getMarriageMyAds() async {
    final response = await _getMyAdByIdUseCase('62c8b5b09332225799fe335e');
    response.fold(
      (failure) => emit(
          state.copyWith(failure: failure, status: SubcategoriesStates.error)),
      (data) async {
        marriageMyAds.addAll(data);
        emit(state.copyWith(
            myAds: data, status: SubcategoriesStates.adsSuccess));
      },
    );
  }

  loadFilterData({
    required FilterModel model,
    required String filter,
  }) async {
    print("Gettinghiii");

    marriageAds.clear();
    currentPage = 1;
    hasMoreData = true;
    isLoadingMore = false;
    print("state.status${state.status}");
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    print("state.status${state.status}");
    await filterMyAds(model: model, filter: filter);
    await getRequestsLog('62c8b5b09332225799fe335e');
    await getMarriageAds(
        subCategoryId: state.selectedSubCatId ?? '62c8be728e28a58a3edf5f55');
    await filterAds(model: model, filter: filter);
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
    print("state.status${state.status}");
  }

  changeFilterModel(FilterModel filterModel) {
    emit(state.copyWith(
        filterModel: filterModel, status: SubcategoriesStates.adsSuccess));
  }

  filterAds({
    required FilterModel model,
    required String filter,
  }) async {
    print("objectasdsad");
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    print("object");
    print(filter);
    print("objectHiiiiiiiiiiii");

    FilterModel filterModel = FilterModel(
      price: model.price,
      props: model.props,
      cityId: model.cityId,
      governorateId: model.governorateId,
      limit: 15,
      page: currentPage,
      subCategoryId: model.subCategoryId,
      filter: filter,
    );
    final response = await _filterAdUseCase(filterModel);
    response.fold(
      (failure) => emit(
          state.copyWith(failure: failure, status: SubcategoriesStates.error)),
      (data) {
        marriageAds.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        print("objectmarriageAds${marriageAds.length}");
        emit(state.copyWith(ads: data, status: SubcategoriesStates.adsSuccess));
      },
    );
  }

  filterMyAds({
    required FilterModel model,
    required String filter,
  }) async {
    print("objectasdsad");
    // if (!hasMoreData || isLoadingMore) return;

    // isLoadingMore = true;

    print("object");
    print(filter);
    print("objectHiiiiiiiiiiii");

    FilterModel filterModel = FilterModel(
        price: model.price,
        props: model.props,
        cityId: model.cityId,
        governorateId: model.governorateId,
        limit: 15,
        page: currentPage,
        subCategoryId: model.subCategoryId,
        filter: filter);
    // final response = await _filterAdUseCase(filterModel);
    // response.fold(
    //   (failure) => emit(
    //       state.copyWith(failure: failure, status: SubcategoriesStates.error)),
    //   (data) {
    //     mrriageMyAds.clear();
    //     mrriageMyAds.addAll(data);
    //
    //     // if (data.length < pageSize) {
    //     //   hasMoreData = false;
    //     // } else {
    //     //   currentPage++;
    //     // }
    //
    //     // isLoadingMore = false;
    //     print("objectmarriageAds${marriageAds.length}");
    //     emit(state.copyWith(myAds: data));
    //   },
    // );
  }

  getRequestsLog(String id) async {
    if (!hasMoreData || isLoadingMore) return;

    emit(state.copyWith(status: SubcategoriesStates.loading));
    isLoadingMore = true;

    final response = await _getAdRequestsUseCase(
      GetAdRequestsParams(
          id: id, page: currentPage, limit: pageSize, username: ''),
    );
    // final response = await _filterAdUseCase(filterModel);
    response.fold(
      (failure) => emit(
          state.copyWith(failure: failure, status: SubcategoriesStates.error)),
      (data) {
        adsRequestsLog.clear();
        adsRequestsLog.addAll(data);
        emit(state.copyWith(adsRequestsLog: data));
      },
    );
  }
}
