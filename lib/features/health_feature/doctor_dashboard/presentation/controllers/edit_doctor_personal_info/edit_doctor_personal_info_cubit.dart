import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_cities.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/usecases/get_governorates.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_personal_info_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/usecases/get_health_subcategories.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:go_router/go_router.dart';

part 'edit_doctor_personal_info_state.dart';

class EditDoctorPersonalInfoCubit extends Cubit<EditDoctorPersonalInfoState> {
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final UpdateDoctorPersonalInfoUsecase _updateDoctorPersonalInfoUsecase;
  EditDoctorPersonalInfoCubit(
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._getHealthSubcategoriesUseCase,
      this._updateDoctorPersonalInfoUsecase)
      : super(const EditDoctorPersonalInfoState());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> init(DoctorEntity data) async {
    emit(state.copyWith(status: EditDoctorPersonalInfoStates.loading));
    initData(data);
    await getGovernorates(id: data.address.governorateId);
    await getSubCategories();
    emit(state.copyWith(status: EditDoctorPersonalInfoStates.success));
  }

  initData(DoctorEntity data) {
    firstNameController.text = data.firstName;
    lastNameController.text = data.lastName;
    addressController.text = data.address.address;
    phoneController.text = data.phone;
    print("data.address.cityId${data.address.cityId}");
    emit(state.copyWith(
        selectedSpeciality: data.subCategory.id,
        selectedGovernorateId: data.address.governorateId,
        selectedCityId: data.address.cityId));
  }

  getGovernorates({String? id}) async {
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure,
            status: EditDoctorPersonalInfoStates.error)), (governorates) {
      if (id != null && governorates.isNotEmpty) {
        getCities(id);
      }
      emit(state.copyWith(governorates: governorates));
    });
  }

  getCities(String governorateId) async {
    emit(state.copyWith(status: EditDoctorPersonalInfoStates.loadCities));
    final response = await _getCitiesUseCase.call(governorateId);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: EditDoctorPersonalInfoStates.error)),
        (data) => emit(state.copyWith(
            cities: data,
            status: EditDoctorPersonalInfoStates.loadCitiesSuccess)));
  }

  Future<void> getSubCategories() async {
    final userId = UserCubit.to.state.data?.id;

    final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
    response.fold(
        (failure) => emit(state.copyWith(
            status: EditDoctorPersonalInfoStates.error,
            failure: failure)), (data) {
      emit(state.copyWith(speciality: data));
    });
  }

  void onSelectGovernorate(String id) {
    if (state.selectedGovernorateId != null &&
        state.selectedGovernorateId == id) {
      return;
    }
    emit(state.copyWith(selectedGovernorateId: id, selectedCityId: ''));
    print("state.governorateCubit${state.selectedGovernorateId}");
    print("state.cityCubit${state.selectedCityId}");

    getCities(id);
  }

  onSelectInitialGovernorate(String id) {
    String selectedId =
        state.governorates?.firstWhere((element) => element.nameEn == id).id ??
            '';
    emit(state.copyWith(selectedGovernorateId: selectedId, selectedCityId: ''));
    print("state.governorateCubit${state.selectedGovernorateId}");
    print("state.cityCubit${state.selectedCityId}");

    getCities(selectedId);
  }

  updateDoctorPersonalInfo(BuildContext context) async {
    final response =
        await _updateDoctorPersonalInfoUsecase.call(DoctorPersonalInfoParams(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      address: addressController.text,
      phone: phoneController.text,
      governorateId: state.selectedGovernorateId ?? '',
      cityId: state.selectedCityId ?? '',
      subCategoryId: state.selectedSpeciality ?? '',
    ));

    response.fold((failure) {
      showErrorMessage(context, getFailureMessage(failure, context));
      emit(state.copyWith(
          status: EditDoctorPersonalInfoStates.error, failure: failure));
    }, (data) {
      showSuccessMessage(context, LocaleKeys.updateSuccessfully.localize);
      context.pop(true);
    });
  }

  void onSelectCity(String id) {
    if (state.selectedCityId != null && state.selectedCityId == id) return;
    emit(state.copyWith(selectedCityId: id));
    print("state.governorateCubit${state.selectedGovernorateId}");
    print("state.cityCubit${state.selectedCityId}");
  }

  onSelectSpeciality(SubCategoryEntity? value) {
    emit(state.copyWith(selectedSpeciality: value?.id));
    print('state.speciality${state.selectedSpeciality}');
  }
}
