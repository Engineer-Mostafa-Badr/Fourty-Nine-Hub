import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/competition/data/repository/competition_repo.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/winner_cubit/winner_state.dart';

import '../../../../../core/error/failure.dart';

class WinnerCubit extends Cubit<WinnerState> {
  WinnerCubit(this.competitionRepo) : super(WinnerInitial());

  final CompetitionRepo competitionRepo;
  static WinnerCubit get(context) => BlocProvider.of(context);

  //Timer? _pollingTimer;

  void fetchWinners(context) async {
    emit(WinnersLoadingState());
    var result = await competitionRepo.fetchWinners();

    result.fold((failure) {
      emit(WinnersErrorState(errMessage: getFailureMessage(failure, context)));
    }, (winner) {
      emit(WinnersSuccessState(winnersModel: winner));
    });
  }

  // void _startPollingCompetition(context) {
  //   _pollingTimer?.cancel();
  //
  //   // Start polling every 10 seconds (adjust the interval as needed)
  //   _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
  //
  //   });
  // }

  // void _startPolling(context) {
  //   _pollingTimer?.cancel();
  //
  //   _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
  //     var result =await competitionRepo.fetchWinners();
  //
  //     result.fold((failure) {
  //       emit(WinnersErrorState(errMessage: getFailureMessage(failure, context)));
  //     }, (winner) {
  //       emit(WinnersSuccessState(winnersModel: winner));
  //     });
  //   });
  // }
}
