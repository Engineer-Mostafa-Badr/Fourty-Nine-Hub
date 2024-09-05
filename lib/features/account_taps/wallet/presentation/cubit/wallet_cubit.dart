import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competition_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_competitions_usecase.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_usecase.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_history_entity.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  // final GetCompetitionsUsecase _getCompetitionsUsecase;
  // final GetWalletHistoryUseCase _getWalletHistoryUseCase;
  final GetWalletUseCase _getWalletUseCase;

  WalletCubit(this._getWalletUseCase) : super(const WalletState());

  void loadData() async {
   // await getBalanceWalletHistory();
    await getWallet();
   // await getCompetitions();
  }

  // Future<void> getBalanceWalletHistory() async {
  //   final response = await _getWalletHistoryUseCase.call(WalletTypes.balance);
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: WalletStates.error));
  //   }, (data) {
  //     emit(state.copyWith(balanceHistory: data));
  //   });
  // }

  Future<void> getWallet() async {
    final response =
        await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      emit(state.copyWith(wallet: data));
    });
  }

  // Future<void> getCompetitions() async {
  //   final response = await _getCompetitionsUsecase.call(const NoParams());
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: WalletStates.error));
  //   }, (data) {
  //     emit(state.copyWith(competitions: data));
  //   });
  // }
  //
  // void showGiftsHistory({
  //   required BuildContext context,
  // }) async {
  //   final response =
  //       await _getWalletHistoryUseCase.call(WalletTypes.giftWallet);
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: WalletStates.error));
  //   }, (data) {
  //     context.push(Routes.WALLETHISTORY, extra: data);
  //   });
  // }
}
