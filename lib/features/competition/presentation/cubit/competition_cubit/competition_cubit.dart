import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/competition/data/repository/competition_repo.dart';

import '../../../../../core/error/failure.dart';
import 'competition_state.dart';

class CompetitionCubit extends Cubit<CompetitionState> {
  CompetitionCubit(this.competitionRepo) : super(CompetitionInitial());

  final CompetitionRepo competitionRepo;
  static CompetitionCubit get(context) => BlocProvider.of(context);

  //Timer? _pollingTimer;

  void fetchCompetition(context) async {
    emit(CompetitionLoadingState());
    var result = await competitionRepo.fetchCompetition();
    result.fold((failure) {
      emit(CompetitionErrorState(
          errMessage: getFailureMessage(failure, context)));
      print(getFailureMessage(failure, context));
    }, (competition) {
      emit(CompetitionSuccessState(competitionModel: competition));
    });
  }

  // void _startPolling(context) {
  //   _pollingTimer?.cancel();
  //
  //   // Start polling every 10 seconds (adjust the interval as needed)
  //   _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
  //     var result =await competitionRepo.fetchCompetition();
  //
  //     result.fold((failure) {
  //       emit(CompetitionErrorState(errMessage: getFailureMessage(failure, context)));
  //       print(getFailureMessage(failure, context));
  //     }, (competition) {
  //       emit(CompetitionSuccessState(competitionModel: competition));
  //     });
  //   });
  // }
}
