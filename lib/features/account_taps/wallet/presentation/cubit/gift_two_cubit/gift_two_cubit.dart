import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_gifts_use_case.dart';
import '../../../domain/entities/gift_and_competition_entity.dart';
import '../../../domain/entities/gift_competitions_entity.dart';
import '../../../domain/entities/gift_wallet_entity.dart';
import '../../../domain/usecases/get_gift_competitions_use_case.dart';
import '../../../domain/usecases/transfer_balance_use_cse.dart';
import '../../../domain/usecases/transfer_ten_balance_use_cse.dart';

part 'gift_two_state.dart';

class GiftTwoCubit extends Cubit<GiftTwoState> {
  GiftTwoCubit(
    // this._giftUseCases,
    this._getGiftCompetitionsUseCase,
    this._transferFiveBalanceUseCase,
    this._transferTenBalanceUseCase,
  ) : super(const GiftTwoState(status: GiftTwoStates.initial));

  // final GetWalletGiftsUseCase _giftUseCases;
  final GetGiftCompetitionsUseCase _getGiftCompetitionsUseCase;
  final TransferFiveBalanceUseCase _transferFiveBalanceUseCase;
  final TransferTenBalanceUseCase _transferTenBalanceUseCase;

  Future<void> requestTransferFiveYears(context) async {
    emit(const GiftTwoState(buttonRequestFiveLoading: true));
    final response = await _transferFiveBalanceUseCase.call(const NoParams());
    response.fold((f) {
      emit(
        const GiftTwoState(
          buttonRequestFiveLoading: false,
        ),
      );
      showErrorMessage(context, getFailureMessage(f, context));
    }, (data) {
      emit(const GiftTwoState(buttonRequestFiveLoading: false));
      getAllData(context);
    });
  }

  Future<void> requestTransferTenYears(context) async {
    emit(const GiftTwoState(buttonRequestTenLoading: true));
    final response = await _transferTenBalanceUseCase.call(const NoParams());
    response.fold((f) {
      emit(
        const GiftTwoState(
          buttonRequestTenLoading: false,
        ),
      );
      showErrorMessage(context, getFailureMessage(f, context));
    }, (data) {
      emit(const GiftTwoState(buttonRequestTenLoading: false));
      getAllData(context);
    });
  }

  Future<void> getAllData(context) async {
    emit(const GiftTwoState(status: GiftTwoStates.loading));
    final response = await _getGiftCompetitionsUseCase.call(const NoParams());
    response.fold((f) {
      emit(
        GiftTwoState(
          status: GiftTwoStates.failure,
          errMessage: getFailureMessage(f, context),
        ),
      );
    }, (gift) async {
      emit(GiftTwoState( status: GiftTwoStates.success,
          giftAndCompetitionEntity: gift));
    });
  }

  // Future<void> fetchGift(context) async {
  //   final response = await _giftUseCases.call(const NoParams());
  //   response.fold((f) {
  //     emit(
  //       GiftTwoState(
  //         status: GiftTwoStates.failure,
  //         errMessage: getFailureMessage(f, context),
  //       ),
  //     );
  //   }, (data) {
  //     emit(GiftTwoState(giftEntity: data));
  //   });
  // }

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
