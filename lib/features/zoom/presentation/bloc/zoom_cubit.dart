import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/end_room_use_case.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/join_room_use_case.dart';

import '../../../../routes/pages.dart';
import 'zoom_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit(this.addRoomUseCase, this.joinRoomUseCase, this.endRoomUseCase)
      : super(MeetingInitial());
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
    // emit(MeetingCreateLoadingState());
    addRoomUseCase(MeetingParams(id: roomId))
        .then((value) => emit(MeetingCreateSuccessState()))
        .catchError((error) => emit(MeetingCreateFailureState()));
  }

  void joinRoom(String roomId) {
    emit(MeetingJoinLoadingState());
    joinRoomUseCase(MeetingParams(id: roomId))
        .then((value) => emit(MeetingJoinSuccessState()))
        .catchError((error) => emit(MeetingJoinFailureState()));
  }

  void endRoom(String roomId) {
    emit(MeetingEndLoadingState());
    endRoomUseCase(MeetingParams(id: roomId)).then((value) {
      print('room Ended');
      emit(MeetingEndSuccessState());
    }).catchError((error) {
      print('room Not Ended');
      emit(MeetingEndFailureState());
    });
  }

  bool surfaceShown = true;

  void toggleSurfaceShown() {
    surfaceShown = !surfaceShown;
    if (surfaceShown) {
      emit(MeetingSurfaceShownState());
    } else {
      emit( MeetingSurfaceHiddenState());
    }
  }

  Future<void> openWhiteBoard() async {
    if (!ZegoUIKit.instance.getScreenSharingStateNotifier().value) {
      await ZegoUIKit().startSharingScreen();
      emit(OpenWhiteBoardState());
    } else {
      showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          'White Board is already opened!');
    }
  }
}
