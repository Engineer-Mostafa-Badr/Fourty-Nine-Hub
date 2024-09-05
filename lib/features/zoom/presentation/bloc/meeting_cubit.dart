import 'dart:convert';
import 'dart:math';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/end_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/get_scheuled_rooms_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/join_room_use_case.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../routes/pages.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit(
    this.addRoomUseCase,
    this.joinRoomUseCase,
    this.endRoomUseCase,
    this.getScheduledRoomsUseCase,
  ) : super(const MeetingState());
  final AddRoomUseCase addRoomUseCase;
  final JoinRoomUseCase joinRoomUseCase;
  final EndRoomUseCase endRoomUseCase;
  final GetScheduledRoomsUseCase getScheduledRoomsUseCase;

  String meetingId = '';
  String get genRandNo {
    int min = 10000000;
    int max = 99999999;
    final String liveId = '${min + Random().nextInt(max - min)}';
    return liveId;
  }

  Future<bool> createNewMeeting({
    DateTime? startTime,
    DateTime? endTime,
    String? title,
  }) async {
    meetingId = genRandNo;
    final response = await addRoomUseCase(MeetingParams(
      meetingId: meetingId,
      endsAt: endTime,
      startedAt: startTime,
      title: title,
    ));
    emit(state.copyWith(status: MeetingStates.loading));
    bool isAdd = false;
    response.fold(
        (l) => emit(state.copyWith(status: MeetingStates.failure, failure: l)),
        (r) async {
      print("object $r");
      emit(state.copyWith(status: MeetingStates.success));
      if (startTime != null) {
        await getScheduledMeetings();
        isAdd = true;
      }
    });

    // print(isAdd);
    return isAdd;
  }

  Future<bool> joinNewMeeting(String roomId) async {
    emit(state.copyWith(status: MeetingStates.loading));
    final response = await joinRoomUseCase(MeetingParams(meetingId: roomId));
    bool isAdd = false;
    response.fold((l) {
      emit(state.copyWith(status: MeetingStates.failure, failure: l));
      showErrorMessage(
        _context(),
        getFailureMessage(
          state.failure ?? UnknownFailure(''),
          _context(),
        ),
      );
    }, (r) {
      print("object $r}");
      isAdd = r;

      emit(state.copyWith(status: MeetingStates.success));
    });
    print(isAdd);
    return isAdd;
  }

  BuildContext _context() =>
      AppPages.router.configuration.navigatorKey.currentContext!;

  @override
  void onChange(Change<MeetingState> change) {
    debugPrint('change is ${change.currentState.status}');
    debugPrint('change next ${change.nextState.status}');
    super.onChange(change);
  }

  Future<void> endRoom(String roomId) async {
    emit(state.copyWith(status: MeetingStates.loading));
    await endRoomUseCase(MeetingParams(meetingId: roomId)).then((value) {
      // print('room Ended');
      emit(state.copyWith(status: MeetingStates.success));
    }).catchError((error) {
      // print('room Not Ended');
      emit(state.copyWith(status: MeetingStates.failure));
      throw '';
    });
  }

  Future<void> getScheduledMeetings() async {
    emit(state.copyWith(status: MeetingStates.loading));
    var result = await getScheduledRoomsUseCase(MeetingParams(
      meetingId: UserCubit.to.state.data!.id,
    ));
    result.fold((l) {
      emit(state.copyWith(status: MeetingStates.failure, failure: l));
    }, (r) {
      CliLogger.info('first title is  ${r.first.title}');
      emit(state.copyWith(
        status: MeetingStates.gotscheduledMeeting,
        scheduledMeetings: r,
      ));
      // emit(state.copyWith(
      //   status: MeetingStates.initial,
      //   scheduledMeetings: r,
      // ));
    });
  }

  Future<void> openWhiteBoard() async {
    emit(state.copyWith(status: MeetingStates.loading));
    if (!ZegoUIKit.instance.getScreenSharingStateNotifier().value) {
      // print('state white board before is ${state.toString()}');
      await ZegoUIKit().startSharingScreen().then((value) =>
          emit(state.copyWith(status: MeetingStates.openWhiteBoard)));
      // print('state white board after is ${state.toString()}');
    } else if (ZegoUIKit.instance.getScreenSharingStateNotifier().value &&
        !state.isOpenWhiteBoard) {
      emit(state.copyWith(status: MeetingStates.openWhiteBoard));
    } else {
      showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          'White Board is already opened!');
    }
  }

  void closeWhiteBoard() {
    emit(state.copyWith(status: MeetingStates.initial));
  }

  bool isMinimized = false;
  void toggleMinimized() {
    isMinimized = !isMinimized;
    emit(state.copyWith(status: MeetingStates.success));
  }

  void minimize() {
    isMinimized = true;
    emit(state.copyWith(status: MeetingStates.minimizing));
  }
}
