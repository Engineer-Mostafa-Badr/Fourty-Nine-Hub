import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';

part 'cashback_state.dart';

class CashbackCubit extends Cubit<CashbackState> {
  CashbackCubit(
    this._balanceUseCases,
    this._balanceHistoryUseCase,
  ) : super(const CashbackState(status: CashbackStates.initial));

  final GetBalanceUseCases _balanceUseCases;
  final GetBalanceHistoryUseCase _balanceHistoryUseCase;

  final int limit = 30;

  Future<void> getCashback(context) async {
    if (state.page == 1) emit(state.copyWith(status: CashbackStates.loading));

    final response = await _balanceUseCases.call(const NoParams());
    response.fold((f) {
      emit(state.copyWith(
        status: CashbackStates.failure,
        messageFailure: getFailureMessage(f, context),
      ));
    }, (balanceDataEntity) async {
      final response = await _balanceHistoryUseCase(
        BalanceHistoryParams(page: state.page, limit: limit),
      );

      response.fold(
        (f) {
          emit(state.copyWith(
            status: CashbackStates.failure,
            messageFailure: getFailureMessage(f, context),
          ));
        },
        (balanceHistories) {
          emit(state.copyWith(
              status: CashbackStates.success,
              cashback: balanceDataEntity,
              histories: state.histories == null
                  ? balanceHistories
                  : state.histories! + balanceHistories,
              page: state.page + 1,
              hasReachedMax: balanceHistories.length != limit));
        },
      );
    });
  }

  Future<void> getHistories(context) async {
    final response = await _balanceHistoryUseCase(
      BalanceHistoryParams(page: state.page, limit: limit),
    );

    response.fold(
      (f) {
        emit(state.copyWith(
          status: CashbackStates.failure,
          messageFailure: getFailureMessage(f, context),
        ));
      },
      // emit(state.copyWith(failure: failure, status: BalanceStates.error)),
      (balanceHistories) {
        // history.addAll(data);

        // if (data.length < pageSize) {
        //   hasMoreData = false;
        // } else {
        //   currentPage++;
        // }

        emit(state.copyWith(
            status: CashbackStates.success,
            histories: state.histories == null
                ? balanceHistories
                : state.histories! + balanceHistories,
            page: state.page + 1,
            hasReachedMax: state.histories!.length != limit));
      },
    );
  }

  // List<BalanceHistoryEntity> history = [];
  // bool isLoadingMore = false;
  // bool hasMoreData = true;
  // int currentPage = 1;
  // int pageSize = 10;

  // Future<void> getCashbackHistoryMore(context) async {
  //   if (!hasMoreData || isLoadingMore) return;

  //   isLoadingMore = true;

  //   final response = await _balanceHistoryUseCase(
  //     BalanceHistoryParams(page: currentPage, limit: pageSize),
  //   );

  //   response.fold(
  //     (f) => emit(
  //       CashbackFailure(
  //         message: getFailureMessage(f, context),
  //       ),
  //     ),
  //     (balanceHistories) {
  //       history.addAll(balanceHistories);

  //       if (balanceHistories.length < pageSize) {
  //         hasMoreData = false;
  //       } else {
  //         currentPage++;
  //       }
  //     },
  //   );
  // }

  // Future<void> getCashback(context) async {
  //   emit(CashbackLoading());

  //   final response = await _balanceUseCases.call(const NoParams());
  //   response.fold((f) {
  //     emit(CashbackFailure(message: getFailureMessage(f, context)));
  //   }, (balanceDataEntity) async {
  //     final response = await _balanceHistoryUseCase(
  //       BalanceHistoryParams(page: 1, limit: 10),
  //     );

  //     response.fold(
  //       (f) => emit(
  //         CashbackFailure(
  //           message: getFailureMessage(f, context),
  //         ),
  //       ),
  //       // emit(state.copyWith(failure: failure, status: BalanceStates.error)),
  //       (balanceHistories) {
  //         // history.addAll(data);

  //         // if (data.length < pageSize) {
  //         //   hasMoreData = false;
  //         // } else {
  //         //   currentPage++;
  //         // }

  //         history = balanceHistories;

  //         emit(CashbackSuccess(
  //           cashback: balanceDataEntity,
  //           histories: balanceHistories,
  //         ));
  //       },
  //     );
  //   });
  // }
}
