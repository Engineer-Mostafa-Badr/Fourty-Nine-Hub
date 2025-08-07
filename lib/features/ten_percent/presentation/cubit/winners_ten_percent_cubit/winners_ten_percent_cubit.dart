import 'package:bloc/bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entities/winners_ten_percent_entity.dart';
import '../../../domain/usecases/get_winners_ten_percent_use_case.dart';

part 'winners_ten_percent_state.dart';

class WinnersTenPercentCubit extends Cubit<WinnersTenPercentState> {
  WinnersTenPercentCubit(
    this._getWinnersTenPercentUseCase,
  ) : super(WinnersTenPercentState());

  final GetWinnersTenPercentUseCase _getWinnersTenPercentUseCase;

  final int limit = 30;

  Future<void> getWinners({bool isRefresh = false}) async {
    if (state.page == 1 || isRefresh) {
      emit(state.copyWith(
        status: WinnersTenPercentStatus.loading,
      ));
    }
    // emit(state.copyWith(status: WinnersTenPercentStatus.loading));
    final result = await _getWinnersTenPercentUseCase(
      GetWinnersTenPercentParams(
        page: state.page,
        limit: limit,
      ),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: WinnersTenPercentStatus.failure,
          failure: failure,
        ));
      },
      (winners) {
        emit(state.copyWith(
          status: WinnersTenPercentStatus.success,
          winners: winners,
          page: state.page + 1,
          hasReachedMax: winners.latestWinners.length < limit,
        ));
      },
    );
  }
}
