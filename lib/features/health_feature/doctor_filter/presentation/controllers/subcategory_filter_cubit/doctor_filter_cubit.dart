import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'doctor_filter_state.dart';

class DoctorSubcategoryFilterCubit extends Cubit<DoctorSubcategoryFilterState> {
  final HealthSharedData _shareCubit;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  DoctorSubcategoryFilterCubit(
      this._getHealthSubcategoriesUseCase, this._shareCubit)
      : super(DoctorSubcategoryFilterInitial());

  Future<void> loadData() async {
    _getSubCategories();
  }

  Future<void> _getSubCategories() async {
    final userId = UserCubit.to.state.data?.id;

    if (_shareCubit.subCategories.isEmpty) {
      emit(DoctorSubcategoryFilterLoading());
      final response =
          await _getHealthSubcategoriesUseCase.call(userId??'');
      response.fold(
          (failure) =>
              emit(DoctorSubcategoryFilterError(message: Labels.errorHappened)),
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
                  element.nameEn.toLowerCase().contains(query.toLowerCase()))
              .toList()));
    } else {
      emit(DoctorSubcategoryFilterLoaded(
          subCategories: _shareCubit.subCategories));
    }
  }
}
