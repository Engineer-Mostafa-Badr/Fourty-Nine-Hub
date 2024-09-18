import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_state.dart';

class TransferMoneyCubit extends Cubit<TransferMoneyState> {

  final TransferMoneyUseCase _transferMoneyUseCase;

  TransferMoneyCubit(this._transferMoneyUseCase) : super(const TransferMoneyState());


  Future<void> transferMoney({
    required TransferMoneyParams params,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));
    var response = await _transferMoneyUseCase(params);
    return response.fold(
          (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
          (data) {
        emit(state.copyWith(status: StateStatus.success));
      },
    );
  }
}
