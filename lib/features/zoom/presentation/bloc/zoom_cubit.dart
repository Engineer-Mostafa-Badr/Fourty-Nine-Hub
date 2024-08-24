import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/room_response.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/end_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/join_room_use_case.dart';

import '../../../../routes/pages.dart';
import 'zoom_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit(this.addRoomUseCase, this.joinRoomUseCase, this.endRoomUseCase)
      : super(const MeetingState());
  final AddRoomUseCase addRoomUseCase;
  final JoinRoomUseCase joinRoomUseCase;
  final EndRoomUseCase endRoomUseCase;

  @override
  void onChange(Change<MeetingState> change) {
    debugPrint('change is ${change.currentState}');
    debugPrint('change next ${change.nextState}');
    super.onChange(change);
  }

  void addRoom(String roomId) {
    emit(state.copyWith(status: MeetingStates.loading));
    addRoomUseCase(MeetingParams(id: roomId))
        .then((value) => emit(state.copyWith(status: MeetingStates.success)))
        .catchError(
          (error) => emit(
            state.copyWith(status: MeetingStates.failure),
          ),
        );
  }

  void joinRoom(String roomId) {
    emit(state.copyWith(status: MeetingStates.loading));
    joinRoomUseCase(MeetingParams(id: roomId)).then((result) {
      emit(state.copyWith(status: MeetingStates.success));
    }).catchError((error) {
      emit(state.copyWith(status: MeetingStates.failure));
      showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          error.toString());
    });
  }

  void endRoom(String roomId) {
    emit(state.copyWith(status: MeetingStates.loading));
    endRoomUseCase(MeetingParams(id: roomId)).then((value) {
      print('room Ended');
      emit(state.copyWith(status: MeetingStates.success));
    }).catchError((error) {
      print('room Not Ended');
      emit(state.copyWith(status: MeetingStates.failure));
    });
  }

  // bool surfaceShown = true;

  // void toggleSurfaceShown() {
  //   surfaceShown = !surfaceShown;
  //   if (surfaceShown) {
  //     emit(MeetingSurfaceShownState());
  //   } else {
  //     emit(MeetingSurfaceHiddenState());
  //   }
  // }

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
