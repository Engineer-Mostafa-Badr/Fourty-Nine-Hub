import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/Gift/get_gift_wallet.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';

import '../../../domain/usecases/Gift/get_competition_wallet.dart';

class GiftCubit extends Cubit<GiftState>{
 final GetGiftUseCases _giftUseCases;
 final GetGiftCompetitionUseCases _giftCompetitionUseCases;

  GiftCubit(this._giftUseCases, this._giftCompetitionUseCases) : super(const GiftState());


 void loadData() async {
  await fetchGiftWallet();
  await fetchCompetitionWallet();
 }

 Future<void> fetchGiftWallet() async {
   final response = await _giftCompetitionUseCases.call();
   response.fold((l) {
     emit(state.copyWith(failure: l, status: GiftStates.error));
   }, (data) {
     emit(state.copyWith(competition: data));
   });
 }

 Future<void> fetchCompetitionWallet() async {
   final response = await _giftUseCases.call();
   response.fold((l) {
     emit(state.copyWith(failure: l, status: GiftStates.error));
   }, (data) {
     emit(state.copyWith(gift: data));
   });
 }
}