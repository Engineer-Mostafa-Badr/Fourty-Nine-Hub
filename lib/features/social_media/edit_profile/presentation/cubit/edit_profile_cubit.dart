import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';
import '../../../../RideFeature/domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/edit_profile_entity.dart';
import '../../domain/usecases/edit_profile_usecase.dart';
import '../../domain/usecases/get_governorates.dart';
import '../../../../../routes/pages.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final postContentTextController = TextEditingController();
  final EditProfileUseCase _editProfileUseCase;
  final GetProfileGovernoratesUseCase getGovernoratesUseCase;
  final GetSettingsDashboardUsecase getSettingsDashboardUsecase;

  EditProfileCubit(this._editProfileUseCase,this.getSettingsDashboardUsecase, this.getGovernoratesUseCase)
      : super(EditProfileState());

  List<String>? selectedImages;

  void selectCityPrivacy({required String privacy}) {
    emit(state.copyWith(selectedCityPrivacy: privacy));
    print(state.selectedCityPrivacy);
  }

  void selectBioPrivacy({required String privacy}) {
    emit(state.copyWith(selectedBioPrivacy: privacy));
    print(state.selectedBioPrivacy);
  }

  void selectPhonePrivacy({required String privacy}) {
    emit(state.copyWith(selectedPhonePrivacy: privacy));
    print(state.selectedPhonePrivacy);
  }

  void selectStatusPrivacy({required String privacy}) {
    emit(state.copyWith(selectedStatusPrivacy: privacy));
    print(state.selectedStatusPrivacy);
  }

  void selectMaritalStatus({required String status}) {
    emit(state.copyWith(selectedStatus: status));
    print(state.selectedStatus);
  }

  void selectCountryPrivacy({required String privacy}) {
    emit(state.copyWith(selectedCountryPrivacy: privacy));
    print(state.selectedCountryPrivacy);
  }

  void selectJobPrivacy({required String privacy}) {
    emit(state.copyWith(selectedJobPrivacy: privacy));
    print(state.selectedJobPrivacy);
  }

  Future<void> fetchRideGovernorates() async {
    emit(state.copyWith(getGovernmentStatus: EditProfileStates.loading));

    var result = await getGovernoratesUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
          getGovernmentStatus: EditProfileStates.error, failure: failure)),
      (governorates) => emit(state.copyWith(
          getGovernmentStatus: EditProfileStates.success,
          governorates: governorates)),
    );
  }

  Future<void> editProfile(EditProfileEntity params) async {
    if(state.isDriverLady==true && params.isMale==true){
      var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, currentContext.isArabic?'لا يمكن تغيير جنسية السائقين. يرجى الاتصال بالدعم':'Drivers are not allowed to change their gender. Please contact support');
      return;
    }
    emit(state.copyWith(status: EditProfileStates.loading));
    final response = await _editProfileUseCase(params);
    response.fold(
        (l) =>
            emit(state.copyWith(failure: l, status: EditProfileStates.error)),
        (data) {
      UserCubit.to.getUser();
      emit(state.copyWith(status: EditProfileStates.success));
      // context.pop(true);
    });
  }

  initGender(String gender) {
    emit(state.copyWith(
        isMale: gender == 'male' || gender.isEmpty ? true : false));
  }


  void selectGovernorate(int governorateId) {
    final governorates = state.governorates ?? [];
    final governorate = governorates.firstWhere(
      (gov) => gov.id == governorateId,
      orElse: () => governorates.first,
    );

    emit(state.copyWith(selectedCity: governorate.nameAr));
  }

  // method للحصول على المحافظة المختارة
  GovernorateEntity? getSelectedGovernorate() {
    final governorates = state.governorates ?? [];
    if (governorates.isEmpty || state.selectedCity == null) return null;

    try {
      return governorates.firstWhere(
        (gov) => gov.nameAr == state.selectedCity ||
                gov.nameEn == state.selectedCity,
      );
    } catch (e) {
      return null;
    }
  }

  // method آمنة للحصول على المحافظة بالـ index
  GovernorateEntity? getGovernorateByIndex(int index) {
    final governorates = state.governorates ?? [];
    if (index < 0 || index >= governorates.length) return null;
    return governorates[index];
  }

  // method للحصول على index المحافظة بطريقة آمنة
  int getGovernorateIndex(int governorateId) {
    final governorates = state.governorates ?? [];
    for (int i = 0; i < governorates.length; i++) {
      if (governorates[i].id == governorateId) {
        return i;
      }
    }
    return -1; // لم يتم العثور عليها
  }


  Future<void> getSettings(BuildContext context) async {


    final Either<Failure, SettingsDashboardEntityResponse> result =
    await getSettingsDashboardUsecase(const NoParams());
    result.fold(
          (failure) {

        emit(state.copyWith(status: EditProfileStates.error, failure: failure));
      },
          (settings) {

        String lady = '62ea012a69ea29c91dfc3917';
        bool isDriverLady = settings.data.categoryIds.any((element) => element.id == lady);
        print("isDriverLady $isDriverLady");
        emit(state.copyWith(
            isDriverLady:isDriverLady));
      },
    );
  }
}
