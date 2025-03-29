import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_wheel_use_case.dart';
import '../../../domain/entities/gift_and_competition_entity.dart';
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
    this._requestWithdrawUseCase,
    this._requestWithdrawWheelUseCase,
  ) : super(const GiftTwoState(status: GiftTwoStates.initial));

  // final GetWalletGiftsUseCase _giftUseCases;
  final GetGiftCompetitionsUseCase _getGiftCompetitionsUseCase;
  final TransferFiveBalanceUseCase _transferFiveBalanceUseCase;
  final TransferTenBalanceUseCase _transferTenBalanceUseCase;
  final RequestWithdrawUseCase _requestWithdrawUseCase;
  final RequestWithdrawWheelUseCase _requestWithdrawWheelUseCase;

  Future<void> requestTransferLuckyWheel(context) async {
    emit(state.copyWith(buttonRequestCompetitionLoading: true));

    final response = await _requestWithdrawWheelUseCase.call(const NoParams());

    response.fold((f) {
      emit(
        state.copyWith(
          buttonRequestCompetitionLoading: false,
          buttonRequestCompetitionErrMessage: getFailureMessage(f, context),
        ),
      );
      showErrorMessage(context, state.buttonRequestCompetitionErrMessage!);
    }, (data) {
      emit(
        state.copyWith(
          buttonRequestCompetitionLoading: false,
          buttonRequestCompetitionSuccess: true,
        ),
      );
      showSuccessMessage(context, LocaleKeys.requestSentSuccess.localize);
      getAllData(context);
    });
  }

  Future<void> requestTransferCompetition(context,
      {required String competitionId}) async {
    emit(state.copyWith(buttonRequestCompetitionLoading: true));

    final response = await _requestWithdrawUseCase.call(competitionId);

    response.fold((f) {
      emit(
        state.copyWith(
          buttonRequestCompetitionLoading: false,
          buttonRequestCompetitionErrMessage: getFailureMessage(f, context),
        ),
      );
      showErrorMessage(context, state.buttonRequestCompetitionErrMessage!);
    }, (data) {
      emit(
        state.copyWith(
          buttonRequestCompetitionLoading: false,
          buttonRequestCompetitionSuccess: true,
        ),
      );
      showSuccessMessage(context, LocaleKeys.requestSentSuccess.localize);
      getAllData(context);
    });
  }

  Future<void> requestTransferFiveYears(context) async {
    emit(state.copyWith(buttonRequestFiveLoading: true));
    final response = await _transferFiveBalanceUseCase.call(const NoParams());
    response.fold((f) {
      emit(
        state.copyWith(
          buttonRequestFiveLoading: false,
        ),
      );
      showErrorMessage(context, getFailureMessage(f, context));
    }, (data) {
      emit(state.copyWith(buttonRequestFiveLoading: false));
      getAllData(context);
    });
  }

  Future<void> requestTransferTenYears(context) async {
    emit(state.copyWith(buttonRequestTenLoading: true));
    final response = await _transferTenBalanceUseCase.call(const NoParams());
    response.fold((f) {
      emit(
        state.copyWith(
          buttonRequestTenLoading: false,
        ),
      );
      showErrorMessage(context, getFailureMessage(f, context));
    }, (data) {
      emit(state.copyWith(buttonRequestTenLoading: false));
      getAllData(context);
    });
  }

  Future<void> getAllData(context) async {
    emit(state.copyWith(status: GiftTwoStates.loading));
    final response = await _getGiftCompetitionsUseCase.call(const NoParams());
    response.fold((f) {
      emit(
        state.copyWith(
          status: GiftTwoStates.failure,
          errMessage: getFailureMessage(f, context),
        ),
      );
    }, (gift) async {
      emit(state.copyWith(
          status: GiftTwoStates.success, giftAndCompetitionEntity: gift));
    });
  }

  // Future<void> fetchGift(context) async {
  //   final response = await _giftUseCases.call(const NoParams());
  //   response.fold((f) {
  //     emit(
  //       state.copyWith(
  //         status: GiftTwoStates.failure,
  //         errMessage: getFailureMessage(f, context),
  //       ),
  //     );
  //   }, (data) {
  //     emit(state.copyWith(giftEntity: data));
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
