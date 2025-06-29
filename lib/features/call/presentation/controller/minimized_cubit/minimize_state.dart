part of 'minimize_cubit.dart';

sealed class MinimizeState extends Equatable {
  const MinimizeState();

  @override
  List<Object> get props => [];
}

final class MinimizeInitial extends MinimizeState {}


class CallMinimized extends MinimizeState {
  final bool isMinimized;
  
  const CallMinimized({this.isMinimized = true});
}
