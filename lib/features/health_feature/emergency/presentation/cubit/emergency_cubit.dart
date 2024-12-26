import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/domain/usecases/book_emergency.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'emergency_state.dart';

class HealthEmergencyCubit extends Cubit<HealthEmergencyState> {
  HealthEmergencyCubit(
    this._bookHealthEmergencyUseCase,
    this._healthShare,
    this._getHealthSubcategoriesUseCase,
  ) : super(HealthEmergencyInitial());
  final HealthSharedData _healthShare;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;

  final BookHealthEmergencyUseCase _bookHealthEmergencyUseCase;

  final BookHealthEmergencyParams _params = BookHealthEmergencyParams();

  void loadData() async {
    await _getSubCategories();
  }

  Future<void> _getSubCategories() async {
    final userId = UserCubit.to.state.data?.id;

    if (_healthShare.subCategories.isEmpty) {
      final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
      response.fold(
          (failure) =>
              emit(HealthEmergencyError(message: Labels.errorHappened)),
          (data) {
        _healthShare.subCategories = data;
        emit(HealthEmergencySubCategoriesLoaded(subCategories: data));
      });
    } else {
      emit(HealthEmergencySubCategoriesLoaded(
          subCategories: _healthShare.subCategories));
    }
  }

  Future<void> bookEmergency() async {
    if (formKey.currentState!.validate()) {
      _saveTextEditing();
      if (_params.subCategoryId.isEmpty) {
        emit(HealthEmergencyError(message: Labels.selectSpeciality));
      } else {
        final response = await _bookHealthEmergencyUseCase.call(_params);
        response.fold(
            (failure) =>
                emit(HealthEmergencyError(message: Labels.errorHappened)),
            (data) => emit(HealthEmergencySuccess()));
      }
    }
  }

  void selectSubcategory(SubCategoryEntity value) {
    _params.subCategoryId = value.id;
  }

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final locationFocusNode = FocusNode();

  void _saveTextEditing() {
    _params.name = firstNameController.text;
    _params.phone = phoneController.text;
    _params.address = locationController.text;
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    firstNameFocusNode.dispose();
    phoneFocusNode.dispose();
    locationFocusNode.dispose();
    return super.close();
  }
}
