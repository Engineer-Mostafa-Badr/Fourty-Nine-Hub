
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(NoCalls());

 
  void checkIfThereIsCall() async {
    await serviceLocator<SharedPreferences>().reload();
    final storedCall = serviceLocator<SharedPreferences>().getString('call_data');
    print('+++++++++ $storedCall');
    if (storedCall != null) {
      await serviceLocator<SharedPreferences>().remove('call_data');
      final data = json.decode(storedCall.toString());
      final callData = CallData.fromMap(data, false);
      startCall(callData);
    }
  }

  Future startCall(CallData callData) async {
    final engine = await _initializeEngine(callData);
    if (engine == null) return;
    emit(
      HasCall(
        engine: engine,
        callData: callData,
      ),
    );
  }

  Future<RtcEngine?> _initializeEngine(CallData callData) async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      endCall();
      return null;
    }
    final agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
      appId: UIConst.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication1v1,
    ));
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("++++++local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("++++++remote user $remoteUid joined");
        },
        onConnectionStateChanged: (connection, state, reason) {
          if (state == ConnectionStateType.connectionStateDisconnected ||
              state == ConnectionStateType.connectionStateFailed &&
                  connection.channelId == callData.channelName) {
            endCall();
          }
        },
      ),
    );

    await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await agoraEngine.enableAudio();
    // await agoraEngine.start();

    await agoraEngine.joinChannel(
      token: callData.rtcToken,
      channelId: callData.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
    // await agoraEngine.setDefaultMuteAllRemoteAudioStreams(false);
    await agoraEngine.setDefaultAudioRouteToSpeakerphone(false);

    return agoraEngine;
  }

  void endCall() async {
    if (state is HasCall) {
      serviceLocator<CallWithNotificationHelper>().sendActionNotification(
        (state as HasCall).callData,
        CallActions.callEnded,
        reason: 'user ended call after call connected',
      );
      final engine = (state as HasCall).engine;
      await engine.leaveChannel();
      await engine.release();
    }
    emit(NoCalls());
  }

  void toggleSpeaker() async {
    if (state is HasCall) {
      final engine = (state as HasCall).engine;
      final bool isEnabled = (state as HasCall).isSpeaker;
      await engine.setEnableSpeakerphone(!isEnabled);
      emit((state as HasCall).copyWith(isSpeaker: !isEnabled));
    }
  }

  void toggleMute() async {
    if (state is HasCall) {
      final engine = (state as HasCall).engine;
      final bool isMuted = (state as HasCall).isMute;
      await engine.muteLocalAudioStream(!isMuted);
      emit((state as HasCall).copyWith(isMute: !isMuted));
    }
  }

  @override
  void emit(CallState state) {
    super.emit(state);
  }
  
}
