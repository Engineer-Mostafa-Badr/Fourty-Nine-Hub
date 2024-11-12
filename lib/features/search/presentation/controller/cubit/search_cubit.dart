import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/entity/user_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_ads_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_user_search_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FetchSearchUseCase _fetchSearchUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final FetchUserSearchUseCase _fetchUserSearchUseCase;
  final FetchAdsSearchUseCase _fetchAdsSearchUseCase;

  SearchCubit(this._fetchSearchUseCase,
      this._toggleFavoriteCategoryUseCase,
      this._fetchUserSearchUseCase,
      this._fetchAdsSearchUseCase,) : super(SearchState());

  TextEditingController searchController = TextEditingController();

  void onRefresh() async {
    searchPagingController.refresh();
    searchPagingUserController.refresh();
    searchPagingAdsController.refresh();
  }

  initPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filter', 'totalUsers');
  }

  void loadData(SearchParams params) async {
    //   await getFeed(1);
    getPaginatedSearch(params, 1);
    getPaginatedUserSearch(params, 1);
    getPaginatedAdsSearch(params, 1);
    searchPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedSearch(params, pageKey);
    });
    searchPagingUserController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedUserSearch(params, pageKey);
    });
    searchPagingAdsController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedAdsSearch(params, pageKey);
    });

  }

  final PagingController<int, MainSubCategorySearchEntity>
  searchPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, UserSearchEntity> searchPagingUserController =
  PagingController(firstPageKey: 1);
  final PagingController<int, AdsSearchEntity> searchPagingAdsController =
  PagingController(firstPageKey: 1);
  final int pageSize = 10;

  Future<List<MainSubCategorySearchEntity>> getPaginatedSearch(
      SearchParams params, int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<MainSubCategorySearchEntity> main = [];
    final response = await _fetchSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      main = data;
      emit(state.copyWith(search: data, status: SearchStates.success));
    });
    return main;
  }

  Future<List<UserSearchEntity>> getPaginatedUserSearch(SearchParams params,
      int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<UserSearchEntity> user = [];
    final response = await _fetchUserSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingUserController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingUserController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingUserController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      user = data;
      emit(state.copyWith(userSearch: data, status: SearchStates.success));
    });
    return user;
  }




  Future<List<AdsSearchEntity>> getPaginatedAdsSearch(
      SearchParams params, int page) async {
    emit(state.copyWith(status: SearchStates.loading));
    List<AdsSearchEntity> ads = [];
    final response = await _fetchAdsSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        searchPagingAdsController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        searchPagingAdsController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        searchPagingAdsController.appendPage(data, nextPageKey);
      }
      print('Sussecc :$data');
      ads = data;
      emit(state.copyWith(adsSearch: data, status: SearchStates.success));
    });
    return ads;
  }





  Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
            (data) {
          result = data;
          emit(state.copyWith(status: SearchStates.success));
        });
    return result;
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: SearchStates.error)),
            (data) {
          result = data;
          emit(state.copyWith(status: SearchStates.success));
        });
    return result;
  }
}
