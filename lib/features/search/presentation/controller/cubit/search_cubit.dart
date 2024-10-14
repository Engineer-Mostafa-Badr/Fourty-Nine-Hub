import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/search/domain/entity/main_category_search_entity.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FetchSearchUseCase _fetchSearchUseCase;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;

  SearchCubit(
      this._fetchSearchUseCase, this._toggleFavoriteCategoryUseCase,
    )
      : super(const SearchState());

   TextEditingController searchController=TextEditingController();

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


}
