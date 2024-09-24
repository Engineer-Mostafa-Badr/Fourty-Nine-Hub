import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/custom_page/domain/use_case/fetch_social_page_use_case.dart';

import '../../../../../../common/models/public/pagination_params.dart';
import 'custom_page_states.dart';

class CustomPageCubit extends Cubit<CustomPageState> {
  final FetchSocialPageUseCase _fetchSocialPageUseCase;

  CustomPageCubit(
    this._fetchSocialPageUseCase
  ) : super(const CustomPageState());

  // void loadData() async {
  //   await fetchCustomPageWallet();
  //   await checkRequestWithdrawCustomPage();
  //   // await fetchCustomPageHistory();
  // }

  Future<void> fetchSocialPage() async {
    final response = await _fetchSocialPageUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: CustomPageStates.error));
    }, (data) {
      emit(state.copyWith(social: data,status: CustomPageStates.success));
    });
  }
}
