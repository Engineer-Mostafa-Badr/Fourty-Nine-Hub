import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';


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