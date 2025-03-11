part of 'floating_navigator_cubit.dart';

sealed class FloatingNavigatorState extends Equatable {
  const FloatingNavigatorState();

  @override
  List<Object> get props => [];
}

class InitFloatNavigatorStatusState extends FloatingNavigatorState{}
class GetFloatNavigatorStatusState extends FloatingNavigatorState{}
class ActiveFloatNavigatorStatusState extends FloatingNavigatorState{}
class UnActiveFloatNavigatorStatusState extends FloatingNavigatorState {}
class GetEnableFloatNavigatorState extends FloatingNavigatorState{}
class EnableFloatNavigatorState extends FloatingNavigatorState{}
class DisAbleFloatNavigatorState extends FloatingNavigatorState {}
