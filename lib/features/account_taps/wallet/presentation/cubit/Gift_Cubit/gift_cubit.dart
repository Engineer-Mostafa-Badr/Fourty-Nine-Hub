import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_gifts_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_wheel_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../lucky_wheel/domain/use_cases/get_wheel_wallet_use_case.dart';

class GiftCubit extends Cubit<GiftState> {
  final GetWalletGiftsUseCase _giftUseCases;
  final GetWheelWalletUseCase _getWheelWalletUseCase;
  final RequestWithdrawUseCase _requestWithdrawUseCase;
  final RequestWithdrawWheelUseCase _requestWithdrawWheelUseCase;

  GiftCubit(
    this._giftUseCases,
    this._getWheelWalletUseCase,
    this._requestWithdrawUseCase,
    this._requestWithdrawWheelUseCase,
  ) : super(const GiftState());

  Future<void> fetchGiftWallet() async {
    final response = await _giftUseCases.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: GiftStates.error));
    }, (data) {
      log('///////////////////////////////////////');
      // log(data.giftWallet.userId);
      log('///////////////////////////////////////');
      // emit(state.copyWith(gift: data));
    });
  }

  Future<void> getWheelWallet() async {
    emit(state.copyWith(status: GiftStates.loading));
    final result = await _getWheelWalletUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(status: GiftStates.error, failure: failure),
        (wheelWallet) => state.copyWith(wheel: wheelWallet),
      ),
    );
  }

  void loadData() async {
    await fetchGiftWallet();
    await getWheelWallet();
    // await fetchCompetitionWallet();
  }

  requestWithdraw(String id) async {
    final response = await _requestWithdrawUseCase(id);
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: GiftStates.errorRequest));
    }, (data) {
      emit(state.copyWith(status: GiftStates.success));
    });
  }

  requestWithdrawWheel() async {
    final response = await _requestWithdrawWheelUseCase(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: GiftStates.errorRequest));
    }, (data) {
      emit(state.copyWith(status: GiftStates.success));
    });
  }
}
