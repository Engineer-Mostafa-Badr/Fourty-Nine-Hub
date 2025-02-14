import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/fetch_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_state.dart';

import '../../domain/useCase/fetch_connection_privacy_use_case.dart';
import '../../domain/useCase/fetch_personal_privacy_use_case.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  final FetchPersonalPrivacyUseCase _privacyUseCase;
  final UpdatePrivacyUseCase _updatePrivacyUseCase;
  final FetchConnectionPrivacyUseCase fetchConnectionPrivacyUseCase;

  PrivacyCubit(this._privacyUseCase, this._updatePrivacyUseCase, this.fetchConnectionPrivacyUseCase)
      : super(const PrivacyState());

  void loadData() async {
    await fetchDataPrivacy();
    await fetchDataConnectionPrivacy();
  }


  Future<void> fetchDataConnectionPrivacy() async {
    emit(state.copyWith(status: PrivacyStates.loading));
    final response = await fetchConnectionPrivacyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(connectionPrivacyEntity: data, status: PrivacyStates.success));
    });
  }
  Future<void> fetchDataPrivacy() async {
    emit(state.copyWith(status: PrivacyStates.loading));
    final response = await _privacyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(personalPrivacyEntity: data, status: PrivacyStates.success));
    });
  }

  Future<void> updateDataPrivacy({required UpdatePrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await _updatePrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(privacy: data));
      fetchDataPrivacy();
    });
  }
}
