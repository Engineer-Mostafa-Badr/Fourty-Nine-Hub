import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/end_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/get_scheuled_rooms_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/join_room_use_case.dart';

import '../../../../routes/pages.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'zoom_state.dart';

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

  // @override
  // void onChange(Change<MeetingState> change) {
  //   debugPrint('change is ${change.currentState}');
  //   debugPrint('change next ${change.nextState}');
  //   super.onChange(change);
  // }

  Future<void> addRoom(String roomId,
      {DateTime? startDate, DateTime? endDate, String? title}) async {
    emit(state.copyWith(status: MeetingStates.loading));
    addRoomUseCase(MeetingParams(
      meetingId: roomId,

      /// to [Schedule] meeting
      startedAt: startDate,
      endsAt: endDate,
      title: title,
    ))
        .then((value) => emit(state.copyWith(status: MeetingStates.success)))
        .catchError(
          (error) => emit(
            state.copyWith(status: MeetingStates.failure),
          ),
        );
  }

  void joinRoom(String roomId) {
    emit(state.copyWith(status: MeetingStates.loading));
    joinRoomUseCase(MeetingParams(meetingId: roomId)).then((result) {
      if (result!.statusCode == 200) {
        emit(state.copyWith(status: MeetingStates.success));
      } else {
        final String errorMessage = result.data['error']['message'] ?? '';
        final Map<String, dynamic> localizedMessage = json.decode(errorMessage);
        print('state is ${localizedMessage['en']}');
        emit(state.copyWith(
          status: MeetingStates.failure,
          errorMessage: (localizedMessage[AppPages.router.configuration
                      .navigatorKey.currentContext!.isArabic
                  ? 'ar'
                  : 'en'] ??
              'Room not registered'),
        ));
        showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          state.errorMessage!,
        );
      }
    });
  }

  Future<void> endRoom(String roomId) async {
    emit(state.copyWith(status: MeetingStates.loading));
    await endRoomUseCase(MeetingParams(meetingId: roomId)).then((value) {
      print('room Ended');
      emit(state.copyWith(status: MeetingStates.success));
    }).catchError((error) {
      print('room Not Ended');
      emit(state.copyWith(status: MeetingStates.failure));
      throw '';
    });
  }

  List<ScheduledMeeting> scheduledMeetingList = [];
  void getScheduledMeetings() {
    emit(state.copyWith(status: MeetingStates.loading));
    getScheduledRoomsUseCase(
            MeetingParams(meetingId: UserCubit.to.state.data!.id))
        .then((value) {
      value.fold((l) => emit(state.copyWith(status: MeetingStates.failure)),
          (r) {
        scheduledMeetingList = r;
        getScheduledMeetings();
        emit(state.copyWith(status: MeetingStates.success));
      });
    }).catchError((error) {
      emit(state.copyWith(status: MeetingStates.failure));
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
