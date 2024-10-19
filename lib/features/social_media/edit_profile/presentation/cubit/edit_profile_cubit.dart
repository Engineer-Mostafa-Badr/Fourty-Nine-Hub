import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/entities/edit_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/usecases/edit_profile_usecase.dart';
import 'package:go_router/go_router.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final postContentTextController = TextEditingController();
  final EditProfileUseCase _editProfileUseCase;
  EditProfileCubit(this._editProfileUseCase) : super(EditProfileState());

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

  Future<void> editProfile(EditProfileEntity params) async {
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
}
