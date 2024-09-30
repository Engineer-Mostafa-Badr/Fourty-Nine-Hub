import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/check_withdraw_balance_use_cse.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';

import '../../../../../../common/models/public/pagination_params.dart';
import '../../../domain/entities/balance/balance_history_entity.dart';
import '../../../domain/usecases/get_balance_history_use_case.dart';
import '../../../domain/usecases/transfer_balance_use_cse.dart';
import '../../../domain/usecases/transfer_ten_balance_use_cse.dart';
import '../../../domain/usecases/withdraw_balance_use_cse.dart';
import 'balance_states.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final GetBalanceUseCases _balanceUseCases;
  final GetBalanceHistoryUseCase _balanceHistoryUseCase;
  final TransferFiveBalanceUseCase _transferFiveBalanceUseCase;
  final TransferTenBalanceUseCase _transferTenBalanceUseCase;
  final RequestWithdrawBalanceUseCase _withdrawBalanceUseCase;
  final CheckRequestWithdrawUseCase _checkRequestWithdrawUseCase;

  BalanceCubit(
    this._balanceUseCases,
    this._balanceHistoryUseCase,
    this._transferFiveBalanceUseCase,
    this._transferTenBalanceUseCase,
    this._withdrawBalanceUseCase,
    this._checkRequestWithdrawUseCase,
  ) : super(const BalanceState());

  void loadData() async {
    await fetchBalanceWallet();
    await checkRequestWithdrawBalance();
    // await fetchBalanceHistory();
  }

  Future<void> fetchBalanceWallet() async {
    final response = await _balanceUseCases.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      emit(state.copyWith(balance: data));
    });
  }

  Future<List<BalanceHistoryEntity>> fetchBalanceHistory({
    required PaginationParams paginationParams,
  }) async {
    List<BalanceHistoryEntity> history = [];

    final response = await _balanceHistoryUseCase(
      BalanceHistoryParams(paginationParams: paginationParams),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      history = data;
      // print('///////////////////////////////////////');
      // print(data.giftWallet.userId);
      // print('///////////////////////////////////////');
      //   emit(state.copyWith(history: data));
    });
    return history;
  }

  transferFiveBalance() async {
    final response = await _transferFiveBalanceUseCase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      fetchBalanceWallet();
      emit(state.copyWith(status: BalanceStates.successFive));
    });
  }

  transferTenBalance() async {
    final response = await _transferTenBalanceUseCase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      fetchBalanceWallet();
      emit(state.copyWith(status: BalanceStates.successTen));
    });
  }

  requestWithdrawBalance() async {
    final response = await _withdrawBalanceUseCase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      emit(state.copyWith(status: BalanceStates.initial));
    });
  }

  checkRequestWithdrawBalance() async {
    final response = await _checkRequestWithdrawUseCase.call(const NoParams());
    return response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      emit(state.copyWith(
        withdraw: data,
      ));
    });
  }
}
