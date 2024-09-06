import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';

import '../../../domain/usecases/get_balance_history_use_case.dart';
import 'balance_states.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final GetBalanceUseCases _balanceUseCases;
  final GetBalanceHistoryUseCase _balanceHistoryUseCase;

  BalanceCubit(
    this._balanceUseCases,
    this._balanceHistoryUseCase,
  ) : super(const BalanceState());

  void loadData() async {
    await fetchBalanceWallet();
    await fetchBalanceHistory();
  }

  Future<void> fetchBalanceWallet() async {
    final response = await _balanceUseCases.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      // print('///////////////////////////////////////');
      // print(data.giftWallet.userId);
      // print('///////////////////////////////////////');
      emit(state.copyWith(balance: data));
    });
  }

  Future<void> fetchBalanceHistory() async {
    final response = await _balanceHistoryUseCase(
      BalanceHistoryParams(
        page: 1,
        limit: 20,
      ),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: BalanceStates.error));
    }, (data) {
      // print('///////////////////////////////////////');
      // print(data.giftWallet.userId);
      // print('///////////////////////////////////////');
      emit(state.copyWith(history: data));
    });
  }
}
