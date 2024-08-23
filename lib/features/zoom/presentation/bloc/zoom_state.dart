// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum MeetingStates {initial, loading, success, failure, openWhiteBoard }
extension MeetingStateX on MeetingState{
  bool get isInitial => status == MeetingStates.initial;
  //complete other states 

  bool get isLoading => status == MeetingStates.loading;
  bool get isSuccess => status == MeetingStates.success;
  bool get isFailure => status == MeetingStates.failure;
  bool get isOpenWhiteBoard => status == MeetingStates.openWhiteBoard;

}

class MeetingState extends Equatable {
  final MeetingStates? status;
  const MeetingState({
    this.status = MeetingStates.initial,
  });
  // final Failure failure;

  MeetingState copyWith({
    MeetingStates? status,
  }) =>
      MeetingState(status: status);

  @override
  List<Object?> get props => [status];
}

// class MeetingInitial extends MeetingState {}

// class MeetingCreateLoadingState extends MeetingState {}

// class MeetingCreateSuccessState extends MeetingState {}

// class MeetingCreateFailureState extends MeetingState {}

// class MeetingJoinLoadingState extends MeetingState {}

// class MeetingJoinSuccessState extends MeetingState {}

// class MeetingJoinFailureState extends MeetingState {}

// class MeetingEndLoadingState extends MeetingState {}

// class MeetingEndSuccessState extends MeetingState {}

// class MeetingEndFailureState extends MeetingState {}

// class MeetingSurfaceShownState extends MeetingState {}

// class MeetingSurfaceHiddenState extends MeetingState {}

// class OpenWhiteBoardState extends MeetingState {}
// // class CloseWhiteBoardState extends MeetingState {}
