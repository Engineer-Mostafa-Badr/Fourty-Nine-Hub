import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import '../../../../../core/error/failure.dart';
import '../../../../fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import '../../domain/usecases/get_ad_properties_usecase.dart';

part 'create_ad_state.dart';

class CreateAdCubit extends Cubit<CreateAdState> {
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  final GetAdPropertiesUsecase _getAdPropertiesUsecase;
  CreateAdCubit(this._getMainCategoriesUseCase, this._getAdPropertiesUsecase,
      this._getSubCategoriesUseCase)
      : super(const CreateAdState());

  void loadData() async {
    await getMainCategories();
  }

  Future<void> getMainCategories() async {
    final response = await _getMainCategoriesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) => emit(state.copyWith(
            mainCategories: data, status: CreateAdStates.initState)));
  }

  void onMainCategorySelected(
      {required MainCategoryEntity category,
      required BuildContext context}) async {
    final response = await _getSubCategoriesUseCase.call('${category.id}');
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) => emit(
            state.copyWith(selectedCategory: category, subCategories: data)));
  }

  void onSubCategorySelected({required SubCategoryEntity category}) async {
    final response = await _getAdPropertiesUsecase.call('${category.id}');
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: CreateAdStates.error)),
        (data) => emit(
            state.copyWith(selectedSubCategory: category, adProperties: data)));

  }
}
