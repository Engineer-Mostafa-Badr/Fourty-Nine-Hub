import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FetchSearchUseCase _fetchSearchUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;

  SearchCubit(
      this._fetchSearchUseCase, this._toggleFavoriteCategoryUseCase,
    )
      : super( SearchState());

   TextEditingController searchController=TextEditingController();

  void onRefresh() async {
    searchPagingController.refresh();
  }

  initPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filter', 'totalUsers');
  }
  void loadData(SearchParams params) async {
    //   await getFeed(1);
    getPaginatedSearch(params,1);
    searchPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPaginatedSearch(params,pageKey);
    });
  }
  Future<List<MainSubCategorySearchEntity>> getSearch(SearchParams params) async {
    emit(state.copyWith( status: SearchStates.loading));
    List<MainSubCategorySearchEntity> main = [];
    final response = await _fetchSearchUseCase.call(params);

    response.fold((l) {
      print('Errrrrrrror :$l');
      emit(state.copyWith(failure: l, status: SearchStates.error));
    }, (data) {
      print('Sussecc :$data');
      main = data;
      emit(state.copyWith(search: data,status: SearchStates.success));

    });
    return main;
  }

  final PagingController<int, MainSubCategorySearchEntity> searchPagingController =
  PagingController(firstPageKey: 1);
  final int pageSize = 10;

  Future<List<MainSubCategorySearchEntity>> getPaginatedSearch(SearchParams params,int page) async {
    emit(state.copyWith( status: SearchStates.loading));
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
      emit(state.copyWith(search: data,status: SearchStates.success));

    });
    return main;
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
