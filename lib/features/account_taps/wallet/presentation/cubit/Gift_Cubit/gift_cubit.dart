import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_gifts_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';

class GiftCubit extends Cubit<GiftState>{
 final GetWalletGiftsUseCase _giftUseCases;

  GiftCubit(this._giftUseCases,) : super(const GiftState());


 void loadData() async {
  await fetchGiftWallet();
  // await fetchCompetitionWallet();
 }

 Future<void> fetchGiftWallet() async {
   final response = await _giftUseCases.call(const NoParams());
   response.fold((l) {
     emit(state.copyWith(failure: l, status: GiftStates.error));
   }, (data) {
     print('///////////////////////////////////////');
     print(data.giftWallet.userId);
     print('///////////////////////////////////////');
     emit(state.copyWith(gift: data));


   });
 }

 // Future<void> fetchCompetitionWallet() async {
 //   final response = await _giftUseCases.call();
 //   response.fold((l) {
 //     emit(state.copyWith(failure: l, status: GiftStates.error));
 //   }, (data) {
 //     emit(state.copyWith(gift: data));
 //   });
 // }
}