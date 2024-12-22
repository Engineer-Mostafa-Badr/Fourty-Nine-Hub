import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_state.dart';

import '../../../wallet/domain/entities/wallet/wallet_entity.dart';
import '../../../wallet/domain/usecases/get_wallet_usecase.dart';
import '../../domain/use_case/fetch_user_use_case.dart';

class TransferMoneyCubit extends Cubit<TransferMoneyState> {
  final TransferMoneyUseCase _transferMoneyUseCase;
  final FetchUserUseCase _fetchUserUseCase;
  final GetWalletUseCase _getWalletUseCase;

  TransferMoneyCubit(
    this._transferMoneyUseCase,
    this._fetchUserUseCase,
    this._getWalletUseCase,
  ) : super(const TransferMoneyState());

  Future<void> loadData() async {
    await fetchUsers();
    await getWallet();
  }

  TransferMoneyEntity? dataTransfer;
  Future<TransferMoneyEntity> transferMoney({
    required TransferMoneyParams params,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));
    var response = await _transferMoneyUseCase(params);
    response.fold(
      (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
      (data) {
        // getWallet();
        dataTransfer = data;
        emit(state.copyWith(dataTransfer: data, status: StateStatus.success));
      },
    );
    return dataTransfer!;
  }

  Future<void> fetchUsers() async {
    emit(state.copyWith(status: StateStatus.loading));
    var response = await _fetchUserUseCase(const NoParams());
    return response.fold(
      (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
      (data) {
        emit(state.copyWith(users: data));
      },
    );
  }

  WalletEntity? da;
  Future<WalletEntity> getWallet() async {
    final response = await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      da = data;
      emit(state.copyWith(wallet: data));
    });
    return da!;
  }
}
