import 'dart:math';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/send_points_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/controller/tiktok_controller_extension.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/end_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/get_scheuled_rooms_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/join_room_use_case.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../routes/pages.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_media/live_streaming/domain/entity/live_entity.dart';
import '../../../social_media/live_streaming/domain/entity/topic_entity.dart';
import '../../../social_media/live_streaming/domain/usecases/create_live_use_case.dart';
import '../../../social_media/live_streaming/domain/usecases/end_live_use_case.dart';
import '../../../social_media/live_streaming/domain/usecases/get_all_lives_use_case.dart';
import '../../../social_media/live_streaming/domain/usecases/get_all_topics_use_case.dart';
import '../../../social_media/live_streaming/domain/usecases/listen_batttle_request_use_case.dart';
import '../../../social_media/live_streaming/domain/usecases/listen_to_send_points_use_case.dart';
import '../../../social_media/live_streaming/domain/usecases/request_battle_use_case.dart';
import 'stream_state.dart';

final class StreamCubit extends Cubit<StreamState> {
  StreamCubit(
    this.addRoomUseCase,
    this.joinRoomUseCase,
    this.endRoomUseCase,
    this.getScheduledRoomsUseCase,
    this.getAllTopicsUseCase,
    this.createLiveUseCase,
    this.getAllLivesUseCase,
    this.endLiveUseCase,
    this.sendPointsUseCase,
    this.listenToSendPointsUseCase,
    this.listenBattleRequestUseCase,
    this.requestBattleUseCase,
  ) : super(const StreamState()) {
    initSocketListeners();
  }
  final AddRoomUseCase addRoomUseCase;
  final JoinRoomUseCase joinRoomUseCase;
  final EndRoomUseCase endRoomUseCase;
  final GetScheduledRoomsUseCase getScheduledRoomsUseCase;

  //for live_streaming
  final GetAllTopicsUseCase getAllTopicsUseCase;
  final CreateLiveUseCase createLiveUseCase;
  final GetAllLivesUseCase getAllLivesUseCase;
  final EndLiveUseCase endLiveUseCase;
  final SendPointsUseCase sendPointsUseCase;
  final ListenToSendPointsUseCase listenToSendPointsUseCase;
  final ListenBattleRequestUseCase listenBattleRequestUseCase;
  final RequestBattleUseCase requestBattleUseCase;
  String meetingId = '';
  List<TopicEntity> topics = [];
  String liveId = '';

  String get genRandNo {
    int min = 10000000;
    int max = 99999999;
    final String liveId = '${min + Random().nextInt(max - min)}';
    return liveId;
  }

//callable class
  Future<bool> createNewMeeting({
    DateTime? startTime,
    DateTime? endTime,
    String? title,
  }) async {
    meetingId = genRandNo;
    final response = await addRoomUseCase(MeetingParams(
      id: meetingId,
      endsAt: endTime,
      startedAt: startTime,
      title: title,
    ));
    emit(state.copyWith(status: StreamsStates.loading));
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(status: StreamsStates.failure, failure: l)),
        (r) async {
      print("object $r");
      emit(state.copyWith(status: StreamsStates.success));
      if (startTime != null) {
        await getScheduledMeetings();
        isAdd = true;
      }
    });

    // print(isAdd);
    return isAdd;
  }

  bool isHost = false;
  void reInititiateState() {
    emit(state.copyWith(status: StreamsStates.initial));
  }

  Future<bool> joinNewMeeting(String roomId) async {
    emit(state.copyWith(status: StreamsStates.loading));
    final response = await joinRoomUseCase(MeetingParams(id: roomId));
    response.fold((l) {
      emit(state.copyWith(status: StreamsStates.failure, failure: l));
      showErrorMessage(
        _context(),
        getFailureMessage(
          state.failure ?? UnknownFailure(''),
          _context(),
        ),
      );
    }, (r) {
      print("object $r}");
      isHost = r;

      emit(state.copyWith(status: StreamsStates.success));
    });
    print(isHost);
    return isHost;
  }

  BuildContext _context() =>
      AppPages.router.configuration.navigatorKey.currentContext!;

  @override
  void onChange(Change<StreamState> change) {
    debugPrint('change is ${change.currentState.status}');
    debugPrint('change next ${change.nextState.status}');
    super.onChange(change);
  }

  Future<void> endRoom(String roomId) async {
    emit(state.copyWith(status: StreamsStates.loading));
    await endRoomUseCase(MeetingParams(id: roomId)).then((value) {
      // print('room Ended');
      emit(state.copyWith(status: StreamsStates.success));
    }).catchError((error) {
      // print('room Not Ended');
      emit(state.copyWith(status: StreamsStates.failure));
      throw '';
    });
  }

  Future<void> getScheduledMeetings() async {
    emit(state.copyWith(status: StreamsStates.loading));
    var result = await getScheduledRoomsUseCase(MeetingParams(
      id: UserCubit.to.state.data!.id,
    ));
    result.fold((l) {
      emit(state.copyWith(status: StreamsStates.failure, failure: l));
    }, (r) {
      CliLogger.info('first title is  ${r.first.title}');
      emit(state.copyWith(
        status: StreamsStates.success,
        scheduledMeetings: r,
      ));
      // emit(state.copyWith(
      //   status: MeetingStates.initial,
      //   scheduledMeetings: r,
      // ));
    });
  }

  Future<void> openWhiteBoard() async {
    emit(state.copyWith(status: StreamsStates.loading));
    if (!ZegoUIKit.instance.getScreenSharingStateNotifier().value) {
      // print('state white board before is ${state.toString()}');
      await ZegoUIKit().startSharingScreen().then((value) =>
          emit(state.copyWith(status: StreamsStates.openWhiteBoard)));
      // print('state white board after is ${state.toString()}');
    } else if (ZegoUIKit.instance.getScreenSharingStateNotifier().value &&
        !state.isOpenWhiteBoard) {
      emit(state.copyWith(status: StreamsStates.openWhiteBoard));
    } else {
      showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          'White Board is already opened!');
    }
  }

  void closeWhiteBoard() {
    emit(state.copyWith(status: StreamsStates.initial));
  }

  bool isMinimized = false;

  void toggleMinimized() {
    isMinimized = !isMinimized;
    emit(state.copyWith(status: StreamsStates.success));
  }

  //get all lives by pagination
  final PagingController<int, LiveEntity> roomsPagingController =
      PagingController(firstPageKey: 1);
  int pageSize = 10;
  int roomsLength = 0;
  List<LiveEntity> rooms = [];
}
