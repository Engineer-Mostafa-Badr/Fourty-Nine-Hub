import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/features/call/services/call_timer_service.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(NoCalls());

  int? remoteViewID;
  int? localViewID;
  String? _remoteStreamID;

  void checkIfThereIsCall() async {
    await serviceLocator<SharedPreferences>().reload();
    final storedCall =
        serviceLocator<SharedPreferences>().getString('call_data');
    print('+++++++++ stored call $storedCall');
    if (storedCall != null) {
      print('+++++++++ stored call if not equal null $storedCall');

      final data = json.decode(storedCall.toString());
      final callData = CallData.fromMap(data, false);
      serviceLocator<CallWithNotificationHelper>()
          .connectToCall(callData, false, isFromCheckIfThereIsACall: true);
      startCall(callData, true);
    }
  }

  Future startCall(CallData callData, bool isFromCheckComingCall) async {
    CallTimerService().resetTimer();
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
        print(
            "Start call with zegocloud with is video  ${callData.callType == CallType.video.name} room id ${callData.zegoRoomId} and receiver name is ${callData.receiverName} and call type is video of ${callData.callType} ${callData.callType == CallType.video.name}");

        emit(HasCall(
          engine: null,
          callData: callData,
          isZegoCloud: true,
          isMute: false,
          isSpeaker: false,
          isVideoEnabled: callData.callType == CallType.video.name,
          isRemoteVideoEnabled: callData.callType == CallType.video.name,
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

    // Configure audio session for background mode
    await agoraEngine.enableAudioVolumeIndication(
        interval: 200, smooth: 3, reportVad: true);
    await agoraEngine.setParameters('{"che.audio.keep.audiosession": true}');
    await agoraEngine.enableWebSdkInteroperability(true);
    // await agoraEngine.setParameters('{"che.audio.enable.aec": false}');
    // await agoraEngine.setParameters('{"che.audio.enable.agc": false}');
    // await agoraEngine.setParameters('{"che.audio.enable.ns": false}');

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

    // Set audio scenario to ensure audio continues in background
    await agoraEngine.setAudioScenario(AudioScenarioType.audioScenarioChatroom);
    await agoraEngine
        .setEnableSpeakerphone(false); // Start with earpiece by default

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

  void endCall() async {
     CallTimerService().resetTimer();
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      print('End Call');
      await serviceLocator<SharedPreferences>().remove('call_data');
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
          // First stop streaming and preview
          if (_remoteStreamID != null) {
            await stopZegoPlayStream(_remoteStreamID!);
          }

          await stopZegoPreview();
          await stopZegoPublish();

          // Stop listening to events
          stopZegoListenEvent();

          // Finally logout from room
          await logoutZegoRoom(roomId: hasCallState.callData.zegoRoomId);
        }
      }
    }
    print("call ended after calling endCall");
    emit(NoCalls());
  }

  void startZegoListenEvent() {
    final hasCallState = state as HasCall;

    // Configure ZegoCloud for background audio with much stronger settings
    ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
    ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);

    // Set capture volume to a moderate level for better stability
    ZegoExpressEngine.instance.setCaptureVolume(80);

    // Pre-configure critical background audio settings
    ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
      advancedConfig: {
        "audio.capture.force_using_media_recorder": "true",
        "audio.captureAndRender.androidLowLatencyEnabled": "true",
        "background.mode.enabled": "true",
        "audio.process.continue.in.background": "true",
        "audio.audioRecord.bluetooth_disable_aec": "true",
        "audio.audioRecord.disable_aes": "true",
        "audio.process.keep.frequently.acquired": "true",
        "audio.capture.prevent.system.suspend": "true",
        "audio.captureAndRender.continuousInBackgroundMode": "true",
        "audio.audioRecord.low.latency": "true",
        "audio.capture.skip.monitor": "false",
        "audio.capture.pretend.frontapp": "true",
        "audio.voice.communication.mode": "true",
        "audio.audioRecord.frequency.min":
            "8000", // Support lower sampling rate
        "audio.audioRecord.special.process": "true",
        "android.audio.session.alwaysOn": "true",
        "audio.keep.audiosession.active": "true",
        "audio.audioRecord.restart.on.error": "true"
      },
    ));

    // Callback for updates on the status of other users in the room.
    ZegoExpressEngine.onRoomUserUpdate =
        (roomID, updateType, List<ZegoUser> userList) {
      debugPrint(
          'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
    };

    // Listen for remote user's microphone state changes
    ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
      debugPrint(
          'onRemoteMicStateUpdate streamID: $streamID, state: ${state.name}');

      // Always ensure audio processing continues
      ZegoExpressEngine.instance.enableAudioCaptureDevice(true);

      // When in background, some devices might disable the mic - force re-enable it
      if (state == ZegoRemoteDeviceState.InBackground) {
        debugPrint(
            'Remote user went to background - ensuring microphone stays active');
        // Force re-enable our microphone if not muted by user
        final currentState = this.state as HasCall;
        if (!currentState.isMute) {
          ZegoExpressEngine.instance.muteMicrophone(false);
        }
      }
    };

    // Callback for updates on the status of the streams in the room.
    ZegoExpressEngine.onRoomStreamUpdate =
        (roomID, updateType, List<ZegoStream> streamList, extendedData) {
      debugPrint(
          'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');

      final hasCallState = state as HasCall;
      if (updateType == ZegoUpdateType.Add) {
        for (final stream in streamList) {
          _remoteStreamID = stream.streamID;
          startZegoPlayStream(stream.streamID);
          // Initialize remote video as enabled when stream is added and call type is video
          final isVideo = hasCallState.callData.callType == CallType.video.name;
          emit(hasCallState.copyWith(isRemoteVideoEnabled: isVideo));
        }
      } else {
        for (final stream in streamList) {
          if (stream.streamID == _remoteStreamID) {
            _remoteStreamID = null;
            stopZegoPlayStream(stream.streamID);
            emit(hasCallState.copyWith(
                isRemoteVideoEnabled: false, remoteView: const SizedBox()));
          }
        }
      }
    };

    // Listen for remote user's camera state changes
    ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) {
      if (streamID == _remoteStreamID) {
        final hasCallState = this.state as HasCall;
        final bool isRemoteVideoEnabled = state == ZegoRemoteDeviceState.Open;
        if (isRemoteVideoEnabled) {
          startZegoPlayStream(streamID);
        } else {
          // If remote camera is turned off, update UI but don't stop the stream
          emit(hasCallState.copyWith(
            isRemoteVideoEnabled: false,
          ));
        }
      }
    };

    // Callback for updates on the current user's room connection status.
    ZegoExpressEngine.onRoomStateUpdate =
        (roomID, state, errorCode, extendedData) {
      debugPrint(
          'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };

    // Callback for updates on the current user's stream publishing changes.
    ZegoExpressEngine.onPublisherStateUpdate =
        (streamID, state, errorCode, extendedData) {
      print("local video is opened here");
      if (hasCallState.isVideoEnabled) {
        emit(hasCallState.copyWith(
            isVideoEnabled: state == ZegoPublisherState.Publishing));
      }

      debugPrint(
          'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
    };
  }

  // Add a much more aggressive method to handle when app goes to background
  Future<void> handleAppBackground() async {
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      if (hasCallState.isZegoCloud) {
        print(
            'Handling app going to background - ensuring microphone stays active');

        // Force enable audio capture device
        ZegoExpressEngine.instance.enableAudioCaptureDevice(true);

        // Use a more moderate volume that won't distort but is clearly audible
        ZegoExpressEngine.instance.setCaptureVolume(80);

        // Ensure microphone is unmuted (unless user specifically muted it)
        if (!hasCallState.isMute) {
          ZegoExpressEngine.instance.muteMicrophone(false);
        }

        // Complete restart of the audio subsystem to reset any potential issues
        ZegoExpressEngine.instance.enableAudioCaptureDevice(false);
        await Future.delayed(const Duration(milliseconds: 100));
        ZegoExpressEngine.instance.enableAudioCaptureDevice(true);

        // Specific configuration for voice calls in background
        ZegoExpressEngine.instance.setAudioConfig(ZegoAudioConfig(
          16000, // Lower bitrate for stability in background
          ZegoAudioChannel.Mono,
          ZegoAudioCodecID.Default,
        ));

        // More comprehensive engine config specifically designed for background operation
        ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
          advancedConfig: {
            "audio.captureAndRender.continuousInBackgroundMode": "true",
            "audio.record.keep.awake": "true",
            "audio.keep.background.connection": "true",
            "audio.capture.force_using_media_recorder": "true",
            "audio.capture.nodata.protection":
                "false", // Disable no-data protection which might cut audio
            "audio.audioRecord.mode.lowLatency": "true",
            "audio.audioRecord.background.mild.processor": "true",
            "audio.audioRecord.keep.audiosession.active": "true",
            "audio.enableIOSHeadphoneMonitor": "true",
            "audio.handle.systemAVAudioSession":
                "true", // Let the SDK handle audio session
            "audio.mediaPlay.use.error.callback.protection": "true",
            "audio.player.enableRecoveryFromError": "true",
            "android.audio.session.alwaysOn":
                "true", // Critical for Android background audio
            "android.audio.process.priority": "high",
          },
        ));

        // Stop and restart publishing stream to refresh connection
        await stopZegoPublish();

        // Short delay before re-publishing
        await Future.delayed(const Duration(milliseconds: 200));

        try {
          // Use a consistent stream ID when re-publishing
          final userName =
              hasCallState.callData.receiverName ?? "user_background";
          await startZegoPublish(
              roomId: hasCallState.callData.zegoRoomId, userName: userName);

          print('Successfully restarted audio stream in background');

          // Force audio route to ensure proper audio path
          ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
        } catch (e) {
          print('Error restarting publish in background: $e');
        }
      }
    }
  }

  void stopZegoListenEvent() {
    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onRoomStateUpdate = null;
    ZegoExpressEngine.onPublisherStateUpdate = null;
    ZegoExpressEngine.onRemoteCameraStateUpdate = null;
    ZegoExpressEngine.onRemoteMicStateUpdate = null;
  }

  Future<ZegoRoomLoginResult> loginZegoRoom({
    required String roomId,
    required String userID,
    required String userName,
  }) async {
    final hasCallState = state as HasCall;
    print(
        'Tried to login for user Id is $userID, user name is $userName and room id is $roomId');

    // The value of `userID` is generated locally and must be globally unique.
    final user = ZegoUser(userID, userName);
    final roomID = roomId;

    // Configure ZegoCloud for background audio before logging in
    ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
      advancedConfig: {
        "audio.capture.force_using_media_recorder": "true",
        "audio.captureAndRender.androidLowLatencyEnabled": "true",
        "background.mode.enabled": "true",
        "audio.process.continue.in.background": "true",
        "audio.audioRecord.bluetooth_disable_aec": "true",
        "audio.audioRecord.disable_aes": "true",
        "audio.process.keep.frequently.acquired": "true",
        "audio.audioRecord.keep.audiosession.active": "true",
        "audio.capture.prevent.system.suspend": "true"
      },
    ));

    // Optimize for background mode - use StandardQuality for voice calls
    ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
    ZegoExpressEngine.instance.setAudioConfig(
        ZegoAudioConfig.preset(ZegoAudioConfigPreset.StandardQuality));

    // onRoomUserUpdate callback can be received when "isUserStatusNotify" parameter value is "true".
    ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()
      ..isUserStatusNotify = true;

    final shouldEnableVideo =
        hasCallState.callData.callType == CallType.video.name;

    // log in to a room
    return ZegoExpressEngine.instance
        .loginRoom(roomID, user, config: roomConfig)
        .then((ZegoRoomLoginResult loginRoomResult) {
      if (loginRoomResult.errorCode == 0) {
        ZegoExpressEngine.instance.muteMicrophone(false);

        if (shouldEnableVideo) {
          // Ensure video is enabled
          ZegoExpressEngine.instance.mutePublishStreamVideo(false);
          startZegoPreview(isVideoEnabled: true);
        } else {
          // Ensure video is disabled
          ZegoExpressEngine.instance.mutePublishStreamVideo(true);
        }

        // Start publishing with appropriate stream ID
        startZegoPublish(roomId: roomId, userName: userName);

        // Update state to reflect initial video state
        emit(hasCallState.copyWith(isVideoEnabled: shouldEnableVideo));
      } else {
        print('loginRoom failed: ${loginRoomResult.errorCode}');
      }
      return loginRoomResult;
    });
  }

  Future<ZegoRoomLogoutResult> logoutZegoRoom({required String roomId}) async {
    print('logoutRoom : ${roomId}');
    stopZegoPreview();
    stopZegoPublish();
    return ZegoExpressEngine.instance.logoutRoom(roomId);
  }

  Future<void> startZegoPreview({required bool isVideoEnabled}) async {
    final hasCallState = state as HasCall;
    try {
      // Clean up any existing preview first
      if (localViewID != null) {
        await stopZegoPreview();
      }

      await ZegoExpressEngine.instance.createCanvasView((viewID) {
        localViewID = viewID;
        ZegoCanvas previewCanvas = ZegoCanvas(
          viewID,
          viewMode: ZegoViewMode.AspectFill,
        );

        // Set video state before starting preview
        ZegoExpressEngine.instance.mutePublishStreamVideo(!isVideoEnabled);
        ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
      }).then((canvasViewWidget) {
        if (isVideoEnabled) {
          emit(hasCallState.copyWith(
              localView: canvasViewWidget, isVideoEnabled: true));
        } else {
          emit(hasCallState.copyWith(
              localView: const SizedBox(), isVideoEnabled: false));
        }
      });
    } catch (e) {
      print("Error in startZegoPreview: $e");
      emit(hasCallState.copyWith(
          localView: const SizedBox(), isVideoEnabled: false));
    }
  }

  Future<void> stopZegoPreview() async {
    final hasCallState = state as HasCall;
    ZegoExpressEngine.instance.stopPreview();
    if (localViewID != null) {
      await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
      localViewID = null;
      emit(hasCallState.copyWith(
          localView: const SizedBox(), isVideoEnabled: false));
    }
  }

  Future<void> startZegoPublish(
      {required String roomId, required String userName}) async {
    final hasCallState = state as HasCall;
    // After calling the `loginRoom` method, call this method to publish streams.
    // The StreamID must be unique in the room.
    String streamID = '${roomId}_${userName}_call';
    // Ensure video is not muted when starting to publish
    await ZegoExpressEngine.instance
        .mutePublishStreamVideo(!hasCallState.isVideoEnabled);
    return ZegoExpressEngine.instance.startPublishingStream(streamID);
  }

  Future<void> stopZegoPublish() async {
    return ZegoExpressEngine.instance.stopPublishingStream();
  }

  Future<void> startZegoPlayStream(String streamID) async {
    final hasCallState = state as HasCall;
    try {
      // Clean up existing view if needed
      if (remoteViewID != null) {
        await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
        remoteViewID = null;
      }
      // Start to play streams. Set the view for rendering the remote streams.
      await ZegoExpressEngine.instance.createCanvasView((viewID) {
        remoteViewID = viewID;
        ZegoCanvas canvas = ZegoCanvas(
          viewID,
          viewMode: ZegoViewMode.AspectFill,
        );
        ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
      }).then((canvasViewWidget) {
        emit(hasCallState.copyWith(
            remoteView: canvasViewWidget, isRemoteVideoEnabled: true));
      });
    } catch (e) {
      print("Error in startZegoPlayStream: $e");
    }
  }

  Future<void> stopZegoPlayStream(String streamID) async {
    final hasCallState = state as HasCall;

    ZegoExpressEngine.instance.stopPlayingStream(streamID);
    if (remoteViewID != null) {
      ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
      remoteViewID = null;
      emit(hasCallState.copyWith(
          remoteView: const SizedBox(), isRemoteVideoEnabled: false));
    }
  }

  void toggleSpeaker() async {
    if (state is HasCall) {
      final hasCallState = state as HasCall;
      if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
        final engine = hasCallState.engine!;
        final bool isEnabled = hasCallState.isSpeaker;
        await engine.setEnableSpeakerphone(!isEnabled);
        emit(hasCallState.copyWith(isSpeaker: !isEnabled));
      } else if (hasCallState.isZegoCloud) {
        final bool isEnabled = hasCallState.isSpeaker;
        ZegoExpressEngine.instance.setAudioRouteToSpeaker(!isEnabled);
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
      } else if (hasCallState.isZegoCloud) {
        final bool isMuted = hasCallState.isMute;
        ZegoExpressEngine.instance.muteMicrophone(!isMuted);
        emit(hasCallState.copyWith(isMute: !isMuted));
      }
      // For ZegoCloud, mute control is handled by the UI Kit
    }
  }

  void toggleVideo() async {
    print("toggle video with ");
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
      } else if (hasCallState.isZegoCloud) {
        final bool isVideoEnabled = hasCallState.isVideoEnabled;

        try {
          if (!isVideoEnabled) {
            // Turn ON video
            print("Turning video ON");
            // First enable publishing video
            await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
            // Then start preview
            await startZegoPreview(isVideoEnabled: true);
          } else {
            // Turn OFF video
            print("Turning video OFF");
            // First mute publishing video so receiver is notified
            await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
            // Then stop local preview
            await stopZegoPreview();
          }

          // Update local state
          emit(hasCallState.copyWith(isVideoEnabled: !isVideoEnabled));
        } catch (e) {
          print("Error toggling video: $e");
        }
      }
    }
  }
}
