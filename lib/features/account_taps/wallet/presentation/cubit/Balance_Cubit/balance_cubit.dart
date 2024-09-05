import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';

import 'balance_states.dart';

class BalanceCubit extends Cubit<BalanceState>{
 final GetBalanceUseCases _balanceUseCases;

 BalanceCubit(this._balanceUseCases,) : super(const BalanceState());


 void loadData() async {
  await fetchBalanceWallet();
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
}