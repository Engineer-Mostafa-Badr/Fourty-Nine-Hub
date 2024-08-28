import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';

import '../../data/models/winners_model.dart';


abstract class CompetitionState {}

class CompetitionInitial extends CompetitionState {}

class CompetitionLoadingState extends CompetitionState {}

class CompetitionSuccessState extends CompetitionState {
  final CompetitionModel competitionModel;

  CompetitionSuccessState({required this.competitionModel});
}

class CompetitionErrorState extends CompetitionState {
  final String errMessage;

  CompetitionErrorState({required this.errMessage});
}

class WinnersLoadingState extends CompetitionState {}

class WinnersSuccessState extends CompetitionState {
  final WinnersModel winnersModel;

  WinnersSuccessState({required this.winnersModel});
}

class WinnersErrorState extends CompetitionState {
  final String errMessage;

  WinnersErrorState({required this.errMessage});
}