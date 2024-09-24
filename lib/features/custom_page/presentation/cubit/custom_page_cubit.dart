import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/fetch_social_page_use_case.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/update_social_page_use_case.dart';
import '../../domain/use_case/fetch_sub_tab_use_case.dart';
import '../../domain/use_case/update_sub_tab_use_case.dart';
import 'custom_page_states.dart';

class CustomPageCubit extends Cubit<CustomPageState> {
  final FetchSocialPageUseCase _fetchSocialPageUseCase;
  final UpdateSocialPageUseCase _updateSocialPageUseCase;
  final FetchSubTabUseCase _fetchSubTabUseCase;
  final UpdateSubTabUseCase _updateSubTabUseCase;

  CustomPageCubit(
    this._fetchSocialPageUseCase, this._updateSocialPageUseCase, this._fetchSubTabUseCase, this._updateSubTabUseCase
  ) : super(const CustomPageState());

  // void loadData() async {
  //   await fetchCustomPageWallet();
  //   await checkRequestWithdrawCustomPage();
  //   // await fetchCustomPageHistory();
  // }

  // Social Page //////////////////////////////////////////////

  Future<void> fetchSocialPage() async {
    final response = await _fetchSocialPageUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(social: data,status: CustomPageStates.success));
    });
  }

  Future<void> updateSocialPage(SocialPageParams params) async {
    final response = await _updateSocialPageUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(status: CustomPageStates.success));
    });
  }

  // SubTab ////////////////////////////////////////////////////

  Future<void> fetchSubTab() async {
    final response = await _fetchSubTabUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(subTab: data,status: CustomPageStates.success));
    });
  }

  Future<void> updateSubTab(SubTabParams params) async {
    final response = await _updateSubTabUseCase.call(params);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(status: CustomPageStates.success));
    });
  }
}
