import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_gifts_use_case.dart';
import '../../../domain/entities/gift_competitions_entity.dart';
import '../../../domain/entities/gift_wallet_entity.dart';
import '../../../domain/usecases/get_gift_competitions_use_case.dart';

part 'gift_two_state.dart';

class GiftTwoCubit extends Cubit<GiftTwoState> {
  GiftTwoCubit(this._giftUseCases, this._getGiftCompetitionsUseCase)
      : super(GiftTwoInitial());

  final GetWalletGiftsUseCase _giftUseCases;
  final GetGiftCompetitionsUseCase _getGiftCompetitionsUseCase;

  Future<void> getAllData(context) async {
    emit(GiftTwoLoading());
    final response = await _giftUseCases.call(const NoParams());
    response.fold((f) {
      emit(GiftTwoFailure(message: getFailureMessage(f, context)));
    }, (gift) async {
      final response = await _getGiftCompetitionsUseCase.call(const NoParams());
      response.fold(
        (f) {
          emit(GiftTwoFailure(message: getFailureMessage(f, context)));
        },
        (competitions) {
          emit(
            GiftTwoSuccess(
              giftEntity: gift,
              giftCompetitionEntity: competitions,
            ),
          );
        },
      );
    });
  }

  Future<void> fetchGift(context) async {
    emit(GiftTwoLoading());
    final response = await _giftUseCases.call(const NoParams());
    response.fold((f) {
      emit(GiftTwoFailure(message: getFailureMessage(f, context)));
    }, (data) {
      // emit(GiftTwoSuccess(giftEntity: data));
    });
  }

  // Future<void> fetchWheelWallet(context) async {
  //   emit(GiftTwoLoading());
  //   final response = await _getWheelWalletUseCase.call(const NoParams());
  //   response.fold(
  //     (f) {
  //       emit(GiftTwoFailure(message: getFailureMessage(f, context)));
  //     },
  //     (data) {
  //       // emit(GiftTwoSuccess(wheelWalletEntity: data));
  //     },
  //   );
  // }
}
