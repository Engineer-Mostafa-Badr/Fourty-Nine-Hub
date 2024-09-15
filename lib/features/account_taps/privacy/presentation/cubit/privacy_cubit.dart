import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/fetch_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_state.dart';

class PrivacyCubit extends Cubit<PrivacyState>{
  final FetchPrivacyUseCase _privacyUseCase;
  final UpdatePrivacyUseCase _updatePrivacyUseCase;

  PrivacyCubit(this._privacyUseCase, this._updatePrivacyUseCase) : super(const PrivacyState());



  void loadData() async {
    await fetchDataPrivacy();
  }

  Future<void> fetchDataPrivacy() async {
   // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await _privacyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(privacy: data,status: PrivacyStates.success));
    });
  }

  Future<void> updateDataPrivacy({required UpdatePrivacyParams params}) async {
    // emit(state.copyWith(status: PrivacyStates.loading));
    final response = await _updatePrivacyUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: PrivacyStates.error));
    }, (data) {
      emit(state.copyWith(privacy: data , status: PrivacyStates.success));
      fetchDataPrivacy();
    });
  }
}