import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_cubit/health_share_cubit_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

part 'emergency_state.dart';

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit(this._shareCubit, this._getSubCategoriesUseCase)
      : super(EmergencyInitial());

  final HealthShareCubit _shareCubit;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;

  Future<void> load() async {
    _getSubCategories();
  }

  Future<void> _getSubCategories() async {
    if (_shareCubit.subCategories.isEmpty) {
      emit(EmergencyLoading());
      final response =
          await _getSubCategoriesUseCase.call('62c8b57c9332225799fe3306');
      response.fold(
          (failure) => emit(EmergencyError(message: "Can't Load Specialities")),
          (data) {
        _shareCubit.subCategories = data;
        emit(EmergencyLoaded(subCategories: data));
      });
    } else {
      emit(EmergencyLoaded(subCategories: _shareCubit.subCategories));
    }
  }

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final locationFocusNode = FocusNode();

  void selectSubcategory(SubCategoryEntity value) {}
}
