part of 'floating_navigator_cubit.dart';

sealed class FloatingNavigatorState extends Equatable {
  const FloatingNavigatorState();

  @override
  List<Object> get props => [];
}

class ActiveFloatNavigatorStatusState extends FloatingNavigatorState{}
class UnActiveFloatNavigatorStatusState extends FloatingNavigatorState {}

