import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../common/models/public/pagination_params.dart';
import '../../../ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import '../../../ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';
import '../../../ads_feature/ad_requests/domain/usecases/get_requests_log_by_main_category_use_case.dart';
import '../../../ads_feature/ads/data/models/Ad_model.dart';
import '../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import '../../../ads_feature/ads/domain/usecases/get_my_ad_by_id_usecase.dart';
import '../../../ads_feature/ads/domain/usecases/get_my_favourite_ads_usecase.dart';
import '../../../ads_feature/create_ad/domain/usecases/filter_ad_usecase.dart';
import '../../../ads_feature/filter_ads/data/models/filter_model.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../fourty_nine/domain/entities/main_category_entity.dart';
import '../../../fourty_nine/domain/use_cases/delete_ad_use_case.dart';
import '../../../fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import '../../../fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';
import '../../domain/entities/sub_category_entity.dart';
import '../../domain/usecases/get_custom_page_sub_categories_use_case.dart';
import '../../domain/usecases/get_sub_categories_use_case.dart';
import '../../domain/usecases/search_ads_use_case.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final GetSubCategoriesUseCase _getSubcategoriesUsecase;
  final GetCustomPageSubCategoriesUseCase _getCustomPageSubCategoriesUseCase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final GetAdsUseCase _getAdsUseCase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final FilterAdUseCase _filterAdUseCase;
  final GetMyAdByIdUseCase _getMyAdByIdUseCase;
  final GetMyFavouriteAdsUsecase _getMyFavouriteAdsUsecase;
  final GetAdRequestsUseCase _getAdRequestsUseCase;
  final GetRequestsLogByMainCategoryUseCase
      _getRequestsLogByMainCategoryUseCase;
  final SearchAdsUseCase _searchAdsUseCase;
  final DeleteAdUseCase _deleteAdUseCase;

  String _mainCategoryId = '';

  bool isMyAdsOpen = false;

  bool isRequestLogOpen = false;
  bool isFavouriteAdsOpen = false;
  bool isSearchAdsOpen = false;
  MainCategoryEntity? mainCategory;

  final PagingController<int, AdModel> adsPagingController =
      PagingController(firstPageKey: 1);

  // List<AdModel> marriageAds = [];
  // List<AdModel> marriageMyAds = [];
  // List<AdRequestEntity> adsRequestsLog = [];
  bool isLoadingMore = false;

  bool hasMoreData = true;

  int currentPage = 1;

  int pageSize = 10;

  bool isLoadingMyFavouriteAdsMore = false;

  bool isLoadingMyFavouriteAds = false;

  bool hasMoreMyFavouriteAds = true;

  int currentMyFavouriteAdsPage = 1;

  List<AdEntity> myFavouriteAds = [];

  bool isLoadingMyAdsMore = false;

  bool isLoadingMyAds = false;

  bool hasMoreMyAds = true;

  int currentMyAdsPage = 1;

  List<AdEntity> myAds = [];

  bool isLoadingRequestsLogMore = false;
  bool isLoadingRequestsLog = false;
  bool hasMoreRequestsLog = true;
  int currentRequestsLogPage = 1;

  List<RequestsLogByMainCategoryEntity> requestsLog = [];

  bool isLoadingRequestsLogByMainCategoryMore = false;
  bool isLoadingRequestsLogByMainCategory = false;
  bool hasMoreRequestsLogByMainCategory = true;
  int currentRequestsLogByMainCategoryPage = 1;
  List<RequestsLogByMainCategoryEntity> requestsLogByMainCategory = [];

  bool isLoadingMoreSearchAds = false;

  bool hasMoreDataSearchAds = true;
  int currentPageSearchAds = 1;
  List<AdModel> searchAdsList = [];
  bool initalSearchAds = true;

  // Debouncing for search
  Timer? _searchDebounceTimer;
  SubcategoriesCubit(
    this._getSubcategoriesUsecase,
    this._toggleSubCategoryToFavoritesUseCase,
    this._toggleFavoriteCategoryUseCase,
    this._getMainCategoryDetailsUseCase,
    this._getAdsUseCase,
    this._filterAdUseCase,
    this._getCustomPageSubCategoriesUseCase,
    this._getMyAdByIdUseCase,
    this._getMyFavouriteAdsUsecase,
    this._getAdRequestsUseCase,
    this._searchAdsUseCase,
    this._deleteAdUseCase,
    this._getRequestsLogByMainCategoryUseCase,
  ) : super(SubcategoriesState());

  changeFilterModel(FilterModel filterModel) {
    emit(state.copyWith(
        filterModel: filterModel, status: SubcategoriesStates.adsSuccess));
  }

  changeSubCatIndex(int index) async {
    if (index == state.subCatIndex) return;
    List<SubCategoryEntity> marriageSubCategories = state.subCategories ?? [];
    for (var element in marriageSubCategories) {
      element.isSelected = false;
    }
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

    // Update favorite ads view if it's open
    if (isFavouriteAdsOpen) {
      updateFavoriteAdsForSubcategory();
    }

    // Update request log view if it's open
    if (isRequestLogOpen) {
      updateRequestLogForSubcategory();
    }

    // Update my ads view if it's open
    if (isMyAdsOpen) {
      updateMyAdsForSubcategory();
    }
    // loadInitialData(subCategoryId:widget.mainCategory.id);
  }

  Future<void> deleteAd(String adId) async {
    emit(state.copyWith(deleteAdStatus: SubcategoriesStates.loading));
    final response = await _deleteAdUseCase(adId);
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) {
        if (state.myAds != null) {
          state.myAds!.removeWhere((element) => element.id == adId);
        }
        emit(state.copyWith(
          deleteAdStatus: SubcategoriesStates.adsSuccess,
        ));
      },
    );
  }

  filterAds({
    required FilterModel model,
    required String filter,
  }) async {
    print("filterAds called with model: ${model.toJson()}");
    print("filterAds called with filter: $filter");
    // Don't check hasMoreData for initial filter load
    if (isLoadingMore) {
      print("Already loading more, returning");
      return;
    }
    state.copyWith(status: SubcategoriesStates.loadingAds);
    isLoadingMore = true;

    print("object");
    print(filter);
    print("objectHiiiiiiiiiiii");

    print("Creating FilterModel...");
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
    print("FilterModel created successfully");
    print("About to call _filterAdUseCase with model: ${filterModel.toJson()}");
    print("Starting filter request at: ${DateTime.now()}");
    Either<Failure, List<AdModel>> response;
    try {
      response = await _filterAdUseCase(filterModel).timeout(
        const Duration(
            seconds: 10), // Reduced timeout to 10 seconds for testing
        onTimeout: () {
          print(
              "Filter request timed out after 10 seconds at: ${DateTime.now()}");
          return Left(ServerFailure(message: "Request timed out"));
        },
      );
      print("Received response from _filterAdUseCase at: ${DateTime.now()}");
    } catch (e) {
      print("Error calling _filterAdUseCase: $e at: ${DateTime.now()}");
      emit(state.copyWith(
          failure: ServerFailure(message: "Network error: $e"),
          status: SubcategoriesStates.error));
      return;
    }
    response.fold(
      (failure) {
        print("Filter request failed: ${failure.toString()}");
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) {
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        print("objectmarriageAds${data.length}");
        print("Filtered data received from server: ${data.length} ads");
        // Clear previous ads and set filtered data
        emit(state.copyWith(ads: data, status: SubcategoriesStates.adsSuccess));
      },
    );
  }

  filterMyAds({
    required FilterModel model,
    required String filter,
  }) async {
    print("filterMyAds called - this is a placeholder function");
    // This function is currently not implemented
    // It's called from loadFilterData but doesn't do anything
    // The main filtering is done by filterAds function
  }

  Future<List<SubCategoryEntity>> getCustomPageSubcategories(
      {String? mainCategoryId}) async {
    print('getCustomPageSubcategories');

    List<SubCategoryEntity> data = [];
    emit(state.copyWith(status: SubcategoriesStates.loading));
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user in getCustomPageSubcategories $_mainCategoryId');
    final response = await _getCustomPageSubCategoriesUseCase(
      GetCustomPageSubCategoriesParams(
        mainCategoryId: mainCategoryId ?? _mainCategoryId,
      ),
    );
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: SubcategoriesStates.error));
    }, (r) {
      data = r;
      print("customPageSubCategories data $r");
      emit(state.copyWith(customPageSubCategories: r));
    });

    return data;
  }

  Future<void> getMainCategoryDetails() async {
    // if (user != null) {
    final response =
        await _getMainCategoryDetailsUseCase('62c8b5b09332225799fe335e');
    await getMarriageAds(
        subCategoryId: state.selectedSubCatId ?? '62c8be728e28a58a3edf5f55');

    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: SubcategoriesStates.error));
    }, (data) async {
      print("state.mainCategory?.nameEn ${data.nameEn}");
      mainCategory = data;
      print("mainCategory ${mainCategory?.nameEn}");
      emit(state.copyWith(
          mainCategory: data, status: SubcategoriesStates.initState));
      print("state.mainCategory?.nameEn ${state.mainCategory?.nameEn}");
      print("mainCategory ${mainCategory?.nameEn}");
    });
  }

  Future getMarriageAds({
    required String subCategoryId,
  }) async {
    state.copyWith(status: SubcategoriesStates.loadingAds);

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
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) async {
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        print("objectmarriageAds${data.length}");
        emit(state.copyWith(ads: data, status: SubcategoriesStates.adsSuccess));
      },
    );
  }

  Future getMarriageMyAds(String mainCategoryId) async {
    // final response = await _getMyAdByIdUseCase('62c8b5b09332225799fe335e');
    final response = await _getMyAdByIdUseCase(
        GetMyAdByIdParams(mainCategoryId: mainCategoryId, page: 1));
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) async {
        emit(state.copyWith(
            myAds: data, status: SubcategoriesStates.adsSuccess));
      },
    );
  }

  Future<List<SubCategoryEntity>> getMarriageSubcategories() async {
    print('getMarriageSubcategories');

    List<SubCategoryEntity> data = [];
    // emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: '62c8b5b09332225799fe335e',
        paginationParams: PaginationParams(page: 1, limit: 200),
        userId: user ?? ''));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: SubcategoriesStates.error));
    }, (r) async {
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

  Future getMyAds(String mainCategoryId) async {
    // final response = await _getMyAdByIdUseCase('62c8b5b09332225799fe335e');
    if (!hasMoreMyAds || isLoadingMyAdsMore) return;

    isLoadingMyAdsMore = true;

    final response = await _getMyAdByIdUseCase(GetMyAdByIdParams(
        mainCategoryId: mainCategoryId, page: currentMyAdsPage));
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) {
        myAds.addAll(data);
        if (data.length < pageSize) {
          hasMoreMyAds = false;
        } else {
          currentMyAdsPage++;
        }

        isLoadingMyAdsMore = false;
        print("objectmarriageAds${data.length}");
        emit(state.copyWith(myAds: data));
      },
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) async {
        emit(state.copyWith(
            myAds: data, status: SubcategoriesStates.adsSuccess));
      },
    );
  }

  Future getMyFavouriteAds(String mainCategoryId) async {
    // final response = await _getMyAdByIdUseCase('62c8b5b09332225799fe335e');
    if (!hasMoreMyFavouriteAds || isLoadingMyFavouriteAdsMore) return;

    isLoadingMyFavouriteAdsMore = true;

    final response = await _getMyFavouriteAdsUsecase(GetMyAdByIdParams(
        mainCategoryId: mainCategoryId, page: currentMyFavouriteAdsPage));
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) {
        myFavouriteAds.addAll(data);
        if (data.length < pageSize) {
          hasMoreMyFavouriteAds = false;
        } else {
          currentMyFavouriteAdsPage++;
        }
        isLoadingMyFavouriteAdsMore = false;
        emit(state.copyWith(myAds: data));
      },
    );
  }

  Future<List<SubCategoryEntity>> getMyMarriage(String id) async {
    print("getMyMarriage");

    List<SubCategoryEntity> data = [];
    // emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: id,
        paginationParams: PaginationParams(page: 1, limit: 200),
        userId: user ?? ''));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: SubcategoriesStates.error));
    }, (r) async {
      if (r.isNotEmpty) {
        // await loadFilterData(
        //     model: FilterModel(limit: 15, page: 1, subCategoryId: r[0].id),
        //     filter: "user");
        data = r;
      }
      r.first.isSelected = true;
      emit(state.copyWith(subCategories: r));
    });

    return data;
  }

  getRequestsLog(String mainCategoryId) async {
    if (!hasMoreRequestsLog || isLoadingRequestsLogMore) return;

    emit(state.copyWith(status: SubcategoriesStates.loading));
    isLoadingRequestsLogMore = true;

    final response = await _getAdRequestsUseCase(
      GetAdRequestsParams(
        id: mainCategoryId,
        page: currentRequestsLogPage,
        limit: pageSize,
        username: '',
      ),
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) {
        requestsLog.addAll(data);
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentRequestsLogPage++;
        }

        isLoadingMore = false;
        print("objectmarriageAds${data.length}");
        emit(state.copyWith(adsRequestsLog: data));
      },
    );
  }

  getRequestsLogByMainCategory(String mainCategoryId) async {
    if (!hasMoreRequestsLogByMainCategory ||
        isLoadingRequestsLogByMainCategoryMore) {
      return;
    }

    emit(state.copyWith(status: SubcategoriesStates.loading));
    isLoadingRequestsLogByMainCategoryMore = true;

    final response = await _getRequestsLogByMainCategoryUseCase.call(
      GetRequestsLogByMainCategoryParams(
        mainCategoryId: mainCategoryId,
        page: currentRequestsLogByMainCategoryPage,
        limit: pageSize,
      ),
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
      },
      (data) {
        requestsLogByMainCategory.addAll(data);
        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentRequestsLogByMainCategoryPage++;
        }

        isLoadingMore = false;
        print("objectmarriageAds${data.length}");
        emit(state.copyWith(requestsLogByMainCategory: data));
      },
    );
  }

  Future<List<SubCategoryEntity>> getSubcategories(
      {required PaginationParams paginationParams,
      String? mainCategoryId}) async {
    List<SubCategoryEntity> data = [];
    emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: mainCategoryId ?? _mainCategoryId,
        paginationParams: paginationParams,
        userId: user ?? ''));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: SubcategoriesStates.error));
    }, (r) {
      data = r;
      emit(state.copyWith(subCategories: r));
    });

    return data;
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

  loadData(String id) async {
    emit(state.copyWith(status: SubcategoriesStates.loading));
    await Future.wait([
      getMainCategoryDetails(),
      getMarriageSubcategories(),
    ]);
    emit(state.copyWith(status: SubcategoriesStates.initState));
  }

  loadFilterData({
    required FilterModel model,
    required String filter,
  }) async {
    print("Gettinghiii - loadFilterData called");
    print("Filter model: ${model.toJson()}");
    print("Filter type: $filter");

    // Reset pagination and loading state for new filter
    currentPage = 1;
    hasMoreData = true;
    isLoadingMore = false;

    print("state.status${state.status}");
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    print("state.status${state.status}");

    // Only load filtered data, don't load unfiltered data
    await filterAds(model: model, filter: filter);

    // Load other data that doesn't interfere with the main ads list
    await filterMyAds(model: model, filter: filter);
    await getRequestsLog('62c8b5b09332225799fe335e');

    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
    print("state.status${state.status}");
  }

  void loadInitialData({required String subCategoryId}) async {
    print("loadInitialData");
    emit(state.copyWith(status: SubcategoriesStates.loading));
    currentPage = 1;
    hasMoreData = true;
    await Future.wait([
      getMainCategoryDetails(),
      getMarriageSubcategories(),
    ]);
    emit(state.copyWith(status: SubcategoriesStates.initState));
  }

  loadInitMarriage({required String subCategoryId}) async {
    print('loadInitMarriage');

    print("Yaneeeeeeee");
    currentPage = 1;
    hasMoreData = true;
    await getMarriageAds(
        subCategoryId: state.selectedSubCatId ?? '62c8be728e28a58a3edf5f55');
    await getMarriageMyAds('62c8b5b09332225799fe335e');
    await getRequestsLog('62c8b5b09332225799fe335e');
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
  }

  /// Refresh marriage ads data when returning from ad details view
  Future<void> refreshMarriageAds() async {
    print('refreshMarriageAds');
    currentPage = 1;
    hasMoreData = true;
    isLoadingMore = false;

    final subCategoryId = state.selectedSubCatId ?? '62c8be728e28a58a3edf5f55';
    await getMarriageAds(subCategoryId: subCategoryId);
    await getMarriageMyAds('62c8b5b09332225799fe335e');
    await getRequestsLog('62c8b5b09332225799fe335e');
  }

  Future loadMarriageData({required String subCategoryId}) async {
    print("loadMarriageData");

    // if (fromTab == true) {
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    // }
    await getMarriageAds(
      subCategoryId: subCategoryId,
    );
    await getMarriageMyAds('62c8b5b09332225799fe335e');
    await getRequestsLog(subCategoryId);
    adsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getMarriageAds(
        subCategoryId: subCategoryId,
      );
      getMarriageMyAds('62c8b5b09332225799fe335e');
      getRequestsLog(subCategoryId);
    });
    emit(state.copyWith(status: SubcategoriesStates.initState));
  }

  loadMyAds({
    required String id,
  }) async {
    print("Gettinghiii");
    myAds.clear();
    isLoadingMyAds = true;
    currentMyAdsPage = 1;
    hasMoreMyAds = true;
    isLoadingMyAdsMore = false;
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    await getMyAds(id);
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
    isLoadingMyAds = false;
  }

  loadMyFavouriteAds({
    required String id,
  }) async {
    print("Gettinghiii");
    myFavouriteAds.clear();
    isLoadingMyFavouriteAds = true;
    currentMyFavouriteAdsPage = 1;
    hasMoreMyFavouriteAds = true;
    isLoadingMyFavouriteAdsMore = false;
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    await getMyFavouriteAds(id);
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
    isLoadingMyFavouriteAds = false;
  }

  /// Update favorite ads when subcategory changes in marriage view
  void updateFavoriteAdsForSubcategory() {
    // This will trigger a rebuild of the FavouriteAdsView with filtered data
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
  }

  /// Update request log when subcategory changes in marriage view
  void updateRequestLogForSubcategory() {
    // This will trigger a rebuild of the RequestLogView with filtered data
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
  }

  /// Update my ads when subcategory changes in marriage view
  void updateMyAdsForSubcategory() {
    // This will trigger a rebuild of the MyAdsView with filtered data
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
  }

  loadRequestsLog({
    required String id,
  }) async {
    print("Gettinghiii");
    isLoadingRequestsLog = true;
    currentRequestsLogPage = 1;
    hasMoreRequestsLog = true;
    isLoadingRequestsLogMore = false;
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    await getRequestsLog(id);
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
    isLoadingRequestsLog = false;
  }

  loadRequestsLogByMainCategory({
    required String mainCategoryId,
  }) async {
    print("Gettinghiii");
    requestsLogByMainCategory.clear();
    isLoadingRequestsLogByMainCategory = true;
    currentRequestsLogByMainCategoryPage = 1;
    hasMoreRequestsLogByMainCategory = true;
    isLoadingRequestsLogByMainCategoryMore = false;
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    await getRequestsLogByMainCategory(mainCategoryId);
    emit(state.copyWith(status: SubcategoriesStates.adsSuccess));
    isLoadingRequestsLogByMainCategory = false;
  }

  void searchAds({
    required String value,
    required String mainCategoryId,
  }) {
    // Cancel previous timer if exists
    _searchDebounceTimer?.cancel();

    if (value.isEmpty) {
      initalSearchAds = true;
      emit(state.copyWith());
      return;
    }

    // Set up debounced search
    _searchDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(value, mainCategoryId);
    });
  }

  Future<void> _performSearch(String value, String mainCategoryId) async {
    emit(state.copyWith(status: SubcategoriesStates.loadingAds));
    initalSearchAds = false;

    // Try multiple search approaches to work around server case sensitivity
    final List<AdModel> allResults = [];
    final Set<String> seenIds = {};

    // Search with original case
    final response1 = await _searchAdsUseCase(
      SearchAdsParams(
        searchText: value,
        mainCategoryId: mainCategoryId,
      ),
    );

    response1.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error));
        return;
      },
      (data) {
        for (var ad in data) {
          if (!seenIds.contains(ad.id)) {
            allResults.add(ad);
            seenIds.add(ad.id);
          }
        }
      },
    );

    // Search with lowercase
    if (value != value.toLowerCase()) {
      final response2 = await _searchAdsUseCase(
        SearchAdsParams(
          searchText: value.toLowerCase(),
          mainCategoryId: mainCategoryId,
        ),
      );

      response2.fold(
        (failure) {
          // Ignore failure for second search
        },
        (data) {
          for (var ad in data) {
            if (!seenIds.contains(ad.id)) {
              allResults.add(ad);
              seenIds.add(ad.id);
            }
          }
        },
      );
    }

    // Search with uppercase
    if (value != value.toUpperCase()) {
      final response3 = await _searchAdsUseCase(
        SearchAdsParams(
          searchText: value.toUpperCase(),
          mainCategoryId: mainCategoryId,
        ),
      );

      response3.fold(
        (failure) {
          // Ignore failure for third search
        },
        (data) {
          for (var ad in data) {
            if (!seenIds.contains(ad.id)) {
              allResults.add(ad);
              seenIds.add(ad.id);
            }
          }
        },
      );
    }

    // If no results found, try a broader search and filter locally
    if (allResults.isEmpty) {
      final broadResponse = await _searchAdsUseCase(
        SearchAdsParams(
          searchText: '', // Empty search to get all ads
          mainCategoryId: mainCategoryId,
        ),
      );

      broadResponse.fold(
        (failure) {
          // If broad search fails, just use empty results
        },
        (data) {
          // Filter locally for case-insensitive search
          final filteredData = data.where((ad) {
            final searchTerm = value.toLowerCase();
            final adTitle = ad.title.toLowerCase();
            final adDescription = ad.description.toLowerCase();
            final adUserName = ad.user?.fullName.toLowerCase() ?? '';

            return adTitle.contains(searchTerm) ||
                adDescription.contains(searchTerm) ||
                adUserName.contains(searchTerm);
          }).toList();

          allResults.addAll(filteredData);
        },
      );
    }

    searchAdsList.clear();
    searchAdsList.addAll(allResults);
    emit(state.copyWith(
      searchAds: allResults,
      status: SubcategoriesStates.adsSuccess,
    ));
  }

  void toggleMyAds(String openThis) {
    if (openThis == 'isMyAdsOpen') {
      isMyAdsOpen = !isMyAdsOpen;
      isRequestLogOpen = false;
      isFavouriteAdsOpen = false;
      isSearchAdsOpen = false;
    } else if (openThis == 'isRequestLogOpen') {
      isRequestLogOpen = !isRequestLogOpen;
      isMyAdsOpen = false;
      isFavouriteAdsOpen = false;
      isSearchAdsOpen = false;
    } else if (openThis == 'isFavouriteAdsOpen') {
      isFavouriteAdsOpen = !isFavouriteAdsOpen;
      isMyAdsOpen = false;
      isRequestLogOpen = false;
      isSearchAdsOpen = false;
    } else if (openThis == 'isSearchAdsOpen') {
      isSearchAdsOpen = !isSearchAdsOpen;
      isMyAdsOpen = false;
      isRequestLogOpen = false;
      isFavouriteAdsOpen = false;
    }
    // if (!isMyAdsOpen) {
    //   isMyAdsOpen = true;
    //   isRequestLogOpen = false;
    // } else {
    //   isMyAdsOpen = false;
    // }
    emit(state.copyWith());
  }

  Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
    print("toggleFavoriteMedicalService");
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)), (data) {
      result = data;
      emit(state.copyWith(status: SubcategoriesStates.initState));
    });
    return result;
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleSubCategoryToFavoritesUseCase(subcategoryId);
    bool result = false;
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: SubcategoriesStates.error));
    }, (data) {
      result = data;
      emit(state.copyWith(status: SubcategoriesStates.initState));
    });
    return result;
  }

  void updateAdFavoriteStatus(String adId, bool isFavourite) {
    if (state.ads != null) {
      for (int i = 0; i < state.ads!.length; i++) {
        if (state.ads![i].id == adId) {
          state.ads![i].isFavourite = isFavourite;
          emit(state.copyWith(ads: state.ads));
          break;
        }
      }
    }
  }

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }
}
