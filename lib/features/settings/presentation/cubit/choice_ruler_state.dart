part of 'choice_ruler_cubit.dart';

sealed class ChoiceRulerState extends Equatable {
  const ChoiceRulerState();

  @override
  List<Object> get props => [];
}

class InitChoiceRulerStatusState extends ChoiceRulerState{}
class ActiveChoiceRulerStatusState extends ChoiceRulerState{}
class UnActiveChoiceRulerStatusState extends ChoiceRulerState {}
class EnableChoiceRulerStatusState extends ChoiceRulerState{}
class DisAbleChoiceRulerStatusState extends ChoiceRulerState {}

