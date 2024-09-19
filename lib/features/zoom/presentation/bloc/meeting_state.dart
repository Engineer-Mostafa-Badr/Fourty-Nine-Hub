// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';

enum StreamsStates {
  initial,
  loading,
  success,
  gotscheduledMeeting,
  failure,
  openWhiteBoard,
  minimizing
}

extension MeetingStateX on StreamState {
  bool get isInitial => status == StreamsStates.initial;
  bool get isLoading => status == StreamsStates.loading;
  bool get isSuccess => status == StreamsStates.success;
  bool get isFailure => status == StreamsStates.failure;
  bool get isOpenWhiteBoard => status == StreamsStates.openWhiteBoard;
  bool get isMinimizing => status == StreamsStates.minimizing;
  bool get isGotScheduledMeeting => status == StreamsStates.gotscheduledMeeting;
}

class StreamState extends Equatable {
  final StreamsStates? status;
  final List<ScheduledMeeting>? scheduledMeeting;
  final String? errorMessage;
  final Failure? failure;
  const StreamState({
    this.status = StreamsStates.initial,
    this.errorMessage,
    this.failure,
    this.scheduledMeeting,
  });

  StreamState copyWith({
    StreamsStates? status,
    String? errorMessage,
    Failure? failure,
    List<ScheduledMeeting>? scheduledMeetings,
  }) =>
      StreamState(
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
