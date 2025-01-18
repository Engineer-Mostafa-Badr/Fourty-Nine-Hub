import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_ads_usecase.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../domain/usecases/get_sub_categories_use_case.dart';
import '../../domain/entities/sub_category_entity.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final GetSubCategoriesUseCase _getSubcategoriesUsecase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;
  final GetAdsUseCase _getAdsUseCase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  SubcategoriesCubit(
      this._getSubcategoriesUsecase, this._toggleSubCategoryToFavoritesUseCase, this._getMainCategoryDetailsUseCase, this._getAdsUseCase)
      : super(const SubcategoriesState());

  String _mainCategoryId = '';

  init({required String mainCategoryId}){
    _mainCategoryId = mainCategoryId;

  }

  changeSubCatIndex(int index){
    emit(state.copyWith(subCatIndex: index));
  }

  MainCategoryEntity? mainCategory;
  Future<void> getMainCategoryDetails() async {
    // if (user != null) {
    final response = await _getMainCategoryDetailsUseCase('62c8b5b09332225799fe335e');
    response.fold(
            (failure) => emit(state.copyWith(status: SubcategoriesStates.error)),
            (data) {
              print("state.mainCategory?.nameEn ${data.nameEn}");
              mainCategory=data;

              print("mainCategory ${mainCategory?.nameEn}");
          emit(state.copyWith(
            mainCategory: data,
            status: SubcategoriesStates.initState
          ));
          print("state.mainCategory?.nameEn ${state.mainCategory?.nameEn}");
              print("mainCategory ${mainCategory?.nameEn}");
        });
    // }
  }

  loadData(String id) async {
    emit(state.copyWith(status: SubcategoriesStates.loading));
    await Future.wait([
    getMainCategoryDetails(),
      getMarriageSubcategories(id),
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
            failure: failure, status: SubcategoriesStates.error)),
        (r) {
           data = r;
           emit(state.copyWith(subCategories: r));
        });

    return data;
  }

  Future<List<SubCategoryEntity>> getMarriageSubcategories(String id) async {
    List<SubCategoryEntity> data = [];
    // emit(state.copyWith(status: SubcategoriesStates.loading));
    // await UserCubit.to.getUser();
    final user = UserCubit.to.state.data?.id;
    print('useeeerId===>$user}');
    final response = await _getSubcategoriesUsecase(GetSubCategoriesParams(
        mainCategoryId: id,
        paginationParams: PaginationParams(page: 1, limit: 30),
        userId: user ?? ''));
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)),
        (r) async {
          await loadMarriageData(subCategoryId: r.first.id);
          data = r;
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
    await getMarriageAds(subCategoryId: subCategoryId, page: 1);
    adsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getMarriageAds(subCategoryId: subCategoryId, page: pageKey);
    });
    emit(state.copyWith(status: SubcategoriesStates.initState));
  }

  final PagingController<int, AdModel> adsPagingController = PagingController(firstPageKey: 1);

  getMarriageAds(
      {required String subCategoryId,
        required int page}) async {
    final userId = UserCubit.to.isLoggedIn ? UserCubit.to.state.data?.id : '';

    if (page == 1) {
      adsPagingController.itemList = [];
    }
    final response = await _getAdsUseCase(GetAdsParams(
        subCategoryId: subCategoryId,
        page: page,
        limit: 10,
        userId: userId));
    response
        .fold((l) => emit(state.copyWith(failure: l, status: SubcategoriesStates.error)),
            (data) async {
          final isLastPage = data.length < 10;
          if (page == 1) {
            print("page == 1 $page");
            adsPagingController.itemList = [];
          }
          if (isLastPage) {
            print("isLastPage = $isLastPage");
            print(data.length);
            print(data.toString());
            adsPagingController.appendLastPage(data);
          } else {
            print("isNotLastPage = $isLastPage");
            final nextPageKey = page + 1;
            adsPagingController.appendPage(data, nextPageKey);
          }
        });
  }


}
