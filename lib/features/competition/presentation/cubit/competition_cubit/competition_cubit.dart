import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/competition/domain/use_case/fetch_competition_use_case.dart';
import 'package:fourtyninehub/features/competition/domain/use_case/fetch_winner_competition_use_case.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/competition_cubit/competition_state.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_currency_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';

class CompetitionCubit extends Cubit<CompetitionState> {
  final FetchCompetitionUseCase _competitionUseCase;
  final FetchWinnerCompetitionUseCase _winnerCompetitionUseCase;
  final GetCurrencyUseCase _currencyUseCase;

  CompetitionCubit(
    this._competitionUseCase,
    this._winnerCompetitionUseCase,
    this._currencyUseCase,
  ) : super(const CompetitionState());

  Future<void> fetchCompetition() async {
    final response = await _competitionUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));

      emit(state.copyWith(failure: l, status: CompetitionStates.error));
    }, (data) {
      emit(
          state.copyWith(competition: data, status: CompetitionStates.success));
    });
  }

  Future<void> fetchWinnerCompetition() async {
    final response = await _winnerCompetitionUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CompetitionStates.error));
    }, (data) {
      emit(state.copyWith(winner: data, status: CompetitionStates.success));
    });
  }

  Future<void> getCurrency() async {
    final response = await _currencyUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: CompetitionStates.error));
    }, (data) {
      emit(state.copyWith(currency: data, status: CompetitionStates.success));
    });
  }

  Future<void> loadData() async {
    await fetchCompetition();
    await getCurrency();
  }
}
