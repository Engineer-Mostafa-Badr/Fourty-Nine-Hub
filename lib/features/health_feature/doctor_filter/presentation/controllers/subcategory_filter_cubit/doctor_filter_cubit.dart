import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

part 'doctor_filter_state.dart';

class DoctorSubcategoryFilterCubit extends Cubit<DoctorSubcategoryFilterState> {
  final HealthSharedData _shareCubit;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  DoctorSubcategoryFilterCubit(this._getSubCategoriesUseCase, this._shareCubit)
      : super(DoctorSubcategoryFilterInitial());

  Future<void> loadData() async {
    _getSubCategories();
  }

  Future<void> _getSubCategories() async {
    if (_shareCubit.subCategories.isEmpty) {
      emit(DoctorSubcategoryFilterLoading());
      final response =
          await _getSubCategoriesUseCase.call('62c8b57c9332225799fe3306');
      response.fold(
          (failure) => emit(
              DoctorSubcategoryFilterError(message: "Can't Load Specialities")),
          (data) {
        _shareCubit.subCategories = data;
        emit(DoctorSubcategoryFilterLoaded(subCategories: data));
      });
    } else {
      emit(DoctorSubcategoryFilterLoaded(
          subCategories: _shareCubit.subCategories));
    }
  }

  void search(String query) {
    if (query.isNotEmpty) {
      emit(DoctorSubcategoryFilterLoaded(
          subCategories: _shareCubit.subCategories
              .where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()))
              .toList()));
    } else {
      emit(DoctorSubcategoryFilterLoaded(
          subCategories: _shareCubit.subCategories));
    }
  }
}
