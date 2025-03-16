import 'package:bloc/bloc.dart';

import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/data_winners_cashback_entity.dart';
import '../../../domain/usecases/get_winners_cashback_use_case.dart';

part 'winners_cashback_state.dart';

class WinnersCashbackCubit extends Cubit<WinnersCashbackState> {
  WinnersCashbackCubit(this._getWinnersCashbackUseCase)
      : super(WinnersCashbackState(status: WinnersCashbackStates.initial));

  final GetWinnersCashbackUseCase _getWinnersCashbackUseCase;

  final limit = 15;

  Future<void> getWinners(context) async {
    if (state.page == 1) {
      emit(state.copyWith(status: WinnersCashbackStates.loading));
    }

    final response = await _getWinnersCashbackUseCase.call(
      GetWinnersCashbackUseCaseParams(page: state.page, limit: limit),
    );

    response.fold(
      (f) {
        emit(state.copyWith(
          status: WinnersCashbackStates.failure,
          errMessage: getFailureMessage(f, context),
        ));
      },
      (newData) {
        final isLastPage = newData.winnersCashback.length < limit;

        emit(state.copyWith(
          status: WinnersCashbackStates.success,
          winnersCashback: state.winnersCashback == null
              ? newData
              : DataWinnersCashbackEntity(
                  winnersCashback: [
                    ...state.winnersCashback!.winnersCashback,
                    ...newData.winnersCashback,
                  ],
                  pagination: state.winnersCashback!.pagination,
                ),
          hasReachedMax: isLastPage,
          page: isLastPage ? state.page : state.page + 1,
        ));
      },
    );
  }
}
