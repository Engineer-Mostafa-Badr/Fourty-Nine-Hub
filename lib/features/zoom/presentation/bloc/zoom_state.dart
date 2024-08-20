import 'package:equatable/equatable.dart';

abstract class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object> get props => [];
}

class MeetingInitial extends MeetingState {}

class MeetingCreateLoadingState extends MeetingState {}

class MeetingCreateSuccessState extends MeetingState {}

class MeetingCreateFailureState extends MeetingState {}

class MeetingJoinLoadingState extends MeetingState {}

class MeetingJoinSuccessState extends MeetingState {}

class MeetingJoinFailureState extends MeetingState {}

class MeetingEndLoadingState extends MeetingState {}

class MeetingEndSuccessState extends MeetingState {}

class MeetingEndFailureState extends MeetingState {}

class MeetingSurfaceShownState extends MeetingState {
  const MeetingSurfaceShownState();
}

class MeetingSurfaceHinddenState extends MeetingState {
  const MeetingSurfaceHinddenState();
}
