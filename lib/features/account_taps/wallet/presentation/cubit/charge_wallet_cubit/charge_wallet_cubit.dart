import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/get_active_subscription_amounts.dart';

part 'charge_wallet_state.dart';

class ChargeWalletCubit extends Cubit<ChargeWalletState> {
  ChargeWalletCubit(this._getActiveSubscriptionAmountsUseCase)
      : super(ChargeWalletInitial());

  final GetActiveSubscriptionAmountsUseCase
      _getActiveSubscriptionAmountsUseCase;

  Future<void> showActiveSubscriptionAmounts(
      {required WalletTypes walletType}) async {
    emit(ChargeWalletLoading());

    final response =
        await _getActiveSubscriptionAmountsUseCase(const NoParams());
    response.fold(
      (l) {
        emit(ChargeWalletFailure(message: l.toString()));
      },
      (data) {
        emit(ChargeWalletSuccess(
          amounts: data,
        ));
      },
    );
  }

  // Future<void> showActiveSubscriptionAmounts(
  //   context, {
  //   required WalletTypes walletType,
  // }) async {
  //   emit(ChargeWalletClicked());
  //   final response =
  //       await _getActiveSubscriptionAmountsUseCase(const NoParams());
  //   response.fold(
  //     (l) => showErrorMessage(
  //       context,
  //       Labels.errorHappened,
  //     ),
  //     (data) => bottomSheet(
  //       context: context,
  //       widget: SubscriptoinAmountsWidget(
  //         amounts: data,
  //         walletType: walletType,
  //       ),
  //     ),
  //   );
  // }
}
