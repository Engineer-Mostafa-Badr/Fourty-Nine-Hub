import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/settings/domain/useCase/delete_account_use_case.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_state.dart';

import '../../domain/entities/disable_entity.dart';
import '../../domain/useCase/disable_account_use_case.dart';
import '../../domain/useCase/enable_account_use_case.dart';

class SettingCubit extends Cubit<SettingState> {
  final DeleteAccountUseCase _deleteAccountUseCase;
  final DisableAccountUseCase _disableAccountUseCase;
  final EnableAccountUseCase _enableAccountUseCase;

  SettingCubit(
    this._deleteAccountUseCase,
    this._disableAccountUseCase,
    this._enableAccountUseCase,
  ) : super(SettingState(able: DisableEntity(isDisabled: false)));


  Future<void> deleteAccount() async {
    final response = await _deleteAccountUseCase.call(const NoParams());
    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: SettingStates.error));
      },
      (data) {
        emit(state.copyWith(status: SettingStates.success1));
      },
    );
  }

  Future<void> disableAccount() async {
    final response = await _disableAccountUseCase.call(const NoParams());
    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: SettingStates.error));
      },
      (data) {
        // Ensure the actual isDisabled value from the API response is used
        emit(state.copyWith(able: data, status: SettingStates.success));
      },
    );
  }

  Future<void> enableAccount() async {
    final response = await _enableAccountUseCase.call(const NoParams());
    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: SettingStates.error));
      },
      (data) {
        // Ensure the actual isDisabled value from the API response is used
        emit(state.copyWith(able: data, status: SettingStates.success));
      },
    );
  }
}
