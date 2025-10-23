// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/features/social_media/live_streaming/domain/entity/goal_entity.dart';
// import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
//
// import '../../../social_media/live_streaming/domain/entity/live_create_response_entity.dart';
// import '../../../social_media/live_streaming/domain/entity/live_entity.dart';
// import '../../../social_media/tinder/data/models/gift_model.dart';
//
// enum StreamsStates {
//   initial,
//   loading,
//   success,
//   gotscheduledMeeting,
//   failure,
//   openWhiteBoard,
//   changeTopic
// }
//
// extension MeetingStateX on StreamState {
//   bool get isInitial => status == StreamsStates.initial;
//
//   bool get isLoading => status == StreamsStates.loading;
//
//   bool get isSuccess => status == StreamsStates.success;
//
//   bool get isFailure => status == StreamsStates.failure;
//
//   bool get isOpenWhiteBoard => status == StreamsStates.openWhiteBoard;
//
//   bool get isChangeTopic => status == StreamsStates.changeTopic;
//
//   bool get isGotScheduledMeeting => status == StreamsStates.gotscheduledMeeting;
// }
//
// class StreamState extends Equatable {
//   final StreamsStates? status;
//   final List<ScheduledMeeting>? scheduledMeeting;
//   final List<LiveEntity> allLives;
//   final LiveEntity? live;
//   final List<GiftData> selectedGifts;
//   final String? errorMessage;
//   final bool? hideComments;
//   final int? count;
//   final int? pageIndex;
//   final String topic;
//   final String topicId;
//   final String? goalDescription;
//   final Failure? failure;
//   final List<GoalEntity> goals;
//   final LiveCreateResponseEntity? liveCreateResponseEntity;
//   const StreamState({
//     this.status = StreamsStates.initial,
//     this.errorMessage,
//     this.failure,
//     this.count = 0,
//     this.pageIndex = 0,
//     this.hideComments = false,
//     this.topic = '',
//     this.topicId = '',
//     this.scheduledMeeting,
//     this.live,
//     this.goals = const [],
//     this.liveCreateResponseEntity,
//     this.selectedGifts = const [],
//     this.allLives = const [],
//     this.goalDescription = '',
//   });
//
//   StreamState copyWith({
//     StreamsStates? status,
//     String? errorMessage,
//     String? topic,
//     String? topicId,
//     List<GoalEntity>? goals,
//     List<ScheduledMeeting>? scheduledMeetings,
//     String? goalDescription,
//     int? count,
//     int? pageIndex,
//     bool? hideComments,
//     Failure? failure,
//     LiveEntity? live,
//     LiveCreateResponseEntity? liveCreateResponseEntity,
//     List<LiveEntity>? lives,
//     List<GiftData>? selectedGifts,
//   }) =>
//       StreamState(
//         status: status,
//         errorMessage: errorMessage ?? this.errorMessage,
//         goals: goals ?? this.goals,
//         hideComments: hideComments ?? this.hideComments,
//         failure: failure ?? this.failure,
//         topic: topic ?? this.topic,
//         count: count ?? this.count,
//         topicId: topicId ?? this.topicId,
//         pageIndex: pageIndex ?? this.pageIndex,
//         scheduledMeeting: scheduledMeetings ?? scheduledMeeting,
//         allLives: lives ?? allLives,
//         live: live ?? this.live,
//         liveCreateResponseEntity:
//             liveCreateResponseEntity ?? liveCreateResponseEntity,
//         selectedGifts: selectedGifts ?? this.selectedGifts,
//         goalDescription: goalDescription ?? this.goalDescription,
//       );
//
//   @override
//   List<Object?> get props => [
//         status,
//         errorMessage,
//         hideComments,
//         count,
//         liveCreateResponseEntity,
//         failure,
//         topic,
//         goalDescription,
//         live,
//         scheduledMeeting,
//         topicId,
//         allLives,
//         selectedGifts,
//       ];
// }
