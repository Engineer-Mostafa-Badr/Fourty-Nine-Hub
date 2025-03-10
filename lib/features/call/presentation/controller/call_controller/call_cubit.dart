import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(NoCalls());

  void checkIfThereIsCall() async {
    await serviceLocator<SharedPreferences>().reload();
    final storedCall =
        serviceLocator<SharedPreferences>().getString('call_data');
    print('+++++++++ stored call $storedCall');
    if (storedCall != null) {
      print('+++++++++ stored call if not equal null $storedCall');
      await serviceLocator<SharedPreferences>().remove('call_data');
      final data = json.decode(storedCall.toString());
      final callData = CallData.fromMap(data, false);

      startCall(callData, true);
    }
  }

  Future startCall(CallData callData, bool isFromCheckComingCall) async {
    if (callData.isRealCall == true.toString()) {
      print("Starting call");
      // Request permissions first
      final micStatus = await Permission.microphone.request();
      if (micStatus == PermissionStatus.denied ||
          micStatus == PermissionStatus.permanentlyDenied) {
        print("Calling ended because of mic permission");
        endCall();
        return;
      }

      if (callData.callType == CallType.video.name) {
        final camStatus = await Permission.camera.request();
        if (camStatus == PermissionStatus.denied ||
            camStatus == PermissionStatus.permanentlyDenied) {
          print("Calling ended because of camera permission");
          endCall();
          return;
        }
      }

      if (callData.serviceType == "agora") {
        print("Engine initialized");
        final engine = await _initializeEngine(callData);
        print('Engine initialized $engine');
        if (engine == null) return;
        emit(HasCall(
          engine: engine,
          callData: callData,
          isMute: false,
          isSpeaker: false,
          isVideoEnabled: callData.callType == CallType.video.name,
        ));
      } else if (callData.serviceType == "zegocloud") {
        await _initializeZegoCloud(callData);
        emit(HasCall(
          engine: null,
          callData: callData,
          isZegoCloud: true,
          isMute: false,
          isSpeaker: false,
          isVideoEnabled: callData.callType == CallType.video.name,
        ));
      }
    } else {
      print("VoiceCallingScreen call state4 $state");
      if (isFromCheckComingCall) {
        emit(HasCall(
          engine: null,
          callData: callData,
          isMute: false,
          isSpeaker: false,
          isVideoEnabled: callData.callType == CallType.video.name,
        ));
      }
    }
  }

  Future<RtcEngine?> _initializeEngine(CallData callData) async {
    print("Call data is $callData");
    final agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(
      appId: "223d82348c04428fb78029d931bbbbe7",

      //  UIConst.agoraAppId,
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
        onError: (err, msg) {
          print("Agora Error: Code: $err, Message: $msg");
        },
        onConnectionStateChanged: (connection, state, reason) {
          if (state == ConnectionStateType.connectionStateDisconnected ||
              state == ConnectionStateType.connectionStateFailed &&
                  connection.channelId == callData.channelId) {
            print(
                "Calling ended because of connection state change state is $state and channel is ${connection.channelId} and callData is ${callData.channelId}");
            endCall();
          }
        },
      ),
    );

    await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await agoraEngine.enableAudio();

    if (callData.callType == CallType.video.name) {
      await agoraEngine.enableVideo();
    }

    print(
        "Joining channel with token: ${callData.rtcToken.substring(0, 10)}...");
    print("Channel ID: ${callData.channel}");

    print(
        'callData.rtcToken ${callData.rtcToken}  callData.channelId ${callData.channelId}  callData.channelName ${callData.channel}');
    await agoraEngine.joinChannel(
      token:
          // "007eJxTYHAVuXMi7NEWiT9v0+P4rL+GRWlv/stWyn2PW8qh+41/1zUFBiMj4xQLI2MTi2QDExMji7QkcwsDI8sUS2PDJCBINf99c2t6QyAjwz8lVQZGKATxVRgsEk1TDc2TU3RTDMyTdU2SjJJ1LYyTEnUtU00tEw1S0lIszEwYGADHbSgT",
          callData.rtcToken,
      channelId:
          // "8a5e17cd-d07c-4b2c-83ba-9e59a0dfd864",
          callData.channel,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication1v1,
      ),
    );
    print("Agora engine initialized and joined");
    // await agoraEngine.setDefaultAudioRouteToSpeakerphone(
    //     callData.callType == CallType.video.name);
    await agoraEngine.setDefaultAudioRouteToSpeakerphone(false);

    return agoraEngine;
  }

  Future<void> _initializeZegoCloud(CallData callData) async {
    // Initialize ZegoCloud service
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: int.parse(callData.zegoAppId),
      appSign: callData.zegoAppSign,
      userID: callData.isCaller ? callData.uid : callData.receiverId,
      userName: callData.isCaller ? callData.callerName : callData.receiverName,
      plugins: [ZegoUIKitSignalingPlugin()],
      /*
      {required List<IZegoUIKitPlugin> plugins}
Type: List<IZegoUIKitPlugin>

you must call this method as soon as the user login(or re-login, auto-login) to your app.

You must include [ZegoUIKitSignalingPlugin] in [plugins] to support the invitation feature.

If you need to set [ZegoUIKitPrebuiltCallConfig], you can do so through [requireConfig]. Each time the [ZegoUIKitPrebuiltCall] starts, it will request this callback to obtain the current call's config.

Additionally, you can customize the call ringtone through [ringtoneConfig], and configure notifications through [notificationConfig]. You can also customize the invitation interface with [uiConfig]. 
If you want to modify the related text on the interface, you can set [innerText]. If you want to listen for events and perform custom logics, you can use [invitationEvents] to obtain related invitation events, and for call-related events, you need to use [events].
       */
      // notifyWhenAppRunningInBackgroundOrQuit: true,
      // androidPushConfig: ZegoNotificationConfig(
      //   channelID: "call_notification",
      //   channelName: "Call Notifications",
      //   sound: "notification_sound",
      // ),
      // iOSNotificationConfig: ZegoNotificationConfig(
      //   channelID: "call_notification",
      //   channelName: "Call Notifications",
      //   sound: "notification_sound",
      // ),
    );

    // // Set up call configuration
    // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

    // // Set up invitation events listener
    // ZegoUIKitPrebuiltCallInvitationService().events.onIncomingCallReceived.listen((event) {
    //   // Handle incoming call event
    //   print("Incoming call from: ${event.caller.name}");
    // });

    // ZegoUIKitPrebuiltCallInvitationService().events.onOutgoingCallAccepted.listen((event) {
    //   // Handle call accepted event
    //   print("Call accepted by: ${event.callee.name}");
    // });

    // ZegoUIKitPrebuiltCallInvitationService()  .events.onCallEnd.listen((event) {
    //   // Handle call end event
    //   endCall();
    // });
  }

  void endCall() async {
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      print('End Call');
      serviceLocator<CallWithNotificationHelper>().sendActionNotification(
        hasCallState.callData,
        CallActions.callEnded,
        reason: 'user ended call after call connected',
      );
      if (hasCallState.callData.isRealCall == true.toString()) {
        if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
          // Clean up Agora engine
          final engine = hasCallState.engine!;
          await engine.leaveChannel();
          await engine.release();
        } else if (hasCallState.isZegoCloud) {
          // Clean up ZegoCloud
          await ZegoUIKitPrebuiltCallInvitationService().uninit();
        }
      }
    }
    emit(NoCalls());
  }

  void toggleSpeaker() async {
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
        final engine = hasCallState.engine!;
        final bool isEnabled = hasCallState.isSpeaker;
        await engine.setEnableSpeakerphone(!isEnabled);
        emit(hasCallState.copyWith(isSpeaker: !isEnabled));
      }
      // For ZegoCloud, speaker control is handled by the UI Kit
    }
  }

  void toggleMute() async {
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
        final engine = hasCallState.engine!;
        final bool isMuted = hasCallState.isMute;
        await engine.muteLocalAudioStream(!isMuted);
        emit(hasCallState.copyWith(isMute: !isMuted));
      }
      // For ZegoCloud, mute control is handled by the UI Kit
    }
  }

  void toggleCamera() async {
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
        final engine = hasCallState.engine!;
        final bool isVideoEnabled = hasCallState.isVideoEnabled;
        await engine.enableLocalVideo(!isVideoEnabled);
        emit(hasCallState.copyWith(isVideoEnabled: !isVideoEnabled));
      }
      // For ZegoCloud, camera control is handled by the UI Kit
    }
  }

  //build toggle video when receiver open video the sender can show receiver's video and otherwise and when two open video call show others
  void toggleVideo() async {
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
        final engine = hasCallState.engine!;
        final bool isVideoEnabled = hasCallState.isVideoEnabled;

        // Enable/disable video module
        await engine.enableVideo();

        // Enable/disable local video capture and rendering
        await engine.enableLocalVideo(!isVideoEnabled);
        // Start/stop video preview
        if (!isVideoEnabled) {
          await engine.startPreview();
        } else {
          await engine.stopPreview();
        }

        emit(hasCallState.copyWith(isVideoEnabled: !isVideoEnabled));
      }
    }
    // control zigo cloud my me
    //   else if (hasCallState.isZegoCloud) {
    //     //zego cloud toggle video control by my ui
    //     ZegoUIKitPrebuiltCallInvitationService()
    //         .controller
    //         .audioVideo
    //         .camera
    //         .switchState();
    //     final bool isVideoEnabled = hasCallState.isVideoEnabled;
    //     emit(hasCallState.copyWith(isVideoEnabled: !isVideoEnabled));
    //   }
    // }
  }
}
