import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_state.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../wallet/domain/usecases/get_wallet_usecase.dart';
import '../../domain/use_case/fetch_user_use_case.dart';

class TransferMoneyCubit extends Cubit<TransferMoneyState> {
  final TransferMoneyUseCase _transferMoneyUseCase;
  final FetchUserUseCase _fetchUserUseCase;
  final GetWalletUseCase _getWalletUseCase;

  TransferMoneyEntity? dataTransfer;

  TransferMoneyCubit(
    this._transferMoneyUseCase,
    this._fetchUserUseCase,
    this._getWalletUseCase,
  ) : super(const TransferMoneyState());

  // WalletEntity? da;

  Future<void> loadData() async {
    emit(state.copyWith(status: TransferMoneyStates.loading));
    var response = await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: TransferMoneyStates.failure));
    }, (data) {
      // da = data;
      emit(state.copyWith(
        status: TransferMoneyStates.success,
        wallet: data,
      ));
    });
  }
  // Future<void> loadData() async {
  //   // await fetchUsers();
  //   await getWallet();
  //   emit(state.copyWith(status: TransferMoneyStates.loading));
  //   // var response = await _fetchUserUseCase(const NoParams());
  //   return response.fold(
  //     (l) =>
  //         emit(state.copyWith(failure: l, status: TransferMoneyStates.error)),
  //     (user) async {
  //       emit(state.copyWith(users: user));
  //       final response = await _getWalletUseCase.call(const NoParams());
  //       response.fold((l) {
  //         emit(state.copyWith(failure: l, status: TransferMoneyStates.error));
  //       }, (data) {
  //         da = data;
  //         emit(state.copyWith(status: TransferMoneyStates.success, wallet: data));
  //       });
  //     },
  //   );
  // }

  Future<void> searchUser({required String query}) async {
    emit(state.copyWith(searchUserStatus: TransferMoneyStates.loading));
    var response = await _fetchUserUseCase(FetchUserParams(query: query));
    return response.fold(
      (l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        emit(state.copyWith(
          failure: l,
          searchUserStatus: TransferMoneyStates.failure,
        ));
      },
      (data) {
        emit(state.copyWith(
          users: data,
          searchUserStatus: TransferMoneyStates.success,
        ));
      },
    );
  }

  void selectUser(String userEmail) {
    emit(state.copyWith(
      userSelectedEmail: userEmail,
      searchUserStatus: TransferMoneyStates.initial,
    ));
  }

  Future<TransferMoneyEntity> transferMoney({
    required TransferMoneyParams params,
  }) async {
    emit(state.copyWith(transferStatus: TransferMoneyStates.loading));
    var response = await _transferMoneyUseCase.call(params);
    response.fold(
      (l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        emit(state.copyWith(
            failure: l, transferStatus: TransferMoneyStates.failure));
      },
      (data) {
        // getWallet();
        dataTransfer = data;
        emit(state.copyWith(
            dataTransfer: data, transferStatus: TransferMoneyStates.success));
      },
    );
    return dataTransfer!;
  }

  // Future<void> fetchUsers() async {
  //   emit(state.copyWith(status: TransferMoneyStates.loading));
  //   var response = await _fetchUserUseCase(const NoParams());
  //   return response.fold(
  //     (l) => emit(state.copyWith(failure: l, status: TransferMoneyStates.error)),
  //     (data) {
  //       emit(state.copyWith(users: data));
  //     },
  //   );
  // }

  // Future<WalletEntity> getWallet() async {
  //   final response = await _getWalletUseCase.call(const NoParams());
  //   response.fold((l) {
  //     emit(state.copyWith(failure: l, status: TransferMoneyStates.failure));
  //   }, (data) {
  //     // da = data;
  //     emit(state.copyWith(wallet: data, status: TransferMoneyStates.success));
  //   });

  // }
}
