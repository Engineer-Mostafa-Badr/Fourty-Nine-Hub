import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/settings/domain/useCase/delete_account_use_case.dart';
import 'package:fourtyninehub/features/settings/presentation/cubit/settings_state.dart';

class SettingCubit extends Cubit<SettingState>{
  final DeleteAccountUseCase _deleteAccountUseCase;

  SettingCubit(this._deleteAccountUseCase) : super(const SettingState());


  Future<void> deleteAccount() async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await _deleteAccountUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: SettingStates.error));
    }, (data) {
      emit(state.copyWith(status: SettingStates.success));


    });
  }
}