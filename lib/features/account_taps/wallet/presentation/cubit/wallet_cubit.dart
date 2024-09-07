import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import '../../domain/entities/wallet/wallet_entity.dart';
import '../../domain/entities/wallet/wallet_history_entity.dart';
import '../../domain/entities/wallet/wallet_subscription_entity.dart';
import '../../domain/usecases/get_subscription_use_case.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetWalletUseCase _getWalletUseCase;
  final GetWalletHistoryUseCase _walletHistoryUseCase;
  final GetSubscriptionWalletUseCase _subscriptionWalletUseCase;

  WalletCubit(this._getWalletUseCase, this._walletHistoryUseCase, this._subscriptionWalletUseCase) : super(const WalletState());

  void loadData() async {
    await getWallet();
    await fetchWalletHistory();
    await fetchWalletSubscription();
  }

  Future<void> getWallet() async {
    final response =
        await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      emit(state.copyWith(wallet: data));
    });
  }

  Future<void> fetchWalletHistory() async {
    final response = await _walletHistoryUseCase(
      WalletHistoryParams(
        page: 1,
        limit: 20,
      ),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      // print('///////////////////////////////////////');
      // print(data.giftWallet.userId);
      // print('///////////////////////////////////////');
      emit(state.copyWith(history: data));
    });
  }

  Future<void> fetchWalletSubscription() async {
    final response = await _subscriptionWalletUseCase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      // print('///////////////////////////////////////');
      // print(data.giftWallet.userId);
      // print('///////////////////////////////////////');
      emit(state.copyWith(subscription: data));
    });
  }
}
