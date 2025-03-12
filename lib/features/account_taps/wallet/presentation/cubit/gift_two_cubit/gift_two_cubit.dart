import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_gifts_use_case.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/use_cases/get_wheel_wallet_use_case.dart';

part 'gift_two_state.dart';

class GiftTwoCubit extends Cubit<GiftTwoState> {
  GiftTwoCubit(this._giftUseCases, this._getWheelWalletUseCase)
      : super(GiftTwoInitial());

  final GetWalletGiftsUseCase _giftUseCases;
  final GetWheelWalletUseCase _getWheelWalletUseCase;

  Future<void> getAllData(context) async {
    emit(GiftTwoLoading());
    final response = await _giftUseCases.call(const NoParams());
    response.fold((f) {
      emit(GiftTwoFailure(message: getFailureMessage(f, context)));
    }, (giftEntity) async {
      final response = await _getWheelWalletUseCase(const NoParams());
      response.fold(
        (f) {
          emit(GiftTwoFailure(message: getFailureMessage(f, context)));
        },
        (wheelWalletEntity) {
          emit(
            GiftTwoSuccess(
              // giftEntity: giftEntity,
              wheelWalletEntity: wheelWalletEntity,
            ),
          );
        },
      );
      // emit(GiftTwoSuccess(gift: data));
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

  Future<void> fetchWheelWallet(context) async {
    emit(GiftTwoLoading());
    final response = await _getWheelWalletUseCase.call(const NoParams());
    response.fold(
      (f) {
        emit(GiftTwoFailure(message: getFailureMessage(f, context)));
      },
      (data) {
        emit(GiftTwoSuccess(wheelWalletEntity: data));
      },
    );
  }
}
