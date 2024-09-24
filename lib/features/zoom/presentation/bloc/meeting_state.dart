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
  changeTopic
}

extension MeetingStateX on StreamState {
  bool get isInitial => status == StreamsStates.initial;
  bool get isLoading => status == StreamsStates.loading;
  bool get isSuccess => status == StreamsStates.success;
  bool get isFailure => status == StreamsStates.failure;
  bool get isOpenWhiteBoard => status == StreamsStates.openWhiteBoard;
  bool get isChangeTopic => status == StreamsStates.changeTopic;
  bool get isGotScheduledMeeting => status == StreamsStates.gotscheduledMeeting;
}

class StreamState extends Equatable {
  final StreamsStates? status;
  final List<ScheduledMeeting>? scheduledMeeting;
  final String? errorMessage;
  final String topic;
  final Failure? failure;
  const StreamState({
    this.status = StreamsStates.initial,
    this.errorMessage,
    this.failure,
    this.topic = '',
    this.scheduledMeeting,
  });

  StreamState copyWith({
    StreamsStates? status,
    String? errorMessage,
    String? topic,
    Failure? failure,
    List<ScheduledMeeting>? scheduledMeetings,
  }) =>
      StreamState(
        status: status,
        errorMessage: errorMessage ?? this.errorMessage,
        failure: failure ?? this.failure,
        topic: topic ?? this.topic,
        scheduledMeeting: scheduledMeetings ?? scheduledMeeting,
      );

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        failure,
        topic,
        scheduledMeeting,
      ];
}
