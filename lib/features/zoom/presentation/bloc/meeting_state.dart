// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';

enum MeetingStates {
  initial,
  loading,
  success,
  gotscheduledMeeting,
  failure,
  openWhiteBoard,
  minimizing
}

extension MeetingStateX on MeetingState {
  bool get isInitial => status == MeetingStates.initial;
  bool get isLoading => status == MeetingStates.loading;
  bool get isSuccess => status == MeetingStates.success;
  bool get isFailure => status == MeetingStates.failure;
  bool get isOpenWhiteBoard => status == MeetingStates.openWhiteBoard;
  bool get isMinimizing => status == MeetingStates.minimizing;
  bool get isGotScheduledMeeting => status == MeetingStates.gotscheduledMeeting;
}

class MeetingState extends Equatable {
  final MeetingStates? status;
  final List<ScheduledMeeting>? scheduledMeeting;
  final String? errorMessage;
  final Failure? failure;
  const MeetingState({
    this.status = MeetingStates.initial,
    this.errorMessage,
    this.failure,
    this.scheduledMeeting,
  });

  MeetingState copyWith({
    MeetingStates? status,
    String? errorMessage,
    Failure? failure,
    List<ScheduledMeeting>? scheduledMeetings,
  }) =>
      MeetingState(
        status: status,
        errorMessage: errorMessage ?? this.errorMessage,
        failure: failure ?? this.failure,
        scheduledMeeting: scheduledMeetings ?? scheduledMeeting,
      );

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        failure,
        scheduledMeeting,
      ];
}
