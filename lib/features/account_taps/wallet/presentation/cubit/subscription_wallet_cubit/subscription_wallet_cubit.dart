import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/delete_subscription_use_case.dart';

part 'subscription_wallet_state.dart';

class SubscriptionWalletCubit extends Cubit<SubscriptionWalletState> {
  SubscriptionWalletCubit(this._deleteSubscriptionUseCase)
      : super(SubscriptionWalletInitial());

  final DeleteSubscriptionUseCase _deleteSubscriptionUseCase;

  Future<void> deleteSubscription({required String subscriptionId}) async {
    emit(SubscriptionWalletLoading());
    final response = await _deleteSubscriptionUseCase
        .call(DeleteSubscriptionParams(subscriptionId: subscriptionId));

    response.fold(
      (l) {
        emit(SubscriptionWalletFailure(message: l.toString()));
      },
      (r) {
        emit(SubscriptionWalletSuccess());
      },
    );
  }
}
