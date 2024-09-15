import 'package:fourtyninehub/features/competition/data/models/competion_model.dart';

import '../../../data/models/winners_model.dart';

abstract class WinnerState {}

class WinnerInitial extends WinnerState {}

class WinnersLoadingState extends WinnerState {}

class WinnersSuccessState extends WinnerState {
  final WinnersModel winnersModel;

  WinnersSuccessState({required this.winnersModel});
}

class WinnersErrorState extends WinnerState {
  final String errMessage;

  WinnersErrorState({required this.errMessage});
}
