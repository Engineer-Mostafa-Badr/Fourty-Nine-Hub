// import 'dart:convert';
// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../core/enums/call_enums_manager.dart';
// import '../../../../../core/utils/logging_service.dart';
// import '../../../domain/entities/call_data.dart';
// import 'call_state.dart';
// import '../../../services/call_timer_service.dart';
// import '../../../services/video_fix_helper.dart';
// import '../../../services/zego_video_timing_manager.dart';
// import '../../../../../helpers/call_helpers/call_helper/call_with_notification_helper.dart';
// import '../../../../../res/style/const.dart';
// import '../../../../../service_locator/service_locator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class CallCubit extends Cubit<CallState> {
//   CallCubit() : super(NoCalls());
//
//   int? remoteViewID;
//   int? localViewID;
//   String? _remoteStreamID;
//   static bool _isEngineInitialized = false;
//
//   static Future<void> initializeZegoEngine() async {
//     if (_isEngineInitialized) return;
//
//     try {
//       await ZegoExpressEngine.destroyEngine();
//     } catch (e) {
//       // Engine might not exist
//       LoggingService.warning("Error destroying previous ZegoCloud engine: $e");
//     }
//
//     await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
//       UIConst.zegoAppId,
//       ZegoScenario.General, // Use General scenario instead of deprecated Communication
//       appSign: UIConst.zegoAppSign,
//       enablePlatformView: true,
//     ));
//
//     _isEngineInitialized = true;
//     LoggingService.info("ZegoCloud engine initialized successfully");
//   }
//
//   static Future<void> destroyZegoEngine() async {
//     if (!_isEngineInitialized) return;
//
//     try {
//       await ZegoExpressEngine.destroyEngine();
//       _isEngineInitialized = false;
//       LoggingService.info("ZegoCloud engine destroyed successfully");
//     } catch (e) {
//       LoggingService.error("Error destroying ZegoCloud engine", error: e);
//     }
//   }
//
//   void checkIfThereIsCall() async {
//     await serviceLocator<SharedPreferences>().reload();
//     final storedCall =
//         serviceLocator<SharedPreferences>().getString('call_data');
//     LoggingService.debug('stored call: $storedCall');
//     if (storedCall != null) {
//       LoggingService.debug('stored call if not equal null: $storedCall');
//
//       final data = json.decode(storedCall.toString());
//       final callData = CallData.fromMap(data, false);
//       serviceLocator<CallWithNotificationHelper>()
//           .connectToCall(callData, false, isFromCheckIfThereIsACall: true);
//       startCall(callData, true);
//     }
//   }
//
//   Future startCall(CallData callData, bool isFromCheckComingCall) async {
//     LoggingService.methodCall("CallCubit", "startCall");
//     CallTimerService().resetTimer();
//     if (callData.isRealCall == true.toString()) {
//       LoggingService.info("Starting call");
//       // Request permissions first
//       final micStatus = await Permission.microphone.request();
//       if (micStatus == PermissionStatus.denied ||
//           micStatus == PermissionStatus.permanentlyDenied) {
//         LoggingService.warning("Calling ended because of mic permission");
//         endCall();
//         return;
//       }
//
//       if (callData.callType == CallType.video.name) {
//         final camStatus = await Permission.camera.request();
//         if (camStatus == PermissionStatus.denied ||
//             camStatus == PermissionStatus.permanentlyDenied) {
//           LoggingService.warning("Calling ended because of camera permission");
//           endCall();
//           return;
//         }
//       }
//
//       if (callData.serviceType == "agora") {
//         LoggingService.info("Engine initialized");
//         final engine = await _initializeEngine(callData);
//         LoggingService.debug('Engine initialized: $engine');
//         if (engine == null) return;
//         emit(HasCall(
//           engine: engine,
//           callData: callData,
//           isMute: false,
//           isSpeaker: false,
//           isVideoEnabled: callData.callType == CallType.video.name,
//         ));
//       } else if (callData.serviceType == "zegocloud") {
//         LoggingService.info(
//             "Start call with zegocloud with is video ${callData.callType == CallType.video.name} room id ${callData.zegoRoomId} and receiver name is ${callData.receiverName} and call type is video of ${callData.callType} ${callData.callType == CallType.video.name}");
//         // await initializeZegoEngine();
//
//         emit(HasCall(
//           engine: null,
//           callData: callData,
//           isZegoCloud: true,
//           isMute: false,
//           isSpeaker: false,
//           isVideoEnabled: callData.callType == CallType.video.name,
//           isRemoteVideoEnabled: callData.callType == CallType.video.name,
//         ));
//
//         await _configureZegoAudioSettings();
//
//         // await _joinZegoRoom(callData);
//       }
//     } else {
//       LoggingService.debug("VoiceCallingScreen call state4: $state");
//       if (isFromCheckComingCall) {
//         emit(HasCall(
//           engine: null,
//           callData: callData,
//           isMute: false,
//           isSpeaker: false,
//           isVideoEnabled: callData.callType == CallType.video.name,
//         ));
//       }
//     }
//   }
//
//   Future<void> _configureZegoAudioSettings() async {
//     LoggingService.methodCall("CallCubit", "_configureZegoAudioSettings");
//
//     try {
//       // STEP 1: First, release any existing audio resources to avoid conflicts
//       await ZegoExpressEngine.instance.enableAudioCaptureDevice(false);
//       await Future.delayed(Duration(milliseconds: 100));
//
//       // STEP 2: Set up high-quality audio config for clearer sound
//       await ZegoExpressEngine.instance.setAudioConfig(ZegoAudioConfig(
//         48000, // Higher sample rate for better quality
//         ZegoAudioChannel.Mono, // Mono is sufficient for voice calls
//         ZegoAudioCodecID.Normal, // Standard codec for compatibility
//       ));
//       LoggingService.info("✅ Audio config set");
//
//       // STEP 3: Enable audio capture device with explicit mode
//       await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//       LoggingService.info("✅ Audio capture enabled");
//
//       // STEP 4: Ensure microphone is definitely NOT muted
//       await ZegoExpressEngine.instance.muteMicrophone(false);
//       LoggingService.info("✅ Microphone unmuted");
//
//       // STEP 5: Explicitly unmute audio publishing
//       await ZegoExpressEngine.instance.mutePublishStreamAudio(false);
//       LoggingService.info("✅ Stream audio publishing unmuted");
//
//       // STEP 6: Set appropriate volumes for both input and output
//       await ZegoExpressEngine.instance.setCaptureVolume(100); // Max mic volume
//       // await ZegoExpressEngine.instance.setPlayVolume(100); // Set global playback volume
//       LoggingService.info("✅ Audio volumes configured");
//
//       // STEP 7: Use earpiece by default (more private and reduces echo)
//       await ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
//       LoggingService.info("✅ Audio route set to earpiece");
//
//       // STEP 8: Apply comprehensive engine config focusing on audio reliability
//       ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
//         advancedConfig: {
//           // Audio processing settings
//           "audio.enable.aec": "true", // Echo cancellation
//           "audio.enable.agc": "true", // Auto gain control
//           "audio.enable.ans": "true", // Noise suppression
//           "audio.voice.communication.mode": "true", // Optimize for voice calls
//
//           // Reliable audio initialization
//           "audio.audioRecord.startWhenInit": "true",
//           "audio.audioTrack.startWhenInit": "true",
//
//           // Critical for Android audio capture reliability
//           "audio.capture.force_using_media_recorder": "true",
//           "audio.audioRecord.force.using.media.codec": "true",
//
//           // Important to prevent audio cutoffs
//           "audio.enable.hardware.decoder": "true",
//           "audio.record.keep.awake": "true",
//           "audio.player.keep.awake": "true",
//
//           // Background mode settings
//           "background.mode.enabled": "true",
//           "audio.process.continue.in.background": "true",
//
//           // Enhanced audio settings for both sides to hear clearly
//           "audio.audioRecord.has.reference": "true",
//           "audio.audioRecord.reference.enalbe": "true",
//           "audio.record.rescue.enabled": "true",
//           "audio.audioRecord.rescue.enabled": "true",
//           "audio.enable.software.aec.with.builtin": "true",
//
//           // Lower latency audio
//           "audio.audioRecord.mode.lowLatency": "true",
//           "audio.capture.audioJitterBuffer": "false",
//         },
//       ));
//       LoggingService.info("✅ Advanced audio engine config applied");
//
//       LoggingService.info("✓ Audio settings configured successfully");
//     } catch (e) {
//       LoggingService.error("❌ Error configuring audio settings", error: e);
//
//       // Attempt recovery with basic settings
//       try {
//         await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//         await ZegoExpressEngine.instance.muteMicrophone(false);
//         await ZegoExpressEngine.instance.mutePublishStreamAudio(false);
//         LoggingService.info("⚠️ Applied fallback audio settings after error");
//       } catch (_) {}
//     }
//   }
//
//   Future<RtcEngine?> _initializeEngine(CallData callData) async {
//     LoggingService.debug("Call data: $callData");
//     final agoraEngine = createAgoraRtcEngine();
//     await agoraEngine.initialize(const RtcEngineContext(
//       appId: "223d82348c04428fb78029d931bbbbe7",
//
//       //  UIConst.agoraAppId,
//       channelProfile: ChannelProfileType.channelProfileCommunication1v1,
//     ));
//
//     // Configure audio session for background mode
//     await agoraEngine.enableAudioVolumeIndication(
//         interval: 200, smooth: 3, reportVad: true);
//     await agoraEngine.setParameters('{"che.audio.keep.audiosession": true}');
//     await agoraEngine.enableWebSdkInteroperability(true);
//     // await agoraEngine.setParameters('{"che.audio.enable.aec": false}');
//     // await agoraEngine.setParameters('{"che.audio.enable.agc": false}');
//     // await agoraEngine.setParameters('{"che.audio.enable.ns": false}');
//
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           LoggingService.info("Local user ${connection.localUid} joined");
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           LoggingService.info("Remote user $remoteUid joined");
//         },
//         onError: (err, msg) {
//           LoggingService.error("Agora Error - Code: $err, Message: $msg");
//         },
//         onConnectionStateChanged: (connection, state, reason) {
//           if (state == ConnectionStateType.connectionStateDisconnected ||
//               state == ConnectionStateType.connectionStateFailed &&
//                   connection.channelId == callData.channelId) {
//             LoggingService.warning(
//                 "Calling ended because of connection state change state is $state and channel is ${connection.channelId} and callData is ${callData.channelId}");
//             endCall();
//           }
//         },
//       ),
//     );
//
//     await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await agoraEngine.enableAudio();
//
//     // Set audio scenario to ensure audio continues in background
//     await agoraEngine.setAudioScenario(AudioScenarioType.audioScenarioChatroom);
//     await agoraEngine
//         .setEnableSpeakerphone(false); // Start with earpiece by default
//
//     if (callData.callType == CallType.video.name) {
//       await agoraEngine.enableVideo();
//     }
//
//     LoggingService.debug(
//         "Joining channel with token: ${callData.rtcToken.substring(0, 10)}...");
//     LoggingService.debug("Channel ID: ${callData.channel}");
//
//     LoggingService.debug(
//         'callData.rtcToken ${callData.rtcToken}  callData.channelId ${callData.channelId}  callData.channelName ${callData.channel}');
//     await agoraEngine.joinChannel(
//       token:
//           // "007eJxTYHAVuXMi7NEWiT9v0+P4rL+GRWlv/stWyn2PW8qh+41/1zUFBiMj4xQLI2MTi2QDExMji7QkcwsDI8sUS2PDJCBINf99c2t6QyAjwz8lVQZGKATxVRgsEk1TDc2TU3RTDMyTdU2SjJJ1LYyTEnUtU00tEw1S0lIszEwYGADHbSgT",
//           callData.rtcToken,
//       channelId:
//           // "8a5e17cd-d07c-4b2c-83ba-9e59a0dfd864",
//           callData.channel,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         channelProfile: ChannelProfileType.channelProfileCommunication1v1,
//       ),
//     );
//     LoggingService.info("Agora engine initialized and joined");
//     // await agoraEngine.setDefaultAudioRouteToSpeakerphone(
//     //     callData.callType == CallType.video.name);
//     await agoraEngine.setDefaultAudioRouteToSpeakerphone(false);
//
//     return agoraEngine;
//   }
//   void endCall() async {
//     LoggingService.methodCall("CallCubit", "endCall");
//     LoggingService.info("📞 DEBUG: Starting endCall() process");
//
//     CallTimerService().resetTimer();
//     LoggingService.info("📞 DEBUG: Call timer reset completed");
//
//     if (state is HasCall) {
//       final hasCallState = state as HasCall;
//       LoggingService.info('📞 DEBUG: Current state is HasCall - proceeding with cleanup');
//       LoggingService.info('📞 DEBUG: Call data - Channel: ${hasCallState.callData.channelId}, isRealCall: ${hasCallState.callData.isRealCall}');
//
//       await serviceLocator<SharedPreferences>().remove('call_data');
//       LoggingService.info("📞 DEBUG: Removed call_data from SharedPreferences");
//
//       LoggingService.info("📞 DEBUG: Sending callEnded notification to remote user");
//       serviceLocator<CallWithNotificationHelper>().sendActionNotification(
//         hasCallState.callData,
//         CallActions.callEnded,
//         reason: 'user ended call after call connected',
//       );
//       LoggingService.info("📞 DEBUG: callEnded notification sent successfully");
//
//       if (hasCallState.callData.isRealCall == true.toString()) {
//         LoggingService.info("📞 DEBUG: This is a real call - cleaning up engines");
//
//         if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
//           LoggingService.info("📞 DEBUG: Cleaning up Agora engine");
//           final engine = hasCallState.engine!;
//           await engine.leaveChannel();
//           await engine.release();
//           LoggingService.info("📞 DEBUG: Agora engine cleanup completed");
//         } else if (hasCallState.isZegoCloud) {
//           LoggingService.info("📞 DEBUG: Cleaning up ZegoCloud resources");
//
//           // First stop streaming and preview
//           if (_remoteStreamID != null) {
//             LoggingService.info("📞 DEBUG: Stopping remote stream: $_remoteStreamID");
//             await stopZegoPlayStream(_remoteStreamID!);
//             _remoteStreamID = null;
//             LoggingService.info("📞 DEBUG: Remote stream stopped and cleared");
//           } else {
//             LoggingService.info("📞 DEBUG: No remote stream to stop");
//           }
//
//           // Finally logout from room
//           LoggingService.info("📞 DEBUG: Logging out from ZegoRoom: ${hasCallState.callData.zegoRoomId}");
//           await logoutZegoRoom(roomId: hasCallState.callData.zegoRoomId);
//           LoggingService.info("📞 DEBUG: ZegoRoom logout completed");
//         }
//       } else {
//         LoggingService.info("📞 DEBUG: This is not a real call - skipping engine cleanup");
//       }
//     } else {
//       LoggingService.info("📞 DEBUG: Current state is not HasCall - nothing to cleanup");
//       LoggingService.info("📞 DEBUG: Current state type: ${state.runtimeType}");
//     }
//
//     LoggingService.info("📞 DEBUG: Emitting NoCalls() state");
//     emit(NoCalls());
//     LoggingService.info("📞 DEBUG: endCall() process completed successfully");
//   }
//
//   // void startZegoListenEvent() {
//   //   final hasCallState = state as HasCall;
//
//   //   // Configure audio settings
//   //   ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//   //   ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
//   //   ZegoExpressEngine.instance.setCaptureVolume(80);
//
//   //   // Room user updates
//   //   ZegoExpressEngine.onRoomUserUpdate =
//   //       (roomID, updateType, List<ZegoUser> userList) {
//   //     debugPrint(
//   //         'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
//
//   //     if (updateType == ZegoUpdateType.Add) {
//   //       for (final user in userList) {
//   //         print("New user joined: ${user.userID}");
//   //         // Force enable audio when new user joins
//   //         ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//   //       }
//   //     }
//   //   };
//
//   //   // Stream updates - CRITICAL for audio
//   //   ZegoExpressEngine.onRoomStreamUpdate =
//   //       (roomID, updateType, List<ZegoStream> streamList, extendedData) {
//   //     debugPrint(
//   //         'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}');
//
//   //     final hasCallState = state as HasCall;
//   //     if (updateType == ZegoUpdateType.Add) {
//   //       for (final stream in streamList) {
//   //         print("New stream added: ${stream.streamID}");
//   //         _remoteStreamID = stream.streamID;
//
//   //         // IMPORTANT: Start playing the remote stream for audio
//   //         startZegoPlayStream(stream.streamID);
//
//   //         // Update UI for video calls
//   //         final isVideo = hasCallState.callData.callType == CallType.video.name;
//   //         emit(hasCallState.copyWith(isRemoteVideoEnabled: isVideo));
//   //       }
//   //     } else if (updateType == ZegoUpdateType.Delete) {
//   //       for (final stream in streamList) {
//   //         if (stream.streamID == _remoteStreamID) {
//   //           print("Stream removed: ${stream.streamID}");
//   //           _remoteStreamID = null;
//   //           stopZegoPlayStream(stream.streamID);
//   //           emit(hasCallState.copyWith(
//   //               isRemoteVideoEnabled: false, remoteView: const SizedBox()));
//   //         }
//   //       }
//   //     }
//   //   };
//
//   //   // Remote microphone state
//   //   ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
//   //     debugPrint(
//   //         'onRemoteMicStateUpdate streamID: $streamID, state: ${state.name}');
//
//   //     // Ensure our audio continues regardless of remote state
//   //     ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
//   //     // If remote user is in background, ensure our mic stays active
//   //     if (state == ZegoRemoteDeviceState.InBackground) {
//   //       final currentState = this.state as HasCall;
//   //       if (!currentState.isMute) {
//   //         ZegoExpressEngine.instance.muteMicrophone(false);
//   //       }
//   //     }
//   //   };
//
//   //   // Other event handlers...
//   //   _setupAdditionalEventHandlers();
//   // }
//
//   void startZegoListenEvent() {
//     // Configure audio settings
//     ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//     ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
//     ZegoExpressEngine.instance.setCaptureVolume(80);
//
//     // Room user updates
//     ZegoExpressEngine.onRoomUserUpdate =
//         (roomID, updateType, List<ZegoUser> userList) {
//       LoggingService.debug(
//           'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
//
//       if (updateType == ZegoUpdateType.Add) {
//         for (final user in userList) {
//           LoggingService.info("New user joined: ${user.userID}");
//           // Force enable audio when new user joins
//           ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
//           // Update call state to connected when remote user joins
//           final currentState = state as HasCall;
//           if (!currentState.isCallConnected) {
//             emit(currentState.copyWith(isCallConnected: true));
//             LoggingService.info("Call is now connected - both users are in the room");
//           }
//         }      } else if (updateType == ZegoUpdateType.Delete) {
//         for (final user in userList) {
//           LoggingService.info("User left: ${user.userID}");
//           // Handle user leaving - CRITICAL FIX for call state
//           final currentState = state as HasCall;
//
//           // If any user leaves, the call should end
//           LoggingService.warning("User ${user.userID} left the room - ending call");
//
//           // Send notification that call ended due to user leaving
//           serviceLocator<CallWithNotificationHelper>().sendActionNotification(
//             currentState.callData,
//             CallActions.callEnded,
//             reason: 'remote user left the room',
//           );
//
//           // End the call for remaining user
//           Future.delayed(Duration(milliseconds: 500), () {
//             if (state is HasCall) {
//               LoggingService.info("Ending call due to user leaving");
//               endCall();
//             }
//           });
//         }
//       }
//     };    // Stream updates - CRITICAL for both audio and video
//     ZegoExpressEngine.onRoomStreamUpdate =
//         (roomID, updateType, List<ZegoStream> streamList, extendedData) {
//       LoggingService.debug(
//           'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}');
//
//       final hasCallState = state as HasCall;
//       if (updateType == ZegoUpdateType.Add) {
//         for (final stream in streamList) {
//           LoggingService.info("=== NEW STREAM DETECTED ===");
//           LoggingService.info("Stream ID: ${stream.streamID}");
//           LoggingService.info("Stream User ID: ${stream.user.userID}");
//
//           // CRITICAL: Start the call timer when we receive the first remote stream
//           if (!CallTimerService().isRunning) {
//             CallTimerService().startTimer();
//             LoggingService.info("✓ Call timer started - call connected");
//           }
//
//           // Start playing the remote stream (for audio)
//           startZegoPlayStream(stream.streamID);
//           LoggingService.info("✓ Started playing stream: ${stream.streamID}");
//
//           _remoteStreamID = stream.streamID;
//
//           // For video calls, initialize remote video state
//           final isVideoCall = hasCallState.callData.callType == CallType.video.name;
//           if (isVideoCall) {
//             // Initially assume remote video is enabled for video calls
//             emit(hasCallState.copyWith(
//               isCallConnected: true,
//               isRemoteVideoEnabled: true,
//             ));
//             LoggingService.info("✓ Video call - remote video state initialized");
//           } else {
//             // Mark call as connected for audio calls
//             emit(hasCallState.copyWith(isCallConnected: true));
//           }
//           LoggingService.info("✓ Call marked as connected");
//         }
//       } else if (updateType == ZegoUpdateType.Delete) {
//         for (final stream in streamList) {
//           if (stream.streamID == _remoteStreamID) {
//             stopZegoPlayStream(stream.streamID);
//             LoggingService.info("Stopped playing deleted stream: ${stream.streamID}");
//             _remoteStreamID = null;
//
//             // Update state to reflect disconnection and video cleanup
//             emit(hasCallState.copyWith(
//               isCallConnected: false,
//               isRemoteVideoEnabled: false,
//               remoteView: const SizedBox(),
//             ));
//             LoggingService.info("✓ Call disconnected - UI state updated");
//           }
//         }
//       }
//     };
//
//     // Room state updates
//     ZegoExpressEngine.onRoomStateUpdate =
//         (roomID, state, errorCode, extendedData) {
//       LoggingService.debug(
//           'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode');
//
//       if (state == ZegoRoomState.Connected) {
//         LoggingService.info("Room connected successfully");
//         ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//       } else if (state == ZegoRoomState.Disconnected) {
//         LoggingService.info("Room disconnected");
//         final currentState = this.state as HasCall;
//         emit(currentState.copyWith(isCallConnected: false));
//       }
//     };
//
//     // Remote microphone state updates
//     ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
//       LoggingService.debug(
//           'onRemoteMicStateUpdate streamID: $streamID, state: ${state.name}');
//
//       // Ensure our audio continues regardless of remote state
//       ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
//       // If remote user is in background, ensure our mic stays active
//       if (state == ZegoRemoteDeviceState.InBackground) {
//         final currentState = this.state as HasCall;
//         if (!currentState.isMute) {
//           ZegoExpressEngine.instance.muteMicrophone(false);
//         }
//       }
//     };
//
//     // Publisher state updates
//     ZegoExpressEngine.onPublisherStateUpdate =
//         (streamID, state, errorCode, extendedData) {
//       LoggingService.debug(
//           'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode');
//
//       if (state == ZegoPublisherState.Publishing) {
//         LoggingService.info("Successfully publishing stream: $streamID");
//         // Ensure audio is active when publishing starts
//         ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//       }
//     };
//
//
//
//   // If remote app goes to background, don't immediately hide video
//   Timer? backgroundVideoTimer;
//   Future<void> handleRemoteAppBackground(String streamID) async {
//     // Cancel any existing timer
//     backgroundVideoTimer?.cancel();
//
//     // Start a new timer - if the app doesn't come back to foreground in 3 seconds, disable video
//     backgroundVideoTimer = Timer(Duration(seconds: 3), () {
//       if (isClosed) return;
//
//       final currentState = state as HasCall;
//       if (currentState.isRemoteVideoEnabled && _remoteStreamID == streamID) {
//         LoggingService.info("⏱️ Remote app still in background after timeout - disabling video");
//         emit(currentState.copyWith(
//           isRemoteVideoEnabled: false,
//           remoteView: Container(
//             color: Colors.black45,
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.hourglass_bottom, color: Colors.white, size: 48),
//                   SizedBox(height: 12),
//                   Text("Video paused - waiting for other user", style: TextStyle(color: Colors.white))
//                 ],
//               ),
//             ),
//           ),
//         ));
//       }
//     });
//   }
//
//   // Method to handle when remote video needs refresh
//   Future<void> handleRemoteVideoRefresh(String streamID) async {
//     try {
//       LoggingService.info("🔄 Refreshing remote video for stream: $streamID");
//
//       // Stop existing stream playback
//       await ZegoExpressEngine.instance.stopPlayingStream(streamID);
//
//       // Add small delay for resource cleanup
//       await Future.delayed(Duration(milliseconds: 200));
//
//       // Restart remote video streaming with proper canvas setup
//       await startZegoPlayStream(streamID);
//
//       LoggingService.info("✅ Remote video refresh completed");
//     } catch (e) {
//       LoggingService.error("❌ Error refreshing remote video", error: e);
//     }
//   }
//
//   // Method to check and update remote video state when issues are detected
//   Future<void> checkAndUpdateRemoteVideoState(String streamID) async {
//     if (state is! HasCall || streamID != _remoteStreamID) return;
//
//     final hasCallState = state as HasCall;
//     if (hasCallState.callData.callType != CallType.video.name) return;
//
//     try {
//       // Use RemoteVideoManager to check video state
//       // final manager = RemoteVideoManager();
//       // await manager.checkRemoteVideoState(streamID);
//
//       // // If there are issues, try to fix them
//       // if (manager.hasVideoIssues(streamID)) {
//       //   LoggingService.info("🔧 Detected remote video issues, attempting fix...");
//       //   await manager.fixRemoteVideoIssues(streamID);
//       // }
//     } catch (e) {
//       LoggingService.error("Error checking remote video state", error: e);
//     }
//   }
//
//     // Remote camera state updates - CRITICAL for video functionality
//     ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) {
//       LoggingService.info(
//           '📹 Remote camera state update for stream: $streamID, state: ${state.name}');
//
//       final hasCallState = this.state as HasCall;
//       final isVideoCall = hasCallState.callData.callType == CallType.video.name;
//
//       if (isVideoCall && streamID == _remoteStreamID) {
//         LoggingService.info("🔄 Processing remote camera state change: ${state.name}");
//
//         bool remoteVideoEnabled = false;
//         // switch (state) {
//         //   case ZegoRemoteDeviceState.Open:
//         //     remoteVideoEnabled = true;
//         //     LoggingService.info("✅ Remote camera is ON - video should be visible");
//
//         //     // For Open state, we may want to refresh the remote view to ensure it displays properly
//         //     if (!hasCallState.isRemoteVideoEnabled) {
//         //       LoggingService.info("🔄 Refreshing remote video because camera was just turned on");
//
//         //       // If we have a valid stream ID and remote view was previously disabled, refresh it
//         //       // Using Future to handle async operations in non-async callback
//         //       _handleRemoteVideoRefresh(streamID);
//         //     }
//         //     break;
//
//         //   case ZegoRemoteDeviceState.Mute:
//         //     LoggingService.info("🔇 Remote camera is MUTED - user disabled video");
//         //     remoteVideoEnabled = false;
//         //     break;
//
//         //   case ZegoRemoteDeviceState.Disable:
//         //     LoggingService.info("🚫 Remote camera is DISABLED");
//         //     remoteVideoEnabled = false;
//         //     break;
//
//         //   case ZegoRemoteDeviceState.InBackground:
//         //     LoggingService.info("⏱️ Remote app is in BACKGROUND - may resume shortly");
//         //     // We don't immediately disable video for background state, as it may return
//         //     // Instead, we'll start a timer and disable if it doesn't return quickly
//         //     _handleRemoteAppBackground(streamID);
//         //     return; // Let the timer handle state updates
//
//         //   case ZegoRemoteDeviceState.NotSupport:
//         //   case ZegoRemoteDeviceState.GenericError:
//         //   case ZegoRemoteDeviceState.InvalidID:
//         //   case ZegoRemoteDeviceState.NoAuthorization:
//         //     LoggingService.warning("⚠️ Remote camera error state: ${state.name}");
//         //     remoteVideoEnabled = false;
//         //     break;
//         // }
//         if (state == ZegoRemoteDeviceState.Open) {
//             remoteVideoEnabled = true;
//             LoggingService.info("✅ Remote camera is ON - video should be visible");
//
//             // For Open state, we may want to refresh the remote view to ensure it displays properly
//             if (!hasCallState.isRemoteVideoEnabled) {
//               LoggingService.info("🔄 Refreshing remote video because camera was just turned on");
//               handleRemoteVideoRefresh(streamID);
//             }
//           } else if (state == ZegoRemoteDeviceState.Mute) {
//             LoggingService.info("🔇 Remote camera is MUTED - user disabled video");
//             remoteVideoEnabled = false;
//           } else if (state == ZegoRemoteDeviceState.Disable) {
//             LoggingService.info("🚫 Remote camera is DISABLED");
//             remoteVideoEnabled = false;
//           } else if (state == ZegoRemoteDeviceState.InBackground) {
//             LoggingService.info("⏱️ Remote app is in BACKGROUND - may resume shortly");
//             // We don't immediately disable video for background state, as it may return
//             handleRemoteAppBackground(streamID);
//             return; // Let the timer handle state updates
//           } else if (state == ZegoRemoteDeviceState.MultiForegroundApp) {
//             LoggingService.info("⏱️ Remote device has multiple foreground apps - may affect video");
//             // Handle similarly to background state as it may be temporary
//             handleRemoteAppBackground(streamID);
//             return; // Let the timer handle state updates
//           } else if (state == ZegoRemoteDeviceState.RebootRequired) {
//             LoggingService.warning("🔄 Remote device requires REBOOT");
//             remoteVideoEnabled = false;
//           } else if (
//             state == ZegoRemoteDeviceState.NotSupport ||
//             state == ZegoRemoteDeviceState.GenericError ||
//             state == ZegoRemoteDeviceState.InvalidID ||
//             state == ZegoRemoteDeviceState.NoAuthorization ||
//             state == ZegoRemoteDeviceState.ZeroFPS ||
//             state == ZegoRemoteDeviceState.InUseByOther ||
//             state == ZegoRemoteDeviceState.Unplugged ||
//             state == ZegoRemoteDeviceState.SystemMediaServicesLost ||
//             state == ZegoRemoteDeviceState.Interruption
//           ) {
//             LoggingService.warning("⚠️ Remote camera error state: ${state.name}");
//             remoteVideoEnabled = false;
//           }
//
//         // Update UI based on camera state (unless we're in background state)
//         if (state != ZegoRemoteDeviceState.InBackground) {
//           if (!remoteVideoEnabled) {
//             // Create a placeholder for disabled camera
//             final placeholderWidget = Container(
//               color: Colors.black45,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.videocam_off, color: Colors.white, size: 48),
//                     SizedBox(height: 12),
//                     Text("Camera turned off", style: TextStyle(color: Colors.white))
//                   ],
//                 ),
//               ),
//             );
//
//             // Update UI state
//             emit(hasCallState.copyWith(
//               remoteView: placeholderWidget,
//               isRemoteVideoEnabled: false,
//             ));
//             LoggingService.info("✅ Updated UI with placeholder for disabled camera");
//           } else if (!hasCallState.isRemoteVideoEnabled) {
//             // Camera is enabled but UI shows disabled - this is handled by the Open case
//             // which will call _handleRemoteVideoRefresh
//           }
//
//         }
//
//         // Update the UI state to reflect remote video status
//         if (hasCallState.isRemoteVideoEnabled != remoteVideoEnabled) {
//           emit(hasCallState.copyWith(isRemoteVideoEnabled: remoteVideoEnabled));
//           LoggingService.info("🔄 Updated remote video state to: $remoteVideoEnabled");
//
//           // If video is being disabled, show a placeholder
//           if (!remoteVideoEnabled) {
//             emit(hasCallState.copyWith(
//               remoteView: Container(
//                 color: Colors.black45,
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.videocam_off, color: Colors.white, size: 48),
//                       SizedBox(height: 12),
//                       Text("Camera turned off", style: TextStyle(color: Colors.white))
//                     ],
//                   ),
//                 ),
//               ),
//               isRemoteVideoEnabled: false,
//             ));
//             LoggingService.info("✅ Updated UI with placeholder for disabled camera");
//           }
//         }
//       }
//     };
//
//     // Player state updates - Important for receiver
//     ZegoExpressEngine.onPlayerStateUpdate =
//         (streamID, state, errorCode, extendedData) {
//       LoggingService.debug(
//           'onPlayerStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode');
//
//       if (state == ZegoPlayerState.Playing) {
//         LoggingService.info("Successfully playing remote stream: $streamID");
//         // Ensure audio output is enabled when playing remote stream
//         ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
//
//         // Mark call as connected when we start playing remote stream
//         final currentState = this.state as HasCall;
//         if (!currentState.isCallConnected) {
//           emit(currentState.copyWith(isCallConnected: true));
//           CallTimerService().startTimer();
//           LoggingService.info("Call connected - started playing remote stream");
//         }
//
//         // Check and update remote video state when we start playing
//         if (currentState.callData.callType == CallType.video.name) {
//           Future.delayed(Duration(milliseconds: 500), () {
//             checkAndUpdateRemoteVideoState(streamID);
//           });
//         }
//       }
//     };
//
//     // CRITICAL VIDEO EVENT HANDLERS - Enhanced for better timing synchronization
//
//     // Publisher video first frame event - for local video with timing tracking
//     ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = (channel) {
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       LoggingService.info("🎥 [$timestamp] LOCAL VIDEO FIRST FRAME CAPTURED - camera feed is working");
//       // This confirms that the local camera is capturing video content
//     };
//
//     ZegoExpressEngine.onPublisherRenderVideoFirstFrame = (channel) {
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       LoggingService.info("🎥 [$timestamp] LOCAL VIDEO FIRST FRAME RENDERED - local video should be visible");
//       // This confirms that local video is being rendered to the canvas
//     };    // Player video first frame event - for remote video with state synchronization
//     ZegoExpressEngine.onPlayerRecvVideoFirstFrame = (streamID) {
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       LoggingService.info("🎥 [$timestamp] REMOTE VIDEO FIRST FRAME RECEIVED from stream: $streamID");
//       // This confirms remote video content is being received
//     };
//
//     ZegoExpressEngine.onPlayerRenderVideoFirstFrame = (streamID) {
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       LoggingService.info("🎥 [$timestamp] REMOTE VIDEO FIRST FRAME RENDERED for stream: $streamID - remote video should be visible");
//       // This confirms remote video is being rendered to the canvas
//
//       // CRITICAL: Force update UI state when remote video actually renders
//       if (streamID == _remoteStreamID) {
//         final currentState = state as HasCall;
//         if (currentState.callData.callType == CallType.video.name) {
//           LoggingService.info("🔄 Updating UI state for remote video display");
//
//           // Force enable remote video in the UI when first frame actually renders
//           emit(currentState.copyWith(
//             isRemoteVideoEnabled: true,
//             isCallConnected: true,
//           ));
//           LoggingService.info("✅ Remote video enabled in UI - first frame confirmed");
//
//           // Ensure the remote view is properly refreshed
//           _refreshRemoteVideoDisplay(streamID);
//         }
//       }
//     };
//
//     // Publisher video size change - indicates video is properly initialized
//     ZegoExpressEngine.onPublisherVideoSizeChanged = (width, height, channel) {
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       LoggingService.info("📐 [$timestamp] LOCAL VIDEO SIZE CHANGED: ${width}x$height - video dimensions set");
//
//       // Verify video configuration is correct
//       if (width > 0 && height > 0) {
//         LoggingService.info("✓ Local video dimensions confirmed - preview should be working");
//       }
//     };
//
//     // Player video size change - indicates remote video is properly initialized
//     ZegoExpressEngine.onPlayerVideoSizeChanged = (streamID, width, height) {
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       LoggingService.info("📐 [$timestamp] REMOTE VIDEO SIZE CHANGED for $streamID: ${width}x$height - remote video dimensions set");
//
//       // Verify remote video configuration
//       if (width > 0 && height > 0 && streamID == _remoteStreamID) {
//         LoggingService.info("✓ Remote video dimensions confirmed - remote preview should be working");
//       }
//     };
//   }
//
//   // void startZegoListenEvent() {
//   //   final hasCallState = state as HasCall;
//
//   //   // Configure ZegoCloud for background audio with much stronger settings
//   //   ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//   //   ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
//
//   //   // Set capture volume to a moderate level for better stability
//   //   ZegoExpressEngine.instance.setCaptureVolume(80);
//
//   //   // Pre-configure critical background audio settings
//   //   ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
//   //     advancedConfig: {
//   //       "audio.capture.force_using_media_recorder": "true",
//   //       "audio.captureAndRender.androidLowLatencyEnabled": "true",
//   //       "background.mode.enabled": "true",
//   //       "audio.process.continue.in.background": "true",
//   //       "audio.audioRecord.bluetooth_disable_aec": "true",
//   //       "audio.audioRecord.disable_aes": "true",
//   //       "audio.process.keep.frequently.acquired": "true",
//   //       "audio.audioRecord.keep.audiosession.active": "true",
//   //       "audio.capture.prevent.system.suspend": "true"
//   //     },
//   //   ));
//
//   //   // Callback for updates on the status of other users in the room.
//   //   ZegoExpressEngine.onRoomUserUpdate =
//   //       (roomID, updateType, List<ZegoUser> userList) {
//   //     debugPrint(
//   //         'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
//   //   };
//
//   //   // Listen for remote user's microphone state changes
//   //   ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
//   //     debugPrint(
//   //         'onRemoteMicStateUpdate streamID: $streamID, state: ${state.name}');
//
//   //     // Always ensure audio processing continues
//   //     ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
//   //     // When in background, some devices might disable the mic - force re-enable it
//   //     if (state == ZegoRemoteDeviceState.InBackground) {
//   //       debugPrint(
//   //           'Remote user went to background - ensuring microphone stays active');
//   //       // Force re-enable our microphone if not muted by user
//   //       final currentState = this.state as HasCall;
//   //       if (!currentState.isMute) {
//   //         ZegoExpressEngine.instance.muteMicrophone(false);
//   //       }
//   //     }
//   //   };
//
//   //   // Callback for updates on the status of the streams in the room.
//   //   ZegoExpressEngine.onRoomStreamUpdate =
//   //       (roomID, updateType, List<ZegoStream> streamList, extendedData) {
//   //     debugPrint(
//   //         'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
//
//   //     final hasCallState = state as HasCall;
//   //     if (updateType == ZegoUpdateType.Add) {
//   //       for (final stream in streamList) {
//   //         _remoteStreamID = stream.streamID;
//   //         startZegoPlayStream(stream.streamID);
//   //         // Initialize remote video as enabled when stream is added and call type is video
//   //         final isVideo = hasCallState.callData.callType == CallType.video.name;
//   //         emit(hasCallState.copyWith(isRemoteVideoEnabled: isVideo));
//   //       }
//   //     } else {
//   //       for (final stream in streamList) {
//   //         if (stream.streamID == _remoteStreamID) {
//   //           _remoteStreamID = null;
//   //           stopZegoPlayStream(stream.streamID);
//   //           emit(hasCallState.copyWith(
//   //               isRemoteVideoEnabled: false, remoteView: const SizedBox()));
//   //         }
//   //       }
//   //     }
//   //   };
//
//   //   // Listen for remote user's camera state changes
//   //   ZegoExpressEngine.onRemotestateUpdate = (streamID, state) {
//   //     if (streamID == _remoteStreamID) {
//   //       final hasCallState = this.state as HasCall;
//   //       final bool isRemoteVideoEnabled = state == ZegoRemoteDeviceState.Open;
//   //       if (isRemoteVideoEnabled) {
//   //         startZegoPlayStream(streamID);
//   //       } else {
//   //         // If remote camera is turned off, update UI but don't stop the stream
//   //         emit(hasCallState.copyWith(
//   //           isRemoteVideoEnabled: false,
//   //         ));
//   //       }
//   //     }
//   //   };
//
//   //   // Callback for updates on the current user's room connection status.
//   //   ZegoExpressEngine.onRoomStateUpdate =
//   //       (roomID, state, errorCode, extendedData) {
//   //     debugPrint(
//   //         'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//   //   };
//
//   //   // Callback for updates on the current user's stream publishing changes.
//   //   ZegoExpressEngine.onPublisherStateUpdate =
//   //       (streamID, state, errorCode, extendedData) {
//   //     print("local video is opened here");
//   //     if (hasCallState.isVideoEnabled) {
//   //       emit(hasCallState.copyWith(
//   //           isVideoEnabled: state == ZegoPublisherState.Publishing));
//   //     }
//
//   //     debugPrint(
//   //         'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
//   //   };
//   // }
//
//   // Add a much more aggressive method to handle when app goes to background
//   // Future<void> handleAppBackground() async {
//   //   if (state is HasCall) {
//   //     final hasCallState = state as HasCall;
//   //     if (hasCallState.isZegoCloud) {
//   //       print(
//   //           'Handling app going to background - ensuring microphone stays active');
//
//   //       // Force enable audio capture device
//   //       ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
//   //       // Use a more moderate volume that won't distort but is clearly audible
//   //       ZegoExpressEngine.instance.setCaptureVolume(80);
//
//   //       // Ensure microphone is unmuted (unless user specifically muted it)
//   //       if (!hasCallState.isMute) {
//   //         ZegoExpressEngine.instance.muteMicrophone(false);
//   //       }
//
//   //       // Complete restart of the audio subsystem to reset any potential issues
//   //       ZegoExpressEngine.instance.enableAudioCaptureDevice(false);
//   //       await Future.delayed(const Duration(milliseconds: 100));
//   //       ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
//   //       // Specific configuration for voice calls in background
//   //       ZegoExpressEngine.instance.setAudioConfig(ZegoAudioConfig(
//   //         16000, // Lower bitrate for stability in background
//   //         ZegoAudioChannel.Mono,
//   //         ZegoAudioCodecID.Default,
//   //       ));
//
//   //       // More comprehensive engine config specifically designed for background operation
//   //       ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
//   //         advancedConfig: {
//   //           "audio.captureAndRender.continuousInBackgroundMode": "true",
//   //           "audio.record.keep.awake": "true",
//   //           "audio.keep.background.connection": "true",
//   //           "audio.capture.force_using_media_recorder": "true",
//   //           "audio.capture.nodata.protection":
//   //               "false", // Disable no-data protection which might cut audio
//   //           "audio.audioRecord.mode.lowLatency": "true",
//   //           "audio.audioRecord.background.mild.processor": "true",
//   //           "audio.audioRecord.keep.audiosession.active": "true",
//   //           "audio.enableIOSHeadphoneMonitor": "true",
//   //           "audio.handle.systemAVAudioSession":
//   //               "true", // Let the SDK handle audio session
//   //           "audio.mediaPlay.use.error.callback.protection": "true",
//   //           "audio.player.enableRecoveryFromError": "true",
//   //           "android.audio.session.alwaysOn":
//   //               "true", // Critical for Android background audio
//   //           "android.audio.process.priority": "high",
//   //         },
//   //       ));
//
//   //       // Stop and restart publishing stream to refresh connection
//   //       await stopZegoPublish();
//
//   //       // Short delay before re-publishing
//   //       await Future.delayed(const Duration(milliseconds: 200));
//
//   //       try {
//   //         // Use a consistent stream ID when re-publishing
//   //         final userName =
//   //             hasCallState.callData.receiverName ?? "user_background";
//   //         await startZegoPublish(
//   //             roomId: hasCallState.callData.zegoRoomId, userName: userName);
//
//   //         print('Successfully restarted audio stream in background');
//
//   //         // Force audio route to ensure proper audio path
//   //         ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
//   //       } catch (e) {
//   //         print('Error restarting publish in background: $e');
//   //       }
//   //     }
//   //   }
//   // }
//
//   Future<void> handleAppBackground() async {
//     if (state is HasCall) {
//       final hasCallState = state as HasCall;
//       if (hasCallState.isZegoCloud) {
//         LoggingService.info('Handling app going to background - ensuring audio continues');
//
//         // Force enable audio capture device
//         await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
//         // Ensure microphone is unmuted (unless user specifically muted it)
//         if (!hasCallState.isMute) {
//           await ZegoExpressEngine.instance.muteMicrophone(false);
//         }
//
//         // Set moderate volume
//         await ZegoExpressEngine.instance.setCaptureVolume(80);
//
//         // Re-publish stream to ensure connection
//         final userId = hasCallState.callData.receiverName;
//         final streamID = '${hasCallState.callData.zegoRoomId}_${userId}_call';
//         await ZegoExpressEngine.instance.startPublishingStream(streamID);
//
//         LoggingService.info("Background audio configuration completed");
//       }
//     }
//   }
//
//   void stopZegoListenEvent() {
//     ZegoExpressEngine.onRoomUserUpdate = null;
//     ZegoExpressEngine.onRoomStreamUpdate = null;
//     ZegoExpressEngine.onRoomStateUpdate = null;
//     ZegoExpressEngine.onPublisherStateUpdate = null;
//     ZegoExpressEngine.onRemoteCameraStateUpdate = null;
//     ZegoExpressEngine.onRemoteMicStateUpdate = null;
//
//     // Clear video event handlers
//     ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = null;
//     ZegoExpressEngine.onPublisherRenderVideoFirstFrame = null;
//     ZegoExpressEngine.onPlayerRecvVideoFirstFrame = null;
//     ZegoExpressEngine.onPlayerRenderVideoFirstFrame = null;
//     ZegoExpressEngine.onPublisherVideoSizeChanged = null;
//     ZegoExpressEngine.onPlayerVideoSizeChanged = null;
//   }
//
//   // Future<ZegoRoomLoginResult> loginZegoRoom({
//   //   required String roomId,
//   //   required String userID,
//   //   required String userName,
//   // }) async {
//   //   final hasCallState = state as HasCall;
//   //   print(
//   //       'Tried to login for user Id is $userID, user name is $userName and room id is $roomId');
//
//   //   // The value of `userID` is generated locally and must be globally unique.
//   //   final user = ZegoUser(userID, userName);
//   //   final roomID = roomId;
//
//   //   // Configure ZegoCloud for background audio before logging in
//   //   ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
//   //     advancedConfig: {
//   //       "audio.capture.force_using_media_recorder": "true",
//   //       "audio.captureAndRender.androidLowLatencyEnabled": "true",
//   //       "background.mode.enabled": "true",
//   //       "audio.process.continue.in.background": "true",
//   //       "audio.audioRecord.bluetooth_disable_aec": "true",
//   //       "audio.audioRecord.disable_aes": "true",
//   //       "audio.process.keep.frequently.acquired": "true",
//   //       "audio.audioRecord.keep.audiosession.active": "true",
//   //       "audio.capture.prevent.system.suspend": "true"
//   //     },
//   //   ));
//
//   //   // Optimize for background mode - use StandardQuality for voice calls
//   //   ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//   //   ZegoExpressEngine.instance.setAudioConfig(
//   //       ZegoAudioConfig.preset(ZegoAudioConfigPreset.StandardQuality));
//
//   //   // onRoomUserUpdate callback can be received when "isUserStatusNotify" parameter value is "true".
//   //   ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()
//   //     ..isUserStatusNotify = true;
//
//   //   final shouldEnableVideo =
//   //       hasCallState.callData.callType == CallType.video.name;
//
//   //   // log in to a room
//   //   return ZegoExpressEngine.instance
//   //       .loginRoom(roomID, user, config: roomConfig)
//   //       .then((ZegoRoomLoginResult loginRoomResult) {
//   //     if (loginRoomResult.errorCode == 0) {
//   //       ZegoExpressEngine.instance.muteMicrophone(false);
//
//   //       if (shouldEnableVideo) {
//   //         // Ensure video is enabled
//   //         ZegoExpressEngine.instance.mutePublishStreamVideo(false);
//   //         startZegoPreview(isVideoEnabled: true);
//   //       } else {
//   //         // Ensure video is disabled
//   //         ZegoExpressEngine.instance.mutePublishStreamVideo(true);
//   //       }
//
//   //       // Start publishing with appropriate stream ID
//   //       startZegoPublish(roomId: roomId, userName: userName);
//
//   //       // Update state to reflect initial video state
//   //       emit(hasCallState.copyWith(isVideoEnabled: shouldEnableVideo));
//   //     } else {
//   //       print('loginRoom failed: ${loginRoomResult.errorCode}');
//   //     }
//   //     return loginRoomResult;
//   //   });
//   // }
//
//   Future<ZegoRoomLoginResult> loginZegoRoom({
//     required String roomId,
//     required String userID,
//     required String userName,
//   }) async {
//     final hasCallState = state as HasCall;
//     print('Logging in user: $userID, userName: $userName, roomId: $roomId');    try {
//       // STEP 1: Configure audio settings FIRST
//       await _configureZegoAudioSettings();
//
//       // STEP 2: Start event listeners
//       startZegoListenEvent();
//
//       // STEP 3: Add call establishment timeout (30 seconds)
//       Timer(Duration(seconds: 30), () {
//         if (state is HasCall) {
//           final currentState = state as HasCall;
//           if (!currentState.isCallConnected) {
//             LoggingService.warning("Call establishment timeout - ending call");
//             serviceLocator<CallWithNotificationHelper>().sendActionNotification(
//               currentState.callData,
//               CallActions.callEnded,
//               reason: 'call establishment timeout',
//             );
//             endCall();
//           }
//         }
//       });
//
//       // STEP 4: Create user and room config
//       final user = ZegoUser(userID, userName);
//       final roomConfig = ZegoRoomConfig(2, true, '');
//
//       // STEP 4: Login to room
//       final result = await ZegoExpressEngine.instance
//           .loginRoom(roomId, user, config: roomConfig);
//       print("Room login result: ${result.errorCode}");
//
//       if (result.errorCode == 0) {
//         print("Successfully logged into room");
//
//         // STEP 5: Force enable audio after login
//         await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//         await ZegoExpressEngine.instance.muteMicrophone(false);
//
//         // STEP 6: Wait for stable connection before initializing video
//         await Future.delayed(Duration(milliseconds: 500));
//
//         // STEP 7: Start publishing with audio enabled
//         await startZegoPublish(roomId: roomId, userName: userID);
//
//         // STEP 8: Initialize video with proper timing if needed
//         if (hasCallState.callData.callType == CallType.video.name) {
//           // Wait a bit more for stream to be established before video
//           await Future.delayed(Duration(milliseconds: 200));
//           await startZegoPreview(isVideoEnabled: true);
//         }
//
//         print("Room setup completed");
//       } else {
//         print("Failed to join room: ${result.errorCode}");
//         endCall();
//       }
//
//       return result;
//     } catch (e) {
//       print("Error in loginZegoRoom: $e");
//       endCall();
//       rethrow;
//     }
//   }
//
//   Future<ZegoRoomLogoutResult> logoutZegoRoom({required String roomId}) async {
//     print('logoutRoom : $roomId');
//     stopZegoPreview();
//     stopZegoPublish();
//     stopZegoListenEvent();
//     return ZegoExpressEngine.instance.logoutRoom(roomId);
//   }
//
//   Future<void> startZegoPreview({bool isVideoEnabled = true}) async {
//     try {
//       LoggingService.info("Starting Zego preview with video: $isVideoEnabled");
//       final hasCallState = state as HasCall;
//
//       // Clean up existing preview if needed
//       if (localViewID != null) {
//         await stopZegoPreview();
//         localViewID = null;
//         LoggingService.info("✓ Existing preview cleaned up");
//       }
//
//       // IMPROVED: Use the VideoFixHelper for reliable canvas management
//       LoggingService.info("🏗️ Creating canvas view with reliable widget capture...");
//
//       // Call the helper method which manages the entire process
//       final Widget? canvasWidget = await VideoFixHelper.startPreviewWithReliableCanvas(
//         isVideoEnabled: isVideoEnabled
//       );
//
//       // IMPROVED: Canvas setup quality check
//       if (isVideoEnabled && canvasWidget != null) {
//         LoggingService.info("🔄 Updating state with reliable canvas widget for video...");
//         emit(hasCallState.copyWith(
//           localView: canvasWidget,
//           isVideoEnabled: true
//         ));
//         LoggingService.info("✅ Local video state emitted - video should be visible in UI");
//
//         // Ensure state is fully applied by waiting and emitting again
//         await Future.delayed(const Duration(milliseconds: 50));
//         emit(hasCallState.copyWith(
//           localView: canvasWidget,
//           isVideoEnabled: true
//         ));
//       } else if (isVideoEnabled && canvasWidget == null) {
//         LoggingService.warning("⚠️ Video enabled but canvas widget is null - using placeholder");
//         emit(hasCallState.copyWith(
//           localView: Container(
//             color: Colors.black,
//             child: const Center(
//               child: Text('Camera not available - tap to retry', style: TextStyle(color: Colors.white)),
//             ),
//           ),
//           isVideoEnabled: true
//         ));
//       } else {
//         LoggingService.info("🔄 Updating state for audio-only...");
//         emit(hasCallState.copyWith(
//           localView: const SizedBox(),
//           isVideoEnabled: false
//         ));
//         LoggingService.info("✅ Local audio-only state emitted");
//       }
//
//     } catch (e) {
//       LoggingService.error("❌ CRITICAL ERROR in startZegoPreview", error: e);
//       LoggingService.error("❌ Stack trace: ${e.toString()}");
//
//       // Ensure state is reverted on error
//       final hasCallState = state as HasCall;
//       emit(hasCallState.copyWith(
//         localView: const SizedBox(),
//         isVideoEnabled: false
//       ));
//
//       rethrow;
//     }
//   }
//
//   Future<void> stopZegoPreview() async {
//     try {
//       LoggingService.info("Stopping Zego preview with proper cleanup");
//
//       // STEP 1: Stop preview first to prevent new frames
//       await ZegoExpressEngine.instance.stopPreview();
//       LoggingService.info("✓ Preview stopped");
//
//       // STEP 2: Disable camera to stop capture
//       await ZegoExpressEngine.instance.enableCamera(false);
//       LoggingService.info("✓ Camera disabled");
//
//       // STEP 3: Clean up canvas view
//       if (localViewID != null) {
//         await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
//         LoggingService.info("✓ Canvas view destroyed: $localViewID");
//         localViewID = null;
//       }
//
//       // STEP 4: Clear first frame callbacks to prevent race conditions
//       ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = null;
//       ZegoExpressEngine.onPublisherRenderVideoFirstFrame = null;
//
//       // STEP 5: Update state
//       final hasCallState = state as HasCall;
//       emit(hasCallState.copyWith(
//         localView: const SizedBox(),
//         isVideoEnabled: false,
//       ));
//       LoggingService.info("✓ Local preview stopped and state updated");
//     } catch (e) {
//       LoggingService.error("Error stopping preview", error: e);
//     }
//   }
//
//   // Future<void> startZegoPublish(
//   //     {required String roomId, required String userName}) async {
//   //   final hasCallState = state as HasCall;
//   //   // After calling the `loginRoom` method, call this method to publish streams.
//   //   // The StreamID must be unique in the room.
//   //   String streamID = '${roomId}_${userName}_call';
//   //   // Ensure video is not muted when starting to publish
//   //   await ZegoExpressEngine.instance
//   //       .mutePublishStreamVideo(!hasCallState.isVideoEnabled);
//   //   return ZegoExpressEngine.instance.startPublishingStream(streamID);
//   // }
//
//   Future<void> startZegoPublish(
//       {required String roomId, required String userName}) async {
//     final hasCallState = state as HasCall;
//
//     // Use simple, consistent stream ID
//     String streamID = '${roomId}_$userName';
//     LoggingService.info("Publishing stream with ID: $streamID");
//
//     try {
//       // STEP 1: Enable audio capture FIRST
//       await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//       LoggingService.info("Audio capture device enabled");
//
//       // STEP 2: Ensure microphone is NOT muted
//       await ZegoExpressEngine.instance.muteMicrophone(false);
//       LoggingService.info("Microphone unmuted");
//
//       // STEP 3: Set optimal capture volume
//       await ZegoExpressEngine.instance.setCaptureVolume(100);
//       LoggingService.info("Capture volume set to 100");
//
//       // STEP 4: Configure video state (but don't touch audio)
//       await ZegoExpressEngine.instance
//           .mutePublishStreamVideo(!hasCallState.isVideoEnabled);
//       LoggingService.info("Video state configured: ${hasCallState.isVideoEnabled}");
//
//       // STEP 5: Start publishing stream
//       await ZegoExpressEngine.instance.startPublishingStream(streamID);
//       LoggingService.info("Stream publishing started");
//
//       // STEP 6: CRITICAL - Wait a moment then explicitly ensure audio is NOT muted on the stream
//       await Future.delayed(const Duration(milliseconds: 500));
//       await ZegoExpressEngine.instance.mutePublishStreamAudio(false);
//       LoggingService.info("Stream audio explicitly unmuted");
//
//       // STEP 7: Force unmute microphone again to ensure audio path
//       await ZegoExpressEngine.instance.muteMicrophone(false);
//       LoggingService.info("Microphone force unmuted");
//
//       // STEP 8: Apply user's actual mute state ONLY if they intentionally muted
//       if (hasCallState.isMute) {
//         await ZegoExpressEngine.instance.muteMicrophone(true);
//         LoggingService.info("Applied user mute state");
//       }
//
//       LoggingService.info("Publishing setup completed successfully");
//     } catch (e) {
//       LoggingService.error("ERROR in startZegoPublish", error: e);
//     }
//   }
//
//   Future<void> stopZegoPublish() async {
//     return ZegoExpressEngine.instance.stopPublishingStream();
//   }
//
//   // Future<void> startZegoPlayStream(String streamID) async {
//   //   final hasCallState = state as HasCall;
//   //   try {
//   //     // Clean up existing remote view if needed
//   //     if (remoteViewID != null) {
//   //       await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
//   //       remoteViewID = null;
//   //     }
//
//   //     // Create canvas view for remote stream
//   //     await ZegoExpressEngine.instance.createCanvasView((viewID) {
//   //       remoteViewID = viewID;
//   //       ZegoCanvas canvas = ZegoCanvas(
//   //         viewID,
//   //         viewMode: ZegoViewMode.AspectFill,
//   //       );
//   //       ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
//   //     }).then((canvasViewWidget) {
//   //       emit(hasCallState.copyWith(
//   //         remoteView: canvasViewWidget,
//   //         isRemoteVideoEnabled:
//   //             hasCallState.callData.callType == CallType.video.name,
//   //       ));
//   //     });
//   //   } catch (e) {
//   //     print("Error in startZegoPlayStream: $e");
//   //   }
//   // }
//
//   // Future<void> startZegoPlayStream(String streamID) async {
//   //   final hasCallState = state as HasCall;
//   //   try {
//   //     print("Starting to play remote stream: $streamID");
//
//   //     // Clean up existing remote view if needed
//   //     if (remoteViewID != null) {
//   //       await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
//   //       remoteViewID = null;
//   //     }
//
//   //     // For audio calls, we still need to play the stream even without video
//   //     if (hasCallState.callData.callType == CallType.audio.name) {
//   //       // For audio calls, just start playing the stream without video canvas
//   //       await ZegoExpressEngine.instance.startPlayingStream(streamID);
//   //       print("Started playing audio stream: $streamID");
//
//   //       // Update state to indicate remote user is connected
//   //       emit(hasCallState.copyWith(
//   //         isRemoteVideoEnabled: false,
//   //         remoteView: const SizedBox(),
//   //       ));
//   //     } else {
//   //       // For video calls, create canvas view
//   //       await ZegoExpressEngine.instance.createCanvasView((viewID) {
//   //         remoteViewID = viewID;
//   //         ZegoCanvas canvas = ZegoCanvas(
//   //           viewID,
//   //           viewMode: ZegoViewMode.AspectFill,
//   //         );
//   //         ZegoExpressEngine.instance
//   //             .startPlayingStream(streamID, canvas: canvas);
//   //       }).then((canvasViewWidget) {
//   //         emit(hasCallState.copyWith(
//   //           remoteView: canvasViewWidget,
//   //           isRemoteVideoEnabled: true,
//   //         ));
//   //       });
//   //     }
//
//   //     // Force enable audio playback
//   //     await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
//   //   } catch (e) {
//   //     print("Error in startZegoPlayStream: $e");
//   //   }
//   // }
//
//   Future<void> startZegoPlayStream(String streamID) async {
//     final hasCallState = state as HasCall;
//     try {
//       LoggingService.info("Starting to play remote stream: $streamID");
//
//       // Clean up existing remote view if needed
//       if (remoteViewID != null) {
//         await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
//         remoteViewID = null;
//         LoggingService.info("Previous remote canvas view destroyed");
//       }
//
//       // For audio calls, simply play the stream
//       if (hasCallState.callData.callType == CallType.audio.name) {
//         // Start playing audio-only stream
//         await ZegoExpressEngine.instance.startPlayingStream(streamID);
//         LoggingService.info("Audio-only stream started: $streamID");
//
//         // Force enable audio playback
//         await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
//         await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
//
//         // Update state for audio call
//         emit(hasCallState.copyWith(
//           isRemoteVideoEnabled: false,
//           remoteView: const SizedBox(),
//           isCallConnected: true,
//         ));
//         LoggingService.info("Audio call UI updated - call connected");
//         return;
//       }
//
//       // For video calls, use our VideoFixHelper for more reliable remote video
//       LoggingService.info("Creating remote video canvas using VideoFixHelper...");
//
//       try {
//         // Using VideoFixHelper for reliable remote video handling
//         final Widget? canvasWidget = await VideoFixHelper.startPlayStreamWithReliableCanvas(streamID);
//
//         // Handle the nullable Widget
//         final Widget actualWidget = canvasWidget ?? Container(
//           color: Colors.black,
//           child: const Center(
//             child: Text('Remote video unavailable', style: TextStyle(color: Colors.white)),
//           ),
//         );
//
//         // Force enable audio playback
//         await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
//         await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
//
//         LoggingService.info("✅ Remote video canvas created successfully");
//
//         // First update state with the canvas widget
//         emit(hasCallState.copyWith(
//           remoteView: actualWidget,
//           isRemoteVideoEnabled: true,
//           isCallConnected: true,
//         ));
//         LoggingService.info("✅ Remote video UI updated with canvas widget");
//
//         // Wait a moment then update the state again to ensure UI refresh
//         await Future.delayed(const Duration(milliseconds: 100));
//         emit(hasCallState.copyWith(
//           remoteView: actualWidget,
//           isRemoteVideoEnabled: true,
//           isCallConnected: true,
//         ));
//         LoggingService.info("✅ Remote video state confirmed with refresh");
//
//       } catch (e) {
//         // Fall back to audio-only on error
//         LoggingService.error("❌ Error creating remote canvas", error: e);
//
//         await ZegoExpressEngine.instance.startPlayingStream(streamID);
//         await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
//
//         emit(hasCallState.copyWith(
//           isRemoteVideoEnabled: false,
//           remoteView: Container(
//             color: Colors.black54,
//             child: Center(child: Text("Video error", style: TextStyle(color: Colors.white))),
//           ),
//           isCallConnected: true,
//         ));
//       }
//         LoggingService.info("Remote stream setup completed for streamID: $streamID");
//     } catch (e) {
//       LoggingService.error("Error in startZegoPlayStream", error: e);
//     }
//   }
//
//   /// Refresh remote video display to ensure proper UI update
//   Future<void> _refreshRemoteVideoDisplay(String streamID) async {
//     try {
//       LoggingService.info("🔄 Refreshing remote video display for stream: $streamID");
//
//       final hasCallState = state as HasCall;
//       if (hasCallState.callData.callType != CallType.video.name) return;
//
//       // Small delay to allow the first frame to fully render
//       await Future.delayed(Duration(milliseconds: 100));
//
//       // Force a UI refresh by emitting the state again
//       emit(hasCallState.copyWith(
//         isRemoteVideoEnabled: true,
//         isCallConnected: true,
//       ));
//
//       LoggingService.info("✅ Remote video display refreshed");
//     } catch (e) {
//       LoggingService.error("❌ Error refreshing remote video display", error: e);
//     }
//   }
//
//   Future<void> stopZegoPlayStream(String streamID) async {
//     try {
//       print("Stopping remote stream: $streamID");
//       await ZegoExpressEngine.instance.stopPlayingStream(streamID);
//
//       if (remoteViewID != null) {
//         await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
//         print("Remote canvas view destroyed: $remoteViewID");
//         remoteViewID = null;
//       }
//
//       final hasCallState = state as HasCall;
//       emit(hasCallState.copyWith(
//         remoteView: const SizedBox(),
//         isRemoteVideoEnabled: false,
//       ));
//       print("Remote stream stopped and UI updated");
//     } catch (e) {
//       print("Error stopping play stream: $e");
//     }
//   }
//
//   void toggleSpeaker() async {
//     if (state is HasCall) {
//       final hasCallState = state as HasCall;
//       if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
//         final engine = hasCallState.engine!;
//         final bool isEnabled = hasCallState.isSpeaker;
//         await engine.setEnableSpeakerphone(!isEnabled);
//         emit(hasCallState.copyWith(isSpeaker: !isEnabled));
//       } else if (hasCallState.isZegoCloud) {
//         final bool isEnabled = hasCallState.isSpeaker;
//         ZegoExpressEngine.instance.setAudioRouteToSpeaker(!isEnabled);
//         emit(hasCallState.copyWith(isSpeaker: !isEnabled));
//       }
//       // For ZegoCloud, speaker control is handled by the UI Kit
//     }
//   }
//
//   void toggleMute() async {
//     if (state is HasCall) {
//       final hasCallState = state as HasCall;
//       if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
//         final engine = hasCallState.engine!;
//         final bool isMuted = hasCallState.isMute;
//         await engine.muteLocalAudioStream(!isMuted);
//         emit(hasCallState.copyWith(isMute: !isMuted));
//       } else if (hasCallState.isZegoCloud) {
//         final bool isMuted = hasCallState.isMute;
//
//         // Toggle microphone state
//         await ZegoExpressEngine.instance.muteMicrophone(!isMuted);
//
//         if (isMuted) {
//           // Was muted, now unmuting - ensure audio is working
//           await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//           await ZegoExpressEngine.instance.setCaptureVolume(100);
//           print("Unmuted and enabled audio capture");
//         } else {
//           print("Muted microphone");
//         }
//
//         emit(hasCallState.copyWith(isMute: !isMuted));
//       }
//     }
//   }
//
//   // void toggleMute() async {
//   //   if (state is HasCall) {
//   //     final hasCallState = state as HasCall;
//   //     if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
//   //       final engine = hasCallState.engine!;
//   //       final bool isMuted = hasCallState.isMute;
//   //       await engine.muteLocalAudioStream(!isMuted);
//   //       emit(hasCallState.copyWith(isMute: !isMuted));
//   //     } else if (hasCallState.isZegoCloud) {
//   //       final bool isMuted = hasCallState.isMute;
//   //       ZegoExpressEngine.instance.muteMicrophone(!isMuted);
//   //       emit(hasCallState.copyWith(isMute: !isMuted));
//   //     }
//   //     // For ZegoCloud, mute control is handled by the UI Kit
//   //   }
//   // }
//
//   // Fixed implementation that combines the best of both approaches
//   void toggleVideo() async {
//     LoggingService.methodCall("CallCubit", "toggleVideo");
//     if (state is HasCall) {
//       final hasCallState = state as HasCall;
//
//       if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
//         // Agora implementation remains the same
//         final engine = hasCallState.engine!;
//         final bool isVideoEnabled = hasCallState.isVideoEnabled;
//
//         await engine.enableVideo();
//         await engine.enableLocalVideo(!isVideoEnabled);
//
//         if (!isVideoEnabled) {
//           await engine.startPreview();
//         } else {
//           await engine.stopPreview();
//         }
//
//         emit(hasCallState.copyWith(isVideoEnabled: !isVideoEnabled));
//       } else if (hasCallState.isZegoCloud) {
//         // IMPROVED: ZegoCloud implementation with better sequencing
//         final bool currentVideoState = hasCallState.isVideoEnabled;
//         final bool newVideoState = !currentVideoState;
//
//         try {
//           LoggingService.info("=== TOGGLING VIDEO: $currentVideoState → $newVideoState ===");
//
//           // STEP 1: Update UI immediately for a responsive feel
//           emit(hasCallState.copyWith(isVideoEnabled: newVideoState));
//           LoggingService.info("UI updated immediately");
//
//           if (newVideoState) {
//             // TURNING VIDEO ON
//
//             // Check permission first
//             final permissionStatus = await Permission.camera.status;
//             if (permissionStatus != PermissionStatus.granted) {
//               LoggingService.warning("❌ Camera permission denied");
//               emit(hasCallState.copyWith(isVideoEnabled: false));
//               return;
//             }
//
//             try {
//               // 1. First enable the camera hardware
//               await ZegoExpressEngine.instance.enableCamera(true);
//               LoggingService.info("Camera hardware enabled");
//
//               // 2. Unmute video publishing
//               await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
//               LoggingService.info("Video publishing unmuted");
//
//               // 3. Set video config
//               await ZegoExpressEngine.instance.setVideoConfig(
//                 ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset360P)
//               );
//               LoggingService.info("Video config set");
//
//               // 4. Start preview with our improved implementation
//               await startZegoPreview(isVideoEnabled: true);
//               LoggingService.info("✅ Video started successfully");
//             } catch (e) {
//               LoggingService.error("❌ Error starting video", error: e);
//
//               // Revert UI on error
//               emit(hasCallState.copyWith(isVideoEnabled: false));
//
//               // Ensure hardware is disabled on error
//               try {
//                 await ZegoExpressEngine.instance.enableCamera(false);
//                 await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
//               } catch (_) {}
//             }
//
//           } else {
//             // TURNING VIDEO OFF
//
//             try {
//               // 1. First mute video publishing to stop sending frames
//               await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
//               LoggingService.info("Video publishing muted");
//
//               // 2. Stop preview
//               await stopZegoPreview();
//               LoggingService.info("Preview stopped");
//
//               // 3. Disable camera hardware last
//               await ZegoExpressEngine.instance.enableCamera(false);
//               LoggingService.info("Camera hardware disabled");
//
//               LoggingService.info("✅ Video stopped successfully");
//             } catch (e) {
//               LoggingService.error("❌ Error stopping video", error: e);
//
//               // We don't revert the UI state here as the user intended to turn off video,
//               // and they'd be confused if the UI showed video as still on
//
//               // Force ensure camera is off
//               try {
//                 await ZegoExpressEngine.instance.enableCamera(false);
//                 await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
//               } catch (_) {}
//             }
//           }
//
//         } catch (e) {
//           LoggingService.error("❌ UNHANDLED ERROR in toggleVideo", error: e);
//
//           // Revert to initial state on catastrophic error
//           emit(hasCallState.copyWith(isVideoEnabled: currentVideoState));
//         }
//       }
//     }
//   }
//
//   /// Checks and fixes video if it's in an inconsistent state
//   Future<void> ensureCorrectVideoState() async {
//     if (state is HasCall) {
//       final hasCallState = state as HasCall;
//       if (!hasCallState.isZegoCloud) return;
//
//       final bool shouldBeEnabled = hasCallState.isVideoEnabled;
//       LoggingService.info("Checking video consistency - should be ${shouldBeEnabled ? 'enabled' : 'disabled'}");
//
//       try {
//         if (shouldBeEnabled) {
//           // Video should be enabled, verify and fix if needed
//           await ZegoExpressEngine.instance.enableCamera(true);
//           await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
//
//           if (localViewID == null) {
//             // Recreate preview if needed
//             await startZegoPreview(isVideoEnabled: true);
//           }
//         } else {
//           // Video should be disabled, verify and fix if needed
//           await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
//           await ZegoExpressEngine.instance.enableCamera(false);
//         }
//       } catch (e) {
//         LoggingService.error("Error ensuring video state", error: e);
//       }
//     }
//   }
//
//   /// Alternative implementation using the video timing manager
//   Future<void> startZegoPreviewWithTimingManager({required bool isVideoEnabled}) async {
//     final hasCallState = state as HasCall;
//
//     try {
//       LoggingService.info("🎬 Starting Zego preview with timing manager - video enabled: $isVideoEnabled");
//
//       // Clean up any existing preview first
//       if (localViewID != null) {
//         await stopZegoPreview();
//         localViewID = null;
//       }
//
//       // Use the timing manager for better synchronization
//       final result = await ZegoVideoTimingManager.instance.initializeVideo(
//         enableVideo: isVideoEnabled,
//         onCanvasCreated: (viewId) {
//           localViewID = viewId;
//           LoggingService.info("📋 Canvas created with ID: $viewId via timing manager");
//         },
//         timeout: Duration(seconds: 10),
//       );
//
//       if (result.success) {
//         LoggingService.info("✅ Video initialization successful via timing manager");
//         LoggingService.info("   Total time: ${result.totalTimeMs}ms");
//         LoggingService.info("   View ID: ${result.viewId}");
//
//         // Update state after successful initialization
//         if (isVideoEnabled) {
//           emit(hasCallState.copyWith(
//             localView: null, // Let the widget rebuild
//             isVideoEnabled: true,
//           ));
//           LoggingService.info("✅ Local video view enabled and emitted");
//         } else {
//           emit(hasCallState.copyWith(
//             localView: const SizedBox(),
//             isVideoEnabled: false,
//           ));
//           LoggingService.info("✅ Local audio-only view enabled");
//         }
//
//       } else {
//         LoggingService.warning("❌ Video initialization failed via timing manager");
//         LoggingService.warning("   Error: ${result.error}");
//         LoggingService.warning("   Error type: ${result.errorType}");
//
//         // Fallback to original implementation
//         LoggingService.info("🔄 Falling back to original implementation...");
//         await startZegoPreview(isVideoEnabled: isVideoEnabled);
//       }
//
//     } catch (e) {
//       LoggingService.error("❌ Error in timing manager implementation", error: e);
//
//       // Fallback to original implementation
//       LoggingService.info("🔄 Falling back to original implementation...");
//       await startZegoPreview(isVideoEnabled: isVideoEnabled);
//     }
//   }
//
//   // DIAGNOSTIC METHODS for timing and race condition debugging
//
//   /// Validates the current state of video initialization sequence
//   Future<Map<String, dynamic>> validateVideoState() async {
//     final hasCallState = state as HasCall;
//     final diagnostics = <String, dynamic>{};
//
//     try {
//       // Check camera state - ZegoCloud doesn't have direct camera state query
//       // We'll use our local state tracking instead
//       diagnostics['cameraEnabled'] = hasCallState.isVideoEnabled;
//
//       // Check if preview is running (we can't directly query this, but check view state)
//       diagnostics['localViewID'] = localViewID;
//       diagnostics['hasLocalView'] = localViewID != null;
//
//       // Check video publishing state
//       diagnostics['isVideoEnabled'] = hasCallState.isVideoEnabled;
//       diagnostics['isRemoteVideoEnabled'] = hasCallState.isRemoteVideoEnabled;
//
//       // Check call type
//       diagnostics['callType'] = hasCallState.callData.callType;
//       diagnostics['isVideoCall'] = hasCallState.callData.callType == CallType.video.name;
//
//       // Check room state
//       diagnostics['isZegoCloud'] = hasCallState.isZegoCloud;
//       diagnostics['roomId'] = hasCallState.callData.zegoRoomId;
//
//       print("📊 Video State Diagnostics: $diagnostics");
//       return diagnostics;
//
//     } catch (e) {
//       diagnostics['error'] = e.toString();
//       print("❌ Error in video state validation: $e");
//       return diagnostics;
//     }
//   }
//
//   /// Forces video re-initialization with improved timing
//   Future<void> forceVideoReinitialization() async {
//     final hasCallState = state as HasCall;
//
//     if (!hasCallState.isZegoCloud || hasCallState.callData.callType != CallType.video.name) {
//       print("❌ Not a ZegoCloud video call, skipping re-initialization");
//       return;
//     }
//
//     try {
//       print("🔄 Starting forced video re-initialization...");
//
//       // STEP 1: Stop everything cleanly
//       await stopZegoPreview();
//       await Future.delayed(Duration(milliseconds: 300));
//
//       // STEP 2: Clear any hanging callbacks
//       ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = null;
//       ZegoExpressEngine.onPublisherRenderVideoFirstFrame = null;
//
//       // STEP 3: Re-setup event handlers
//       startZegoListenEvent();
//
//       // STEP 4: Restart video with proper timing
//       await Future.delayed(Duration(milliseconds: 200));
//       await startZegoPreview(isVideoEnabled: true);
//
//       print("✅ Video re-initialization completed");
//
//     } catch (e) {
//       print("❌ Error during video re-initialization: $e");
//     }
//   }
//
//   /// Checks if video timing issues are occurring
//   Future<bool> detectVideoTimingIssues() async {
//     final diagnostics = await validateVideoState();
//
//     // Check for common timing issue patterns
//     final hasTimingIssues =
//       (diagnostics['isVideoCall'] == true &&
//        diagnostics['cameraEnabled'] == true &&
//        diagnostics['hasLocalView'] == false) ||
//       (diagnostics['isVideoEnabled'] == true &&
//        diagnostics['localViewID'] == null) ||
//       (diagnostics['callType'] == CallType.video.name &&
//        diagnostics['cameraEnabled'] == false);
//
//     if (hasTimingIssues) {
//       print("⚠️ Video timing issues detected! Diagnostics: $diagnostics");
//       return true;
//     }
//
//     return false;
//   }
//
//   /// Simple, reliable implementation of video toggle that uses VideoFixHelper
//   /// This is the preferred method to use from UI components
//   void toggleVideoSimple() async {
//     LoggingService.methodCall("CallCubit", "toggleVideoSimple");
//
//     if (state is HasCall) {
//       final hasCallState = state as HasCall;
//
//       if (!hasCallState.isZegoCloud) {
//         // Fall back to original implementation for non-ZegoCloud
//         toggleVideo();
//         return;
//       }
//
//       try {
//         final bool currentState = hasCallState.isVideoEnabled;
//         LoggingService.info("🎬 Simple video toggle: $currentState → ${!currentState}");
//
//         // Use the reliable implementation from VideoFixHelper
//         final success = await VideoFixHelper.toggleVideo(
//           currentlyEnabled: currentState,
//           onStateChanged: (newState) {
//             // This callback is called immediately to update UI
//             emit(hasCallState.copyWith(isVideoEnabled: newState));
//             LoggingService.info("✅ UI state updated immediately to: $newState");
//           }
//         );
//
//         if (success) {
//           LoggingService.info("✅ Video toggle completed successfully");
//
//           // After successful toggle, update preview if needed
//           if (!currentState) {  // If turning ON
//             // Small delay to ensure state changes are synchronized
//             await Future.delayed(Duration(milliseconds: 100));
//
//             final Widget? canvasWidget = await VideoFixHelper.startPreviewWithReliableCanvas(
//               isVideoEnabled: true
//             );
//
//             if (canvasWidget != null) {
//               emit(hasCallState.copyWith(
//                 localView: canvasWidget,
//                 isVideoEnabled: true
//               ));
//               LoggingService.info("✅ Local view updated with new canvas");
//             } else {
//               // Fallback to empty widget if canvas creation failed
//               emit(hasCallState.copyWith(
//                 localView: const SizedBox(),
//                 isVideoEnabled: false
//               ));
//               LoggingService.warning("⚠️ Canvas widget is null, falling back to empty view");
//             }
//           }
//         } else {
//           LoggingService.warning("⚠️ Video toggle operation failed");
//
//           // Ensure UI matches actual camera state
//           await ensureCorrectVideoState();
//         }
//
//       } catch (e) {
//         LoggingService.error("❌ Error in toggleVideoSimple", error: e);
//
//         // Fall back to old implementation on error
//         LoggingService.info("🔄 Falling back to original implementation");
//         toggleVideo();
//       }
//     }
//   }
//
//   /// Manually refreshes the remote video stream when user reports problems
//   Future<void> manualRefreshRemoteVideo() async {
//     if (state is! HasCall || _remoteStreamID == null) {
//       LoggingService.warning("Cannot refresh remote video - no active call or stream");
//       return;
//     }
//
//     final hasCallState = state as HasCall;
//     final streamID = _remoteStreamID!;
//     final isVideoCall = hasCallState.callData.callType == CallType.video.name;
//
//     if (!isVideoCall) {
//       LoggingService.info("Not a video call - nothing to refresh");
//       return;
//     }
//
//     try {
//       LoggingService.info("🔄 Manual refresh of remote video requested");
//
//       // First show loading indicator
//       emit(hasCallState.copyWith(
//         remoteView: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(color: Colors.white),
//               SizedBox(height: 16),
//               Text("Refreshing video...", style: TextStyle(color: Colors.white))
//             ],
//           ),
//         ),
//       ));
//
//       // Step 1: Stop existing stream playback
//       await ZegoExpressEngine.instance.stopPlayingStream(streamID);
//       LoggingService.info("✅ Previous stream stopped");
//
//       // Step 2: Short delay for system to clean up resources
//       await Future.delayed(Duration(milliseconds: 300));
//
//       // Step 3: Start playing stream again with canvas
//       if (remoteViewID != null) {
//         await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
//         remoteViewID = null;
//       }
//
//       // Step 4: Create new canvas view
//       final Widget? canvasWidget = await ZegoExpressEngine.instance.createCanvasView((viewID) {
//         remoteViewID = viewID;
//
//         // Create canvas with view mode that preserves aspect ratio
//         final canvas = ZegoCanvas(
//           viewID,
//           viewMode: ZegoViewMode.AspectFill,
//         );
//
//         // Start playing the stream
//         ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
//         LoggingService.info("✅ Remote stream playback restarted");
//       });
//
//       // Step 5: Update UI with new canvas if available
//       if (canvasWidget != null) {
//         emit(hasCallState.copyWith(
//           remoteView: canvasWidget,
//           isRemoteVideoEnabled: true,
//         ));
//         LoggingService.info("✅ Remote video UI refreshed successfully");
//       } else {
//         // Fallback UI if canvas creation failed
//         emit(hasCallState.copyWith(
//           remoteView: Container(
//             color: Colors.black54,
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.error_outline, color: Colors.white, size: 48),
//                   SizedBox(height: 12),
//                   Text("Could not refresh video", style: TextStyle(color: Colors.white)),
//                   SizedBox(height: 8),
//                   Text("Try again later", style: TextStyle(color: Colors.white70, fontSize: 12)),
//                 ],
//               ),
//             ),
//           ),
//           isRemoteVideoEnabled: false,
//         ));
//         LoggingService.error("❌ Failed to create canvas for remote video");
//       }
//
//       // Step 6: Ensure audio is always working regardless of video state
//       await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
//
//     } catch (e) {
//       LoggingService.error("❌ Error refreshing remote video", error: e);
//
//       // Update UI with error state
//       emit(hasCallState.copyWith(
//         remoteView: Container(
//           color: Colors.black54,
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
//                 SizedBox(height: 12),
//                 Text("Video refresh failed", style: TextStyle(color: Colors.white)),
//                 SizedBox(height: 8),
//                 Text("Error: ${e.toString().substring(0, min(e.toString().length, 50))}",
//                   style: TextStyle(color: Colors.white70, fontSize: 12)),
//               ],
//             ),
//           ),
//         ),
//         isRemoteVideoEnabled: false,
//       ));
//
//       // Try to recover audio at least
//       try {
//         await ZegoExpressEngine.instance.startPlayingStream(streamID);
//         await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
//       } catch (_) {}
//     }
//   }
// }
//
//
// // import 'dart:convert';
// // import 'dart:async';
// // import 'dart:math';
//
// // import 'package:flutter/material.dart';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
// // import 'package:fourtyninehub/core/utils/logging_service.dart';
// // import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
// // import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
// // import 'package:fourtyninehub/features/call/services/call_timer_service.dart';
// // import 'package:fourtyninehub/features/call/services/video_fix_helper.dart';
// // import 'package:fourtyninehub/features/call/services/zego_video_timing_manager.dart';
// // import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_with_notification_helper.dart';
// // import 'package:fourtyninehub/res/style/const.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:zego_express_engine/zego_express_engine.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:fourtyninehub/features/call/services/video_fix_helper.dart';
//
// // class CallCubit extends Cubit<CallState> {
// //   CallCubit() : super(NoCalls());
//
// //   int? remoteViewID;
// //   int? localViewID;
// //   String? _remoteStreamID;
// //   static bool _isEngineInitialized = false;
//
// //   static Future<void> initializeZegoEngine() async {
// //     if (_isEngineInitialized) return;
//
// //     try {
// //       await ZegoExpressEngine.destroyEngine();
// //     } catch (e) {
// //       // Engine might not exist
// //       LoggingService.warning("Error destroying previous ZegoCloud engine: $e");
// //     }
//
// //     await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
// //       UIConst.zegoAppId,
// //       ZegoScenario.General, // Use General scenario instead of deprecated Communication
// //       appSign: UIConst.zegoAppSign,
// //       enablePlatformView: true,
// //     ));
//
// //     _isEngineInitialized = true;
// //     LoggingService.info("ZegoCloud engine initialized successfully");
// //   }
//
// //   static Future<void> destroyZegoEngine() async {
// //     if (!_isEngineInitialized) return;
//
// //     try {
// //       await ZegoExpressEngine.destroyEngine();
// //       _isEngineInitialized = false;
// //       LoggingService.info("ZegoCloud engine destroyed successfully");
// //     } catch (e) {
// //       LoggingService.error("Error destroying ZegoCloud engine", error: e);
// //     }
// //   }
//
// //   void checkIfThereIsCall() async {
// //     await serviceLocator<SharedPreferences>().reload();
// //     final storedCall =
// //         serviceLocator<SharedPreferences>().getString('call_data');
// //     LoggingService.debug('stored call: $storedCall');
// //     if (storedCall != null) {
// //       LoggingService.debug('stored call if not equal null: $storedCall');
//
// //       final data = json.decode(storedCall.toString());
// //       final callData = CallData.fromMap(data, false);
// //       serviceLocator<CallWithNotificationHelper>()
// //           .connectToCall(callData, false, isFromCheckIfThereIsACall: true);
// //       startCall(callData, true);
// //     }
// //   }
//
// //   Future startCall(CallData callData, bool isFromCheckComingCall) async {
// //     LoggingService.methodCall("CallCubit", "startCall");
// //     CallTimerService().resetTimer();
// //     if (callData.isRealCall == true.toString()) {
// //       LoggingService.info("Starting call");
// //       // Request permissions first
// //       final micStatus = await Permission.microphone.request();
// //       if (micStatus == PermissionStatus.denied ||
// //           micStatus == PermissionStatus.permanentlyDenied) {
// //         LoggingService.warning("Calling ended because of mic permission");
// //         endCall();
// //         return;
// //       }
//
// //       if (callData.callType == CallType.video.name) {
// //         final camStatus = await Permission.camera.request();
// //         if (camStatus == PermissionStatus.denied ||
// //             camStatus == PermissionStatus.permanentlyDenied) {
// //           LoggingService.warning("Calling ended because of camera permission");
// //           endCall();
// //           return;
// //         }
// //       }
//
// //       if (callData.serviceType == "agora") {
// //         LoggingService.info("Engine initialized");
// //         final engine = await _initializeEngine(callData);
// //         LoggingService.debug('Engine initialized: $engine');
// //         if (engine == null) return;
// //         emit(HasCall(
// //           engine: engine,
// //           callData: callData,
// //           isMute: false,
// //           isSpeaker: false,
// //           isVideoEnabled: callData.callType == CallType.video.name,
// //         ));
// //       } else if (callData.serviceType == "zegocloud") {
// //         LoggingService.info(
// //             "Start call with zegocloud with is video ${callData.callType == CallType.video.name} room id ${callData.zegoRoomId} and receiver name is ${callData.receiverName} and call type is video of ${callData.callType} ${callData.callType == CallType.video.name}");
// //         // await initializeZegoEngine();
//
// //         emit(HasCall(
// //           engine: null,
// //           callData: callData,
// //           isZegoCloud: true,
// //           isMute: false,
// //           isSpeaker: false,
// //           isVideoEnabled: callData.callType == CallType.video.name,
// //           isRemoteVideoEnabled: callData.callType == CallType.video.name,
// //         ));
//
// //         await _configureZegoAudioSettings();
//
// //         // await _joinZegoRoom(callData);
// //       }
// //     } else {
// //       LoggingService.debug("VoiceCallingScreen call state4: $state");
// //       if (isFromCheckComingCall) {
// //         emit(HasCall(
// //           engine: null,
// //           callData: callData,
// //           isMute: false,
// //           isSpeaker: false,
// //           isVideoEnabled: callData.callType == CallType.video.name,
// //         ));
// //       }
// //     }
// //   }
//
// //   Future<void> _configureZegoAudioSettings() async {
// //     LoggingService.methodCall("CallCubit", "_configureZegoAudioSettings");
//
// //     try {
// //       // STEP 1: First, release any existing audio resources to avoid conflicts
// //       await ZegoExpressEngine.instance.enableAudioCaptureDevice(false);
// //       await Future.delayed(Duration(milliseconds: 100));
//
// //       // STEP 2: Set up high-quality audio config for clearer sound
// //       await ZegoExpressEngine.instance.setAudioConfig(ZegoAudioConfig(
// //         48000, // Higher sample rate for better quality
// //         ZegoAudioChannel.Mono, // Mono is sufficient for voice calls
// //         ZegoAudioCodecID.Normal, // Standard codec for compatibility
// //       ));
// //       LoggingService.info("✅ Audio config set");
//
// //       // STEP 3: Enable audio capture device with explicit mode
// //       await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //       LoggingService.info("✅ Audio capture enabled");
//
// //       // STEP 4: Ensure microphone is definitely NOT muted
// //       await ZegoExpressEngine.instance.muteMicrophone(false);
// //       LoggingService.info("✅ Microphone unmuted");
//
// //       // STEP 5: Explicitly unmute audio publishing
// //       await ZegoExpressEngine.instance.mutePublishStreamAudio(false);
// //       LoggingService.info("✅ Stream audio publishing unmuted");
//
// //       // STEP 6: Set appropriate volumes for both input and output
// //       await ZegoExpressEngine.instance.setCaptureVolume(100); // Max mic volume
// //       await ZegoExpressEngine.instance.setPlayVolume(100); // Set global playback volume
// //       LoggingService.info("✅ Audio volumes configured");
//
// //       // STEP 7: Use earpiece by default (more private and reduces echo)
// //       await ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
// //       LoggingService.info("✅ Audio route set to earpiece");
//
// //       // STEP 8: Apply comprehensive engine config focusing on audio reliability
// //       ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
// //         advancedConfig: {
// //           // Audio processing settings
// //           "audio.enable.aec": "true", // Echo cancellation
// //           "audio.enable.agc": "true", // Auto gain control
// //           "audio.enable.ans": "true", // Noise suppression
// //           "audio.voice.communication.mode": "true", // Optimize for voice calls
//
// //           // Reliable audio initialization
// //           "audio.audioRecord.startWhenInit": "true",
// //           "audio.audioTrack.startWhenInit": "true",
//
// //           // Critical for Android audio capture reliability
// //           "audio.capture.force_using_media_recorder": "true",
// //           "audio.audioRecord.force.using.media.codec": "true",
//
// //           // Important to prevent audio cutoffs
// //           "audio.enable.hardware.decoder": "true",
// //           "audio.record.keep.awake": "true",
// //           "audio.player.keep.awake": "true",
//
// //           // Background mode settings
// //           "background.mode.enabled": "true",
// //           "audio.process.continue.in.background": "true",
//
// //           // Enhanced audio settings for both sides to hear clearly
// //           "audio.audioRecord.has.reference": "true",
// //           "audio.audioRecord.reference.enalbe": "true",
// //           "audio.record.rescue.enabled": "true",
// //           "audio.audioRecord.rescue.enabled": "true",
// //           "audio.enable.software.aec.with.builtin": "true",
//
// //           // Lower latency audio
// //           "audio.audioRecord.mode.lowLatency": "true",
// //           "audio.capture.audioJitterBuffer": "false",
// //         },
// //       ));
// //       LoggingService.info("✅ Advanced audio engine config applied");
//
// //       LoggingService.info("✓ Audio settings configured successfully");
// //     } catch (e) {
// //       LoggingService.error("❌ Error configuring audio settings", error: e);
//
// //       // Attempt recovery with basic settings
// //       try {
// //         await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //         await ZegoExpressEngine.instance.muteMicrophone(false);
// //         await ZegoExpressEngine.instance.mutePublishStreamAudio(false);
// //         LoggingService.info("⚠️ Applied fallback audio settings after error");
// //       } catch (_) {}
// //     }
// //   }
//
// //   Future<RtcEngine?> _initializeEngine(CallData callData) async {
// //     LoggingService.debug("Call data: $callData");
// //     final agoraEngine = createAgoraRtcEngine();
// //     await agoraEngine.initialize(const RtcEngineContext(
// //       appId: "223d82348c04428fb78029d931bbbbe7",
//
// //       //  UIConst.agoraAppId,
// //       channelProfile: ChannelProfileType.channelProfileCommunication1v1,
// //     ));
//
// //     // Configure audio session for background mode
// //     await agoraEngine.enableAudioVolumeIndication(
// //         interval: 200, smooth: 3, reportVad: true);
// //     await agoraEngine.setParameters('{"che.audio.keep.audiosession": true}');
// //     await agoraEngine.enableWebSdkInteroperability(true);
// //     // await agoraEngine.setParameters('{"che.audio.enable.aec": false}');
// //     // await agoraEngine.setParameters('{"che.audio.enable.agc": false}');
// //     // await agoraEngine.setParameters('{"che.audio.enable.ns": false}');
//
// //     agoraEngine.registerEventHandler(
// //       RtcEngineEventHandler(
// //         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
// //           LoggingService.info("Local user ${connection.localUid} joined");
// //         },
// //         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
// //           LoggingService.info("Remote user $remoteUid joined");
// //         },
// //         onError: (err, msg) {
// //           LoggingService.error("Agora Error - Code: $err, Message: $msg");
// //         },
// //         onConnectionStateChanged: (connection, state, reason) {
// //           if (state == ConnectionStateType.connectionStateDisconnected ||
// //               state == ConnectionStateType.connectionStateFailed &&
// //                   connection.channelId == callData.channelId) {
// //             LoggingService.warning(
// //                 "Calling ended because of connection state change state is $state and channel is ${connection.channelId} and callData is ${callData.channelId}");
// //             endCall();
// //           }
// //         },
// //       ),
// //     );
//
// //     await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
// //     await agoraEngine.enableAudio();
//
// //     // Set audio scenario to ensure audio continues in background
// //     await agoraEngine.setAudioScenario(AudioScenarioType.audioScenarioChatroom);
// //     await agoraEngine
// //         .setEnableSpeakerphone(false); // Start with earpiece by default
//
// //     if (callData.callType == CallType.video.name) {
// //       await agoraEngine.enableVideo();
// //     }
//
// //     LoggingService.debug(
// //         "Joining channel with token: ${callData.rtcToken.substring(0, 10)}...");
// //     LoggingService.debug("Channel ID: ${callData.channel}");
//
// //     LoggingService.debug(
// //         'callData.rtcToken ${callData.rtcToken}  callData.channelId ${callData.channelId}  callData.channelName ${callData.channel}');
// //     await agoraEngine.joinChannel(
// //       token:
// //           // "007eJxTYHAVuXMi7NEWiT9v0+P4rL+GRWlv/stWyn2PW8qh+41/1zUFBiMj4xQLI2MTi2QDExMji7QkcwsDI8sUS2PDJCBINf99c2t6QyAjwz8lVQZGKATxVRgsEk1TDc2TU3RTDMyTdU2SjJJ1LYyTEnUtU00tEw1S0lIszEwYGADHbSgT",
// //           callData.rtcToken,
// //       channelId:
// //           // "8a5e17cd-d07c-4b2c-83ba-9e59a0dfd864",
// //           callData.channel,
// //       uid: 0,
// //       options: const ChannelMediaOptions(
// //         clientRoleType: ClientRoleType.clientRoleBroadcaster,
// //         channelProfile: ChannelProfileType.channelProfileCommunication1v1,
// //       ),
// //     );
// //     LoggingService.info("Agora engine initialized and joined");
// //     // await agoraEngine.setDefaultAudioRouteToSpeakerphone(
// //     //     callData.callType == CallType.video.name);
// //     await agoraEngine.setDefaultAudioRouteToSpeakerphone(false);
//
// //     return agoraEngine;
// //   }
//
// //   void endCall() async {
// //     LoggingService.methodCall("CallCubit", "endCall");
// //     CallTimerService().resetTimer();
// //     if (state is HasCall) {
// //       final hasCallState = state as HasCall;
// //       LoggingService.info('End Call');
// //       await serviceLocator<SharedPreferences>().remove('call_data');
// //       serviceLocator<CallWithNotificationHelper>().sendActionNotification(
// //         hasCallState.callData,
// //         CallActions.callEnded,
// //         reason: 'user ended call after call connected',
// //       );
// //       if (hasCallState.callData.isRealCall == true.toString()) {
// //         if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
// //           // Clean up Agora engine
// //           final engine = hasCallState.engine!;
// //           await engine.leaveChannel();
// //           await engine.release();
// //         } else if (hasCallState.isZegoCloud) {
// //           // First stop streaming and preview
// //           if (_remoteStreamID != null) {
// //             await stopZegoPlayStream(_remoteStreamID!);
// //             _remoteStreamID = null;
// //           }
//
// //           // Finally logout from room
// //           await logoutZegoRoom(roomId: hasCallState.callData.zegoRoomId);
// //         }
// //       }
// //     }
// //     LoggingService.info("call ended after calling endCall");
// //     emit(NoCalls());
// //   }
//
// //   // void startZegoListenEvent() {
// //   //   final hasCallState = state as HasCall;
//
// //   //   // Configure audio settings
// //   //   ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //   //   ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
// //   //   ZegoExpressEngine.instance.setCaptureVolume(80);
//
// //   //   // Room user updates
// //   //   ZegoExpressEngine.onRoomUserUpdate =
// //   //       (roomID, updateType, List<ZegoUser> userList) {
// //   //     debugPrint(
// //   //         'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
//
// //   //     if (updateType == ZegoUpdateType.Add) {
// //   //       for (final user in userList) {
// //   //         print("New user joined: ${user.userID}");
// //   //         // Force enable audio when new user joins
// //   //         ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //   //       }
// //   //     }
// //   //   };
//
// //   //   // Stream updates - CRITICAL for audio
// //   //   ZegoExpressEngine.onRoomStreamUpdate =
// //   //       (roomID, updateType, List<ZegoStream> streamList, extendedData) {
// //   //     debugPrint(
// //   //         'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}');
//
// //   //     final hasCallState = state as HasCall;
// //   //     if (updateType == ZegoUpdateType.Add) {
// //   //       for (final stream in streamList) {
// //   //         print("New stream added: ${stream.streamID}");
// //   //         _remoteStreamID = stream.streamID;
//
// //   //         // IMPORTANT: Start playing the remote stream for audio
// //   //         startZegoPlayStream(stream.streamID);
//
// //   //         // Update UI for video calls
// //   //         final isVideo = hasCallState.callData.callType == CallType.video.name;
// //   //         emit(hasCallState.copyWith(isRemoteVideoEnabled: isVideo));
// //   //       }
// //   //     } else if (updateType == ZegoUpdateType.Delete) {
// //   //       for (final stream in streamList) {
// //   //         if (stream.streamID == _remoteStreamID) {
// //   //           print("Stream removed: ${stream.streamID}");
// //   //           _remoteStreamID = null;
// //   //           stopZegoPlayStream(stream.streamID);
// //   //           emit(hasCallState.copyWith(
// //   //               isRemoteVideoEnabled: false, remoteView: const SizedBox()));
// //   //         }
// //   //       }
// //   //     }
// //   //   };
//
// //   //   // Remote microphone state
// //   //   ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
// //   //     debugPrint(
// //   //         'onRemoteMicStateUpdate streamID: $streamID, state: ${state.name}');
//
// //   //     // Ensure our audio continues regardless of remote state
// //   //     ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
// //   //     // If remote user is in background, ensure our mic stays active
// //   //     if (state == ZegoRemoteDeviceState.InBackground) {
// //   //       final currentState = this.state as HasCall;
// //   //       if (!currentState.isMute) {
// //   //         ZegoExpressEngine.instance.muteMicrophone(false);
// //   //       }
// //   //     }
// //   //   };
//
// //   //   // Other event handlers...
// //   //   _setupAdditionalEventHandlers();
// //   // }
//
// //   void startZegoListenEvent() {
// //     // Configure audio settings
// //     ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //     ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
// //     ZegoExpressEngine.instance.setCaptureVolume(80);
//
// //     // Room user updates
// //     ZegoExpressEngine.onRoomUserUpdate =
// //         (roomID, updateType, List<ZegoUser> userList) {
// //       LoggingService.debug(
// //           'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
//
// //       if (updateType == ZegoUpdateType.Add) {
// //         for (final user in userList) {
// //           LoggingService.info("New user joined: ${user.userID}");
// //           // Force enable audio when new user joins
// //           ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
// //           // Update call state to connected when remote user joins
// //           final currentState = state as HasCall;
// //           if (!currentState.isCallConnected) {
// //             emit(currentState.copyWith(isCallConnected: true));
// //             LoggingService.info("Call is now connected - both users are in the room");
// //           }
// //         }
// //       } else if (updateType == ZegoUpdateType.Delete) {
// //         for (final user in userList) {
// //           LoggingService.info("User left: ${user.userID}");
// //           // Handle user leaving
// //           final currentState = state as HasCall;
// //           if (currentState.isCallConnected) {
// //             emit(currentState.copyWith(isCallConnected: false));
// //           }
// //         }
// //       }
// //     };
//
// //     // // Stream updates - CRITICAL for audio
// //     // ZegoExpressEngine.onRoomStreamUpdate =
// //     //     (roomID, updateType, List<ZegoStream> streamList, extendedData) {
// //     //   debugPrint(
// //     //       'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}');
//
// //     //   final hasCallState = state as HasCall;
// //     //   if (updateType == ZegoUpdateType.Add) {
// //     //     for (final stream in streamList) {
// //     //       print("New stream added: ${stream.streamID}");
// //     //       _remoteStreamID = stream.streamID;
//
// //     //       // IMPORTANT: Start playing the remote stream for audio immediately
// //     //       startZegoPlayStream(stream.streamID);
//
// //     //       // Mark call as connected when we receive the first stream
// //     //       if (!hasCallState.isCallConnected) {
// //     //         emit(hasCallState.copyWith(isCallConnected: true));
// //     //         print("Call connected - remote stream received");
// //     //       }
//
// //     //       // Update UI for video calls
// //     //       final isVideo = hasCallState.callData.callType == CallType.video.name;
// //     //       emit(hasCallState.copyWith(isRemoteVideoEnabled: isVideo));
// //     //     }
// //     //   } else if (updateType == ZegoUpdateType.Delete) {
// //     //     for (final stream in streamList) {
// //     //       if (stream.streamID == _remoteStreamID) {
// //     //         print("Stream removed: ${stream.streamID}");
// //     //         _remoteStreamID = null;
// //     //         stopZegoPlayStream(stream.streamID);
// //     //         emit(hasCallState.copyWith(
// //     //             isRemoteVideoEnabled: false, remoteView: const SizedBox()));
// //     //       }
// //     //     }
// //     //   }
// //     // };
//
// //     // // Room state updates
// //     // ZegoExpressEngine.onRoomStateUpdate =
// //     //     (roomID, state, errorCode, extendedData) {
// //     //   debugPrint(
// //     //       'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode');
//
// //     //   if (state == ZegoRoomState.Connected) {
// //     //     print("Room connected successfully");
// //     //     // Ensure audio is enabled when room connects
// //     //     ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //     //   } else if (state == ZegoRoomState.Disconnected) {
// //     //     print("Room disconnected");
// //     //     final currentState = this.state as HasCall;
// //     //     emit(currentState.copyWith(isCallConnected: false));
// //     //   }
// //     // };
// //     // ADD THE STREAM UPDATE HANDLER HERE
// //     ZegoExpressEngine.onRoomStreamUpdate =
// //         (roomID, updateType, List<ZegoStream> streamList, extendedData) {
// //       LoggingService.debug(
// //           'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}');
//
// //       final hasCallState = state as HasCall;
// //       if (updateType == ZegoUpdateType.Add) {
// //         for (final stream in streamList) {
// //           LoggingService.info("=== NEW STREAM DETECTED ===");
// //           LoggingService.info("Stream ID: ${stream.streamID}");
// //           LoggingService.info("Stream User ID: ${stream.user.userID}");
//
// //           // CRITICAL: Start the call timer when we receive the first remote stream
// //           if (!CallTimerService().isRunning) {
// //             CallTimerService().startTimer();
// //             LoggingService.info("✓ Call timer started - call connected");
// //           }
//
// //           // Start playing the remote stream (for audio)
// //           startZegoPlayStream(stream.streamID);
// //           LoggingService.info("✓ Started playing stream: ${stream.streamID}");
//
// //           _remoteStreamID = stream.streamID;
//
// //           // For video calls, initialize remote video state
// //           final isVideoCall = hasCallState.callData.callType == CallType.video.name;
// //           if (isVideoCall) {
// //             // Initially assume remote video is enabled for video calls
// //             emit(hasCallState.copyWith(
// //               isCallConnected: true,
// //               isRemoteVideoEnabled: true,
// //             ));
// //             LoggingService.info("✓ Video call - remote video state initialized");
// //           } else {
// //             // Mark call as connected for audio calls
// //             emit(hasCallState.copyWith(isCallConnected: true));
// //           }
// //           LoggingService.info("✓ Call marked as connected");
// //         }
// //       } else if (updateType == ZegoUpdateType.Delete) {
// //         for (final stream in streamList) {
// //           if (stream.streamID == _remoteStreamID) {
// //             stopZegoPlayStream(stream.streamID);
// //             LoggingService.info("Stopped playing deleted stream: ${stream.streamID}");
// //             _remoteStreamID = null;
//
// //             // Update state to reflect disconnection and video cleanup
// //             emit(hasCallState.copyWith(
// //               isCallConnected: false,
// //               isRemoteVideoEnabled: false,
// //               remoteView: const SizedBox(),
// //             ));
// //             LoggingService.info("✓ Call disconnected - UI state updated");
// //           }
// //         }
// //       }
// //     };
//
// //     // Room state updates
// //     ZegoExpressEngine.onRoomStateUpdate =
// //         (roomID, state, errorCode, extendedData) {
// //       LoggingService.debug(
// //           'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode');
//
// //       if (state == ZegoRoomState.Connected) {
// //         LoggingService.info("Room connected successfully");
// //         ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //       } else if (state == ZegoRoomState.Disconnected) {
// //         LoggingService.info("Room disconnected");
// //         final currentState = this.state as HasCall;
// //         emit(currentState.copyWith(isCallConnected: false));
// //       }
// //     };
//
// //     // Remote microphone state updates
// //     ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
// //       LoggingService.debug(
// //           'onRemoteMicStateUpdate streamID: $streamID, state: ${state.name}');
//
// //       // Ensure our audio continues regardless of remote state
// //       ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
// //       // If remote user is in background, ensure our mic stays active
// //       if (state == ZegoRemoteDeviceState.InBackground) {
// //         final currentState = this.state as HasCall;
// //         if (!currentState.isMute) {
// //           ZegoExpressEngine.instance.muteMicrophone(false);
// //         }
// //       }
// //     };
//
// //     // Publisher state updates
// //     ZegoExpressEngine.onPublisherStateUpdate =
// //         (streamID, state, errorCode, extendedData) {
// //       LoggingService.debug(
// //           'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode');
//
// //       if (state == ZegoPublisherState.Publishing) {
// //         LoggingService.info("Successfully publishing stream: $streamID");
// //         // Ensure audio is active when publishing starts
// //         ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //       }
// //     };
//
//
//
// //   // If remote app goes to background, don't immediately hide video
// //   Timer? _backgroundVideoTimer;
// //   Future<void> _handleRemoteAppBackground(String streamID) async {
// //     // Cancel any existing timer
// //     _backgroundVideoTimer?.cancel();
//
// //     // Start a new timer - if the app doesn't come back to foreground in 3 seconds, disable video
// //     _backgroundVideoTimer = Timer(Duration(seconds: 3), () {
// //       if (isClosed) return;
//
// //       final currentState = this.state as HasCall;
// //       if (currentState.isRemoteVideoEnabled && _remoteStreamID == streamID) {
// //         LoggingService.info("⏱️ Remote app still in background after timeout - disabling video");
// //         emit(currentState.copyWith(
// //           isRemoteVideoEnabled: false,
// //           remoteView: Container(
// //             color: Colors.black45,
// //             child: Center(
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Icon(Icons.hourglass_bottom, color: Colors.white, size: 48),
// //                   SizedBox(height: 12),
// //                   Text("Video paused - waiting for other user", style: TextStyle(color: Colors.white))
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ));
// //       }
// //     });
// //     }
//
// //     // Remote camera state updates - CRITICAL for video functionality
// //     ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) {
// //       LoggingService.info(
// //           '📹 Remote camera state update for stream: $streamID, state: ${state.name}');
//
// //       final hasCallState = this.state as HasCall;
// //       final isVideoCall = hasCallState.callData.callType == CallType.video.name;
//
// //       if (isVideoCall && streamID == _remoteStreamID) {
// //         LoggingService.info("🔄 Processing remote camera state change: ${state.name}");
//
// //         bool remoteVideoEnabled = false;
// //         switch (state) {
// //           case ZegoRemoteDeviceState.Open:
// //             remoteVideoEnabled = true;
// //             LoggingService.info("✅ Remote camera is ON - video should be visible");
//
// //             // For Open state, we may want to refresh the remote view to ensure it displays properly
// //             if (!hasCallState.isRemoteVideoEnabled) {
// //               LoggingService.info("🔄 Refreshing remote video because camera was just turned on");
//
// //               // If we have a valid stream ID and remote view was previously disabled, refresh it
// //               // Using Future to handle async operations in non-async callback
// //               _handleRemoteVideoRefresh(streamID);
// //             }
// //             break;
//
// //           case ZegoRemoteDeviceState.Mute:
// //             LoggingService.info("🔇 Remote camera is MUTED - user disabled video");
// //             remoteVideoEnabled = false;
// //             break;
//
// //           case ZegoRemoteDeviceState.Disable:
// //             LoggingService.info("🚫 Remote camera is DISABLED");
// //             remoteVideoEnabled = false;
// //             break;
//
// //           case ZegoRemoteDeviceState.InBackground:
// //             LoggingService.info("⏱️ Remote app is in BACKGROUND - may resume shortly");
// //             // We don't immediately disable video for background state, as it may return
// //             // Instead, we'll start a timer and disable if it doesn't return quickly
// //             _handleRemoteAppBackground(streamID);
// //             return; // Let the timer handle state updates
//
// //           case ZegoRemoteDeviceState.NotSupport:
// //           case ZegoRemoteDeviceState.GenericError:
// //           case ZegoRemoteDeviceState.InvalidID:
// //           case ZegoRemoteDeviceState.NoAuthorization:
// //             LoggingService.warning("⚠️ Remote camera error state: ${state.name}");
// //             remoteVideoEnabled = false;
// //             break;
// //         }
//
// //         // Update UI based on camera state (unless we're in background state)
// //         if (state != ZegoRemoteDeviceState.InBackground) {
// //           if (!remoteVideoEnabled) {
// //             // Create a placeholder for disabled camera
// //             final placeholderWidget = Container(
// //               color: Colors.black45,
// //               child: Center(
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Icon(Icons.videocam_off, color: Colors.white, size: 48),
// //                     SizedBox(height: 12),
// //                     Text("Camera turned off", style: TextStyle(color: Colors.white))
// //                   ],
// //                 ),
// //               ),
// //             );
//
// //             // Update UI state
// //             emit(hasCallState.copyWith(
// //               remoteView: placeholderWidget,
// //               isRemoteVideoEnabled: false,
// //             ));
// //             LoggingService.info("✅ Updated UI with placeholder for disabled camera");
// //           } else if (!hasCallState.isRemoteVideoEnabled) {
// //             // Camera is enabled but UI shows disabled - this is handled by the Open case
// //             // which will call _handleRemoteVideoRefresh
// //           }
// //         }
// //           case ZegoRemoteDeviceState.ZeroFPS:
// //           case ZegoRemoteDeviceState.InUseByOther:
// //           case ZegoRemoteDeviceState.Unplugged:
// //           default:
// //             remoteVideoEnabled = false;
// //             LoggingService.info("❌ Remote camera is in error state: ${state.name}");
// //             break;
// //         }
//
// //         // Update the UI state to reflect remote video status
// //         if (hasCallState.isRemoteVideoEnabled != remoteVideoEnabled) {
// //           emit(hasCallState.copyWith(isRemoteVideoEnabled: remoteVideoEnabled));
// //           LoggingService.info("🔄 Updated remote video state to: $remoteVideoEnabled");
//
// //           // If video is being disabled, show a placeholder
// //           if (!remoteVideoEnabled) {
// //             emit(hasCallState.copyWith(
// //               remoteView: Container(
// //                 color: Colors.black45,
// //                 child: Center(
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(Icons.videocam_off, color: Colors.white, size: 48),
// //                       SizedBox(height: 12),
// //                       Text("Camera turned off", style: TextStyle(color: Colors.white))
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               isRemoteVideoEnabled: false,
// //             ));
// //             LoggingService.info("✅ Updated UI with placeholder for disabled camera");
// //           }
// //         }
// //       }
// //     };
//
// //     // Player state updates - Important for receiver
// //     ZegoExpressEngine.onPlayerStateUpdate =
// //         (streamID, state, errorCode, extendedData) {
// //       LoggingService.debug(
// //           'onPlayerStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode');
//
// //       if (state == ZegoPlayerState.Playing) {
// //         LoggingService.info("Successfully playing remote stream: $streamID");
// //         // Ensure audio output is enabled when playing remote stream
// //         ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
//
// //         // Mark call as connected when we start playing remote stream
// //         final currentState = this.state as HasCall;
// //         if (!currentState.isCallConnected) {
// //           emit(currentState.copyWith(isCallConnected: true));
// //           CallTimerService().startTimer();
// //           LoggingService.info("Call connected - started playing remote stream");
// //         }
//
// //         // Check and update remote video state when we start playing
// //         if (currentState.callData.callType == CallType.video.name) {
// //           Future.delayed(Duration(milliseconds: 500), () {
// //             checkAndUpdateRemoteVideoState(streamID);
// //           });
// //         }
// //       }
// //     };
//
// //     // CRITICAL VIDEO EVENT HANDLERS - Enhanced for better timing synchronization
//
// //     // Publisher video first frame event - for local video with timing tracking
// //     ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = (channel) {
// //       final timestamp = DateTime.now().millisecondsSinceEpoch;
// //       LoggingService.info("🎥 [$timestamp] LOCAL VIDEO FIRST FRAME CAPTURED - camera feed is working");
// //       // This confirms that the local camera is capturing video content
// //     };
//
// //     ZegoExpressEngine.onPublisherRenderVideoFirstFrame = (channel) {
// //       final timestamp = DateTime.now().millisecondsSinceEpoch;
// //       LoggingService.info("🎥 [$timestamp] LOCAL VIDEO FIRST FRAME RENDERED - local video should be visible");
// //       // This confirms that local video is being rendered to the canvas
// //     };
//
// //     // Player video first frame event - for remote video with state synchronization
// //     ZegoExpressEngine.onPlayerRecvVideoFirstFrame = (streamID) {
// //       final timestamp = DateTime.now().millisecondsSinceEpoch;
// //       LoggingService.info("🎥 [$timestamp] REMOTE VIDEO FIRST FRAME RECEIVED from stream: $streamID");
// //       // This confirms remote video content is being received
// //     };
//
// //     ZegoExpressEngine.onPlayerRenderVideoFirstFrame = (streamID) {
// //       final timestamp = DateTime.now().millisecondsSinceEpoch;
// //       LoggingService.info("🎥 [$timestamp] REMOTE VIDEO FIRST FRAME RENDERED for stream: $streamID - remote video should be visible");
// //       // This confirms remote video is being rendered to the canvas
//
// //       // Force ensure remote video is enabled in UI when first frame renders
// //       if (streamID == _remoteStreamID) {
// //         final currentState = this.state as HasCall;
// //         if (currentState.callData.callType == CallType.video.name) {
// //           if (!currentState.isRemoteVideoEnabled) {
// //             emit(currentState.copyWith(isRemoteVideoEnabled: true));
// //             LoggingService.info("✓ Enabled remote video in UI due to first frame render");
// //           }
// //         }
// //       }
// //     };
//
// //     // Publisher video size change - indicates video is properly initialized
// //     ZegoExpressEngine.onPublisherVideoSizeChanged = (width, height, channel) {
// //       final timestamp = DateTime.now().millisecondsSinceEpoch;
// //       LoggingService.info("📐 [$timestamp] LOCAL VIDEO SIZE CHANGED: ${width}x$height - video dimensions set");
//
// //       // Verify video configuration is correct
// //       if (width > 0 && height > 0) {
// //         LoggingService.info("✓ Local video dimensions confirmed - preview should be working");
// //       }
// //     };
//
// //     // Player video size change - indicates remote video is properly initialized
// //     ZegoExpressEngine.onPlayerVideoSizeChanged = (streamID, width, height) {
// //       final timestamp = DateTime.now().millisecondsSinceEpoch;
// //       LoggingService.info("📐 [$timestamp] REMOTE VIDEO SIZE CHANGED for $streamID: ${width}x$height - remote video dimensions set");
//
// //       // Verify remote video configuration
// //       if (width > 0 && height > 0 && streamID == _remoteStreamID) {
// //         LoggingService.info("✓ Remote video dimensions confirmed - remote preview should be working");
// //       }
// //     };
// //   }
//
// //   // void startZegoListenEvent() {
// //   //   final hasCallState = state as HasCall;
//
// //   //   // Configure ZegoCloud for background audio with much stronger settings
// //   //   ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //   //   ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
//
// //   //   // Set capture volume to a moderate level for better stability
// //   //   ZegoExpressEngine.instance.setCaptureVolume(80);
//
// //   //   // Pre-configure critical background audio settings
// //   //   ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
// //   //     advancedConfig: {
// //   //       "audio.capture.force_using_media_recorder": "true",
// //   //       "audio.captureAndRender.androidLowLatencyEnabled": "true",
// //   //       "background.mode.enabled": "true",
// //   //       "audio.process.continue.in.background": "true",
// //   //       "audio.audioRecord.bluetooth_disable_aec": "true",
// //   //       "audio.audioRecord.disable_aes": "true",
// //   //       "audio.process.keep.frequently.acquired": "true",
// //   //       "audio.audioRecord.keep.audiosession.active": "true",
// //   //       "audio.capture.prevent.system.suspend": "true"
// //   //     },
// //   //   ));
//
// //   //   // Callback for updates on the status of other users in the room.
// //   //   ZegoExpressEngine.onRoomUserUpdate =
// //   //       (roomID, updateType, List<ZegoUser> userList) {
// //   //     debugPrint(
// //   //         'onRoomUserUpdate: roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => e.userID)}');
// //   //   };
//
// //   //   // Listen for remote user's microphone state changes
// //   //   ZegoExpressEngine.onRemoteMicStateUpdate = (streamID, state) {
// //   //     debugPrint(
// //   //         'onRemoteMicStateUpdate streamID: $streamID, state: ${state.name}');
//
// //   //     // Always ensure audio processing continues
// //   //     ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
// //   //     // When in background, some devices might disable the mic - force re-enable it
// //   //     if (state == ZegoRemoteDeviceState.InBackground) {
// //   //       debugPrint(
// //   //           'Remote user went to background - ensuring microphone stays active');
// //   //       // Force re-enable our microphone if not muted by user
// //   //       final currentState = this.state as HasCall;
// //   //       if (!currentState.isMute) {
// //   //         ZegoExpressEngine.instance.muteMicrophone(false);
// //   //       }
// //   //     }
// //   //   };
//
// //   //   // Callback for updates on the status of the streams in the room.
// //   //   ZegoExpressEngine.onRoomStreamUpdate =
// //   //       (roomID, updateType, List<ZegoStream> streamList, extendedData) {
// //   //     debugPrint(
// //   //         'onRoomStreamUpdate: roomID: $roomID, updateType: $updateType, streamList: ${streamList.map((e) => e.streamID)}, extendedData: $extendedData');
//
// //   //     final hasCallState = state as HasCall;
// //   //     if (updateType == ZegoUpdateType.Add) {
// //   //       for (final stream in streamList) {
// //   //         _remoteStreamID = stream.streamID;
// //   //         startZegoPlayStream(stream.streamID);
// //   //         // Initialize remote video as enabled when stream is added and call type is video
// //   //         final isVideo = hasCallState.callData.callType == CallType.video.name;
// //   //         emit(hasCallState.copyWith(isRemoteVideoEnabled: isVideo));
// //   //       }
// //   //     } else {
// //   //       for (final stream in streamList) {
// //   //         if (stream.streamID == _remoteStreamID) {
// //   //           _remoteStreamID = null;
// //   //           stopZegoPlayStream(stream.streamID);
// //   //           emit(hasCallState.copyWith(
// //   //               isRemoteVideoEnabled: false, remoteView: const SizedBox()));
// //   //         }
// //   //       }
// //   //     }
// //   //   };
//
// //   //   // Listen for remote user's camera state changes
// //   //   ZegoExpressEngine.onRemoteCameraStateUpdate = (streamID, state) {
// //   //     if (streamID == _remoteStreamID) {
// //   //       final hasCallState = this.state as HasCall;
// //   //       final bool isRemoteVideoEnabled = state == ZegoRemoteDeviceState.Open;
// //   //       if (isRemoteVideoEnabled) {
// //   //         startZegoPlayStream(streamID);
// //   //       } else {
// //   //         // If remote camera is turned off, update UI but don't stop the stream
// //   //         emit(hasCallState.copyWith(
// //   //           isRemoteVideoEnabled: false,
// //   //         ));
// //   //       }
// //   //     }
// //   //   };
//
// //   //   // Callback for updates on the current user's room connection status.
// //   //   ZegoExpressEngine.onRoomStateUpdate =
// //   //       (roomID, state, errorCode, extendedData) {
// //   //     debugPrint(
// //   //         'onRoomStateUpdate: roomID: $roomID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
// //   //   };
//
// //   //   // Callback for updates on the current user's stream publishing changes.
// //   //   ZegoExpressEngine.onPublisherStateUpdate =
// //   //       (streamID, state, errorCode, extendedData) {
// //   //     print("local video is opened here");
// //   //     if (hasCallState.isVideoEnabled) {
// //   //       emit(hasCallState.copyWith(
// //   //           isVideoEnabled: state == ZegoPublisherState.Publishing));
// //   //     }
//
// //   //     debugPrint(
// //   //         'onPublisherStateUpdate: streamID: $streamID, state: ${state.name}, errorCode: $errorCode, extendedData: $extendedData');
// //   //   };
// //   // }
//
// //   // Add a much more aggressive method to handle when app goes to background
// //   // Future<void> handleAppBackground() async {
// //   //   if (state is HasCall) {
// //   //     final hasCallState = state as HasCall;
// //   //     if (hasCallState.isZegoCloud) {
// //   //       print(
// //   //           'Handling app going to background - ensuring microphone stays active');
//
// //   //       // Force enable audio capture device
// //   //       ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
// //   //       // Use a more moderate volume that won't distort but is clearly audible
// //   //       ZegoExpressEngine.instance.setCaptureVolume(80);
//
// //   //       // Ensure microphone is unmuted (unless user specifically muted it)
// //   //       if (!hasCallState.isMute) {
// //   //         ZegoExpressEngine.instance.muteMicrophone(false);
// //   //       }
//
// //   //       // Complete restart of the audio subsystem to reset any potential issues
// //   //       ZegoExpressEngine.instance.enableAudioCaptureDevice(false);
// //   //       await Future.delayed(const Duration(milliseconds: 100));
// //   //       ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
// //   //       // Specific configuration for voice calls in background
// //   //       ZegoExpressEngine.instance.setAudioConfig(ZegoAudioConfig(
// //   //         16000, // Lower bitrate for stability in background
// //   //         ZegoAudioChannel.Mono,
// //   //         ZegoAudioCodecID.Default,
// //   //       ));
//
// //   //       // More comprehensive engine config specifically designed for background operation
// //   //       ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
// //   //         advancedConfig: {
// //   //           "audio.captureAndRender.continuousInBackgroundMode": "true",
// //   //           "audio.record.keep.awake": "true",
// //   //           "audio.keep.background.connection": "true",
// //   //           "audio.capture.force_using_media_recorder": "true",
// //   //           "audio.capture.nodata.protection":
// //   //               "false", // Disable no-data protection which might cut audio
// //   //           "audio.audioRecord.mode.lowLatency": "true",
// //   //           "audio.audioRecord.background.mild.processor": "true",
// //   //           "audio.audioRecord.keep.audiosession.active": "true",
// //   //           "audio.enableIOSHeadphoneMonitor": "true",
// //   //           "audio.handle.systemAVAudioSession":
// //   //               "true", // Let the SDK handle audio session
// //   //           "audio.mediaPlay.use.error.callback.protection": "true",
// //   //           "audio.player.enableRecoveryFromError": "true",
// //   //           "android.audio.session.alwaysOn":
// //   //               "true", // Critical for Android background audio
// //   //           "android.audio.process.priority": "high",
// //   //         },
// //   //       ));
//
// //   //       // Stop and restart publishing stream to refresh connection
// //   //       await stopZegoPublish();
//
// //   //       // Short delay before re-publishing
// //   //       await Future.delayed(const Duration(milliseconds: 200));
//
// //   //       try {
// //   //         // Use a consistent stream ID when re-publishing
// //   //         final userName =
// //   //             hasCallState.callData.receiverName ?? "user_background";
// //   //         await startZegoPublish(
// //   //             roomId: hasCallState.callData.zegoRoomId, userName: userName);
//
// //   //         print('Successfully restarted audio stream in background');
//
// //   //         // Force audio route to ensure proper audio path
// //   //         ZegoExpressEngine.instance.setAudioRouteToSpeaker(false);
// //   //       } catch (e) {
// //   //         print('Error restarting publish in background: $e');
// //   //       }
// //   //     }
// //   //   }
// //   // }
//
// //   Future<void> handleAppBackground() async {
// //     if (state is HasCall) {
// //       final hasCallState = state as HasCall;
// //       if (hasCallState.isZegoCloud) {
// //         LoggingService.info('Handling app going to background - ensuring audio continues');
//
// //         // Force enable audio capture device
// //         await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//
// //         // Ensure microphone is unmuted (unless user specifically muted it)
// //         if (!hasCallState.isMute) {
// //           await ZegoExpressEngine.instance.muteMicrophone(false);
// //         }
//
// //         // Set moderate volume
// //         await ZegoExpressEngine.instance.setCaptureVolume(80);
//
// //         // Re-publish stream to ensure connection
// //         final userId = hasCallState.callData.receiverName;
// //         final streamID = '${hasCallState.callData.zegoRoomId}_${userId}_call';
// //         await ZegoExpressEngine.instance.startPublishingStream(streamID);
//
// //         LoggingService.info("Background audio configuration completed");
// //       }
// //     }
// //   }
//
// //   void stopZegoListenEvent() {
// //     ZegoExpressEngine.onRoomUserUpdate = null;
// //     ZegoExpressEngine.onRoomStreamUpdate = null;
// //     ZegoExpressEngine.onRoomStateUpdate = null;
// //     ZegoExpressEngine.onPublisherStateUpdate = null;
// //     ZegoExpressEngine.onRemoteCameraStateUpdate = null;
// //     ZegoExpressEngine.onRemoteMicStateUpdate = null;
//
// //     // Clear video event handlers
// //     ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = null;
// //     ZegoExpressEngine.onPublisherRenderVideoFirstFrame = null;
// //     ZegoExpressEngine.onPlayerRecvVideoFirstFrame = null;
// //     ZegoExpressEngine.onPlayerRenderVideoFirstFrame = null;
// //     ZegoExpressEngine.onPublisherVideoSizeChanged = null;
// //     ZegoExpressEngine.onPlayerVideoSizeChanged = null;
// //   }
//
// //   // Future<ZegoRoomLoginResult> loginZegoRoom({
// //   //   required String roomId,
// //   //   required String userID,
// //   //   required String userName,
// //   // }) async {
// //   //   final hasCallState = state as HasCall;
// //   //   print(
// //   //       'Tried to login for user Id is $userID, user name is $userName and room id is $roomId');
//
// //   //   // The value of `userID` is generated locally and must be globally unique.
// //   //   final user = ZegoUser(userID, userName);
// //   //   final roomID = roomId;
//
// //   //   // Configure ZegoCloud for background audio before logging in
// //   //   ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
// //   //     advancedConfig: {
// //   //       "audio.capture.force_using_media_recorder": "true",
// //   //       "audio.captureAndRender.androidLowLatencyEnabled": "true",
// //   //       "background.mode.enabled": "true",
// //   //       "audio.process.continue.in.background": "true",
// //   //       "audio.audioRecord.bluetooth_disable_aec": "true",
// //   //       "audio.audioRecord.disable_aes": "true",
// //   //       "audio.process.keep.frequently.acquired": "true",
// //   //       "audio.audioRecord.keep.audiosession.active": "true",
// //   //       "audio.capture.prevent.system.suspend": "true"
// //   //     },
// //   //   ));
//
// //   //   // Optimize for background mode - use StandardQuality for voice calls
// //   //   ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //   //   ZegoExpressEngine.instance.setAudioConfig(
// //   //       ZegoAudioConfig.preset(ZegoAudioConfigPreset.StandardQuality));
//
// //   //   // onRoomUserUpdate callback can be received when "isUserStatusNotify" parameter value is "true".
// //   //   ZegoRoomConfig roomConfig = ZegoRoomConfig.defaultConfig()
// //   //     ..isUserStatusNotify = true;
//
// //   //   final shouldEnableVideo =
// //   //       hasCallState.callData.callType == CallType.video.name;
//
// //   //   // log in to a room
// //   //   return ZegoExpressEngine.instance
// //   //       .loginRoom(roomID, user, config: roomConfig)
// //   //       .then((ZegoRoomLoginResult loginRoomResult) {
// //   //     if (loginRoomResult.errorCode == 0) {
// //   //       ZegoExpressEngine.instance.muteMicrophone(false);
//
// //   //       if (shouldEnableVideo) {
// //   //         // Ensure video is enabled
// //   //         ZegoExpressEngine.instance.mutePublishStreamVideo(false);
// //   //         startZegoPreview(isVideoEnabled: true);
// //   //       } else {
// //   //         // Ensure video is disabled
// //   //         ZegoExpressEngine.instance.mutePublishStreamVideo(true);
// //   //       }
//
// //   //       // Start publishing with appropriate stream ID
// //   //       startZegoPublish(roomId: roomId, userName: userName);
//
// //   //       // Update state to reflect initial video state
// //   //       emit(hasCallState.copyWith(isVideoEnabled: shouldEnableVideo));
// //   //     } else {
// //   //       print('loginRoom failed: ${loginRoomResult.errorCode}');
// //   //     }
// //   //     return loginRoomResult;
// //   //   });
// //   // }
//
// //   Future<ZegoRoomLoginResult> loginZegoRoom({
// //     required String roomId,
// //     required String userID,
// //     required String userName,
// //   }) async {
// //     final hasCallState = state as HasCall;
// //     print('Logging in user: $userID, userName: $userName, roomId: $roomId');
//
// //     try {
// //       // STEP 1: Configure audio settings FIRST
// //       await _configureZegoAudioSettings();
//
// //       // STEP 2: Start event listeners
// //       startZegoListenEvent();
//
// //       // STEP 3: Create user and room config
// //       final user = ZegoUser(userID, userName);
// //       final roomConfig = ZegoRoomConfig(2, true, '');
//
// //       // STEP 4: Login to room
// //       final result = await ZegoExpressEngine.instance
// //           .loginRoom(roomId, user, config: roomConfig);
// //       print("Room login result: ${result.errorCode}");
//
// //       if (result.errorCode == 0) {
// //         print("Successfully logged into room");
//
// //         // STEP 5: Force enable audio after login
// //         await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //         await ZegoExpressEngine.instance.muteMicrophone(false);
//
// //         // STEP 6: Wait for stable connection before initializing video
// //         await Future.delayed(Duration(milliseconds: 500));
//
// //         // STEP 7: Start publishing with audio enabled
// //         await startZegoPublish(roomId: roomId, userName: userID);
//
// //         // STEP 8: Initialize video with proper timing if needed
// //         if (hasCallState.callData.callType == CallType.video.name) {
// //           // Wait a bit more for stream to be established before video
// //           await Future.delayed(Duration(milliseconds: 200));
// //           await startZegoPreview(isVideoEnabled: true);
// //         }
//
// //         print("Room setup completed");
// //       } else {
// //         print("Failed to join room: ${result.errorCode}");
// //         endCall();
// //       }
//
// //       return result;
// //     } catch (e) {
// //       print("Error in loginZegoRoom: $e");
// //       endCall();
// //       rethrow;
// //     }
// //   }
//
// //   Future<ZegoRoomLogoutResult> logoutZegoRoom({required String roomId}) async {
// //     print('logoutRoom : ${roomId}');
// //     stopZegoPreview();
// //     stopZegoPublish();
// //     stopZegoListenEvent();
// //     return ZegoExpressEngine.instance.logoutRoom(roomId);
// //   }
//
// //   Future<void> startZegoPreview({bool isVideoEnabled = true}) async {
// //     try {
// //       LoggingService.info("Starting Zego preview with video: $isVideoEnabled");
// //       final hasCallState = state as HasCall;
//
// //       // Clean up existing preview if needed
// //       if (localViewID != null) {
// //         await stopZegoPreview();
// //         localViewID = null;
// //         LoggingService.info("✓ Existing preview cleaned up");
// //       }
//
// //       // IMPROVED: Use the VideoFixHelper for reliable canvas management
// //       LoggingService.info("🏗️ Creating canvas view with reliable widget capture...");
//
// //       // Call the helper method which manages the entire process
// //       final Widget? canvasWidget = await VideoFixHelper.startPreviewWithReliableCanvas(
// //         isVideoEnabled: isVideoEnabled
// //       );
//
// //       // IMPROVED: Canvas setup quality check
// //       if (isVideoEnabled && canvasWidget != null) {
// //         LoggingService.info("🔄 Updating state with reliable canvas widget for video...");
// //         emit(hasCallState.copyWith(
// //           localView: canvasWidget,
// //           isVideoEnabled: true
// //         ));
// //         LoggingService.info("✅ Local video state emitted - video should be visible in UI");
//
// //         // Ensure state is fully applied by waiting and emitting again
// //         await Future.delayed(const Duration(milliseconds: 50));
// //         emit(hasCallState.copyWith(
// //           localView: canvasWidget,
// //           isVideoEnabled: true
// //         ));
// //       } else if (isVideoEnabled && canvasWidget == null) {
// //         LoggingService.warning("⚠️ Video enabled but canvas widget is null - using placeholder");
// //         emit(hasCallState.copyWith(
// //           localView: Container(
// //             color: Colors.black,
// //             child: const Center(
// //               child: Text('Camera not available - tap to retry', style: TextStyle(color: Colors.white)),
// //             ),
// //           ),
// //           isVideoEnabled: true
// //         ));
// //       } else {
// //         LoggingService.info("🔄 Updating state for audio-only...");
// //         emit(hasCallState.copyWith(
// //           localView: const SizedBox(),
// //           isVideoEnabled: false
// //         ));
// //         LoggingService.info("✅ Local audio-only state emitted");
// //       }
//
// //     } catch (e) {
// //       LoggingService.error("❌ CRITICAL ERROR in startZegoPreview", error: e);
// //       LoggingService.error("❌ Stack trace: ${e.toString()}");
//
// //       // Ensure state is reverted on error
// //       final hasCallState = state as HasCall;
// //       emit(hasCallState.copyWith(
// //         localView: const SizedBox(),
// //         isVideoEnabled: false
// //       ));
//
// //       rethrow;
// //     }
// //   }
//
// //   Future<void> stopZegoPreview() async {
// //     try {
// //       LoggingService.info("Stopping Zego preview with proper cleanup");
//
// //       // STEP 1: Stop preview first to prevent new frames
// //       await ZegoExpressEngine.instance.stopPreview();
// //       LoggingService.info("✓ Preview stopped");
//
// //       // STEP 2: Disable camera to stop capture
// //       await ZegoExpressEngine.instance.enableCamera(false);
// //       LoggingService.info("✓ Camera disabled");
//
// //       // STEP 3: Clean up canvas view
// //       if (localViewID != null) {
// //         await ZegoExpressEngine.instance.destroyCanvasView(localViewID!);
// //         LoggingService.info("✓ Canvas view destroyed: $localViewID");
// //         localViewID = null;
// //       }
//
// //       // STEP 4: Clear first frame callbacks to prevent race conditions
// //       ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = null;
// //       ZegoExpressEngine.onPublisherRenderVideoFirstFrame = null;
//
// //       // STEP 5: Update state
// //       final hasCallState = state as HasCall;
// //       emit(hasCallState.copyWith(
// //         localView: const SizedBox(),
// //         isVideoEnabled: false,
// //       ));
// //       LoggingService.info("✓ Local preview stopped and state updated");
// //     } catch (e) {
// //       LoggingService.error("Error stopping preview", error: e);
// //     }
// //   }
//
// //   // Future<void> startZegoPublish(
// //   //     {required String roomId, required String userName}) async {
// //   //   final hasCallState = state as HasCall;
// //   //   // After calling the `loginRoom` method, call this method to publish streams.
// //   //   // The StreamID must be unique in the room.
// //   //   String streamID = '${roomId}_${userName}_call';
// //   //   // Ensure video is not muted when starting to publish
// //   //   await ZegoExpressEngine.instance
// //   //       .mutePublishStreamVideo(!hasCallState.isVideoEnabled);
// //   //   return ZegoExpressEngine.instance.startPublishingStream(streamID);
// //   // }
//
// //   Future<void> startZegoPublish(
// //       {required String roomId, required String userName}) async {
// //     final hasCallState = state as HasCall;
//
// //     // Use simple, consistent stream ID
// //     String streamID = '${roomId}_$userName';
// //     LoggingService.info("Publishing stream with ID: $streamID");
//
// //     try {
// //       // STEP 1: Enable audio capture FIRST
// //       await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //       LoggingService.info("Audio capture device enabled");
//
// //       // STEP 2: Ensure microphone is NOT muted
// //       await ZegoExpressEngine.instance.muteMicrophone(false);
// //       LoggingService.info("Microphone unmuted");
//
// //       // STEP 3: Set optimal capture volume
// //       await ZegoExpressEngine.instance.setCaptureVolume(100);
// //       LoggingService.info("Capture volume set to 100");
//
// //       // STEP 4: Configure video state (but don't touch audio)
// //       await ZegoExpressEngine.instance
// //           .mutePublishStreamVideo(!hasCallState.isVideoEnabled);
// //       LoggingService.info("Video state configured: ${hasCallState.isVideoEnabled}");
//
// //       // STEP 5: Start publishing stream
// //       await ZegoExpressEngine.instance.startPublishingStream(streamID);
// //       LoggingService.info("Stream publishing started");
//
// //       // STEP 6: CRITICAL - Wait a moment then explicitly ensure audio is NOT muted on the stream
// //       await Future.delayed(const Duration(milliseconds: 500));
// //       await ZegoExpressEngine.instance.mutePublishStreamAudio(false);
// //       LoggingService.info("Stream audio explicitly unmuted");
//
// //       // STEP 7: Force unmute microphone again to ensure audio path
// //       await ZegoExpressEngine.instance.muteMicrophone(false);
// //       LoggingService.info("Microphone force unmuted");
//
// //       // STEP 8: Apply user's actual mute state ONLY if they intentionally muted
// //       if (hasCallState.isMute) {
// //         await ZegoExpressEngine.instance.muteMicrophone(true);
// //         LoggingService.info("Applied user mute state");
// //       }
//
// //       LoggingService.info("Publishing setup completed successfully");
// //     } catch (e) {
// //       LoggingService.error("ERROR in startZegoPublish", error: e);
// //     }
// //   }
//
// //   Future<void> stopZegoPublish() async {
// //     return ZegoExpressEngine.instance.stopPublishingStream();
// //   }
//
// //   // Future<void> startZegoPlayStream(String streamID) async {
// //   //   final hasCallState = state as HasCall;
// //   //   try {
// //   //     // Clean up existing remote view if needed
// //   //     if (remoteViewID != null) {
// //   //       await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
// //   //       remoteViewID = null;
// //   //     }
//
// //   //     // Create canvas view for remote stream
// //   //     await ZegoExpressEngine.instance.createCanvasView((viewID) {
// //   //       remoteViewID = viewID;
// //   //       ZegoCanvas canvas = ZegoCanvas(
// //   //         viewID,
// //   //         viewMode: ZegoViewMode.AspectFill,
// //   //       );
// //   //       ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
// //   //     }).then((canvasViewWidget) {
// //   //       emit(hasCallState.copyWith(
// //   //         remoteView: canvasViewWidget,
// //   //         isRemoteVideoEnabled:
// //   //             hasCallState.callData.callType == CallType.video.name,
// //   //       ));
// //   //     });
// //   //   } catch (e) {
// //   //     print("Error in startZegoPlayStream: $e");
// //   //   }
// //   // }
//
// //   // Future<void> startZegoPlayStream(String streamID) async {
// //   //   final hasCallState = state as HasCall;
// //   //   try {
// //   //     print("Starting to play remote stream: $streamID");
//
// //   //     // Clean up existing remote view if needed
// //   //     if (remoteViewID != null) {
// //   //       await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
// //   //       remoteViewID = null;
// //   //     }
//
// //   //     // For audio calls, we still need to play the stream even without video
// //   //     if (hasCallState.callData.callType == CallType.audio.name) {
// //   //       // For audio calls, just start playing the stream without video canvas
// //   //       await ZegoExpressEngine.instance.startPlayingStream(streamID);
// //   //       print("Started playing audio stream: $streamID");
//
// //   //       // Update state to indicate remote user is connected
// //   //       emit(hasCallState.copyWith(
// //   //         isRemoteVideoEnabled: false,
// //   //         remoteView: const SizedBox(),
// //   //       ));
// //   //     } else {
// //   //       // For video calls, create canvas view
// //   //       await ZegoExpressEngine.instance.createCanvasView((viewID) {
// //   //         remoteViewID = viewID;
// //   //         ZegoCanvas canvas = ZegoCanvas(
// //   //           viewID,
// //   //           viewMode: ZegoViewMode.AspectFill,
// //   //         );
// //   //         ZegoExpressEngine.instance
// //   //             .startPlayingStream(streamID, canvas: canvas);
// //   //       }).then((canvasViewWidget) {
// //   //         emit(hasCallState.copyWith(
// //   //           remoteView: canvasViewWidget,
// //   //           isRemoteVideoEnabled: true,
// //   //         ));
// //   //       });
// //   //     }
//
// //   //     // Force enable audio playback
// //   //     await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
// //   //   } catch (e) {
// //   //     print("Error in startZegoPlayStream: $e");
// //   //   }
// //   // }
//
// //   Future<void> startZegoPlayStream(String streamID) async {
// //     final hasCallState = state as HasCall;
// //     try {
// //       LoggingService.info("Starting to play remote stream: $streamID");
//
// //       // Clean up existing remote view if needed
// //       if (remoteViewID != null) {
// //         await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
// //         remoteViewID = null;
// //         LoggingService.info("Previous remote canvas view destroyed");
// //       }
//
// //       // For audio calls, simply play the stream
// //       if (hasCallState.callData.callType == CallType.audio.name) {
// //         // Start playing audio-only stream
// //         await ZegoExpressEngine.instance.startPlayingStream(streamID);
// //         LoggingService.info("Audio-only stream started: $streamID");
//
// //         // Force enable audio playback
// //         await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
// //         await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
//
// //         // Update state for audio call
// //         emit(hasCallState.copyWith(
// //           isRemoteVideoEnabled: false,
// //           remoteView: const SizedBox(),
// //           isCallConnected: true,
// //         ));
// //         LoggingService.info("Audio call UI updated - call connected");
// //         return;
// //       }
//
// //       // For video calls, use our VideoFixHelper for more reliable remote video
// //       LoggingService.info("Creating remote video canvas using VideoFixHelper...");
//
// //       try {
// //         // Using VideoFixHelper for reliable remote video handling
// //         final Widget? canvasWidget = await VideoFixHelper.startPlayStreamWithReliableCanvas(streamID);
//
// //         // Handle the nullable Widget
// //         final Widget actualWidget = canvasWidget ?? Container(
// //           color: Colors.black,
// //           child: const Center(
// //             child: Text('Remote video unavailable', style: TextStyle(color: Colors.white)),
// //           ),
// //         );
//
// //         // Force enable audio playback
// //         await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
// //         await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
//
// //         LoggingService.info("✅ Remote video canvas created successfully");
//
// //         // First update state with the canvas widget
// //         emit(hasCallState.copyWith(
// //           remoteView: actualWidget,
// //           isRemoteVideoEnabled: true,
// //           isCallConnected: true,
// //         ));
// //         LoggingService.info("✅ Remote video UI updated with canvas widget");
//
// //         // Wait a moment then update the state again to ensure UI refresh
// //         await Future.delayed(const Duration(milliseconds: 100));
// //         emit(hasCallState.copyWith(
// //           remoteView: actualWidget,
// //           isRemoteVideoEnabled: true,
// //           isCallConnected: true,
// //         ));
// //         LoggingService.info("✅ Remote video state confirmed with refresh");
//
// //       } catch (e) {
// //         // Fall back to audio-only on error
// //         LoggingService.error("❌ Error creating remote canvas", error: e);
//
// //         await ZegoExpressEngine.instance.startPlayingStream(streamID);
// //         await ZegoExpressEngine.instance.muteAllPlayStreamAudio(false);
//
// //         emit(hasCallState.copyWith(
// //           isRemoteVideoEnabled: false,
// //           remoteView: Container(
// //             color: Colors.black54,
// //             child: Center(child: Text("Video error", style: TextStyle(color: Colors.white))),
// //           ),
// //           isCallConnected: true,
// //         ));
// //       }
//
// //       LoggingService.info("Remote stream setup completed for streamID: $streamID");
// //     } catch (e) {
// //       LoggingService.error("Error in startZegoPlayStream", error: e);
// //     }
// //   }
//
// //   Future<void> stopZegoPlayStream(String streamID) async {
// //     try {
// //       print("Stopping remote stream: $streamID");
// //       await ZegoExpressEngine.instance.stopPlayingStream(streamID);
//
// //       if (remoteViewID != null) {
// //         await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
// //         print("Remote canvas view destroyed: $remoteViewID");
// //         remoteViewID = null;
// //       }
//
// //       final hasCallState = state as HasCall;
// //       emit(hasCallState.copyWith(
// //         remoteView: const SizedBox(),
// //         isRemoteVideoEnabled: false,
// //       ));
// //       print("Remote stream stopped and UI updated");
// //     } catch (e) {
// //       print("Error stopping play stream: $e");
// //     }
// //   }
//
// //   void toggleSpeaker() async {
// //     if (state is HasCall) {
// //       final hasCallState = state as HasCall;
// //       if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
// //         final engine = hasCallState.engine!;
// //         final bool isEnabled = hasCallState.isSpeaker;
// //         await engine.setEnableSpeakerphone(!isEnabled);
// //         emit(hasCallState.copyWith(isSpeaker: !isEnabled));
// //       } else if (hasCallState.isZegoCloud) {
// //         final bool isEnabled = hasCallState.isSpeaker;
// //         ZegoExpressEngine.instance.setAudioRouteToSpeaker(!isEnabled);
// //         emit(hasCallState.copyWith(isSpeaker: !isEnabled));
// //       }
// //       // For ZegoCloud, speaker control is handled by the UI Kit
// //     }
// //   }
//
// //   void toggleMute() async {
// //     if (state is HasCall) {
// //       final hasCallState = state as HasCall;
// //       if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
// //         final engine = hasCallState.engine!;
// //         final bool isMuted = hasCallState.isMute;
// //         await engine.muteLocalAudioStream(!isMuted);
// //         emit(hasCallState.copyWith(isMute: !isMuted));
// //       } else if (hasCallState.isZegoCloud) {
// //         final bool isMuted = hasCallState.isMute;
//
// //         // Toggle microphone state
// //         await ZegoExpressEngine.instance.muteMicrophone(!isMuted);
//
// //         if (isMuted) {
// //           // Was muted, now unmuting - ensure audio is working
// //           await ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
// //           await ZegoExpressEngine.instance.setCaptureVolume(100);
// //           print("Unmuted and enabled audio capture");
// //         } else {
// //           print("Muted microphone");
// //         }
//
// //         emit(hasCallState.copyWith(isMute: !isMuted));
// //       }
// //     }
// //   }
//
// //   // void toggleMute() async {
// //   //   if (state is HasCall) {
// //   //     final hasCallState = state as HasCall;
// //   //     if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
// //   //       final engine = hasCallState.engine!;
// //   //       final bool isMuted = hasCallState.isMute;
// //   //       await engine.muteLocalAudioStream(!isMuted);
// //   //       emit(hasCallState.copyWith(isMute: !isMuted));
// //   //     } else if (hasCallState.isZegoCloud) {
// //   //       final bool isMuted = hasCallState.isMute;
// //   //       ZegoExpressEngine.instance.muteMicrophone(!isMuted);
// //   //       emit(hasCallState.copyWith(isMute: !isMuted));
// //   //     }
// //   //     // For ZegoCloud, mute control is handled by the UI Kit
// //   //   }
// //   // }
//
// //   // Fixed implementation that combines the best of both approaches
// //   void toggleVideo() async {
// //     LoggingService.methodCall("CallCubit", "toggleVideo");
// //     if (state is HasCall) {
// //       final hasCallState = state as HasCall;
//
// //       if (!hasCallState.isZegoCloud && hasCallState.engine != null) {
// //         // Agora implementation remains the same
// //         final engine = hasCallState.engine!;
// //         final bool isVideoEnabled = hasCallState.isVideoEnabled;
//
// //         await engine.enableVideo();
// //         await engine.enableLocalVideo(!isVideoEnabled);
//
// //         if (!isVideoEnabled) {
// //           await engine.startPreview();
// //         } else {
// //           await engine.stopPreview();
// //         }
//
// //         emit(hasCallState.copyWith(isVideoEnabled: !isVideoEnabled));
// //       } else if (hasCallState.isZegoCloud) {
// //         // IMPROVED: ZegoCloud implementation with better sequencing
// //         final bool currentVideoState = hasCallState.isVideoEnabled;
// //         final bool newVideoState = !currentVideoState;
//
// //         try {
// //           LoggingService.info("=== TOGGLING VIDEO: $currentVideoState → $newVideoState ===");
//
// //           // STEP 1: Update UI immediately for a responsive feel
// //           emit(hasCallState.copyWith(isVideoEnabled: newVideoState));
// //           LoggingService.info("UI updated immediately");
//
// //           if (newVideoState) {
// //             // TURNING VIDEO ON
//
// //             // Check permission first
// //             final permissionStatus = await Permission.camera.status;
// //             if (permissionStatus != PermissionStatus.granted) {
// //               LoggingService.warning("❌ Camera permission denied");
// //               emit(hasCallState.copyWith(isVideoEnabled: false));
// //               return;
// //             }
//
// //             try {
// //               // 1. First enable the camera hardware
// //               await ZegoExpressEngine.instance.enableCamera(true);
// //               LoggingService.info("Camera hardware enabled");
//
// //               // 2. Unmute video publishing
// //               await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
// //               LoggingService.info("Video publishing unmuted");
//
// //               // 3. Set video config
// //               await ZegoExpressEngine.instance.setVideoConfig(
// //                 ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset360P)
// //               );
// //               LoggingService.info("Video config set");
//
// //               // 4. Start preview with our improved implementation
// //               await startZegoPreview(isVideoEnabled: true);
// //               LoggingService.info("✅ Video started successfully");
// //             } catch (e) {
// //               LoggingService.error("❌ Error starting video", error: e);
//
// //               // Revert UI on error
// //               emit(hasCallState.copyWith(isVideoEnabled: false));
//
// //               // Ensure hardware is disabled on error
// //               try {
// //                 await ZegoExpressEngine.instance.enableCamera(false);
// //                 await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
// //               } catch (_) {}
// //             }
//
// //           } else {
// //             // TURNING VIDEO OFF
//
// //             try {
// //               // 1. First mute video publishing to stop sending frames
// //               await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
// //               LoggingService.info("Video publishing muted");
//
// //               // 2. Stop preview
// //               await stopZegoPreview();
// //               LoggingService.info("Preview stopped");
//
// //               // 3. Disable camera hardware last
// //               await ZegoExpressEngine.instance.enableCamera(false);
// //               LoggingService.info("Camera hardware disabled");
//
// //               LoggingService.info("✅ Video stopped successfully");
// //             } catch (e) {
// //               LoggingService.error("❌ Error stopping video", error: e);
//
// //               // We don't revert the UI state here as the user intended to turn off video,
// //               // and they'd be confused if the UI showed video as still on
//
// //               // Force ensure camera is off
// //               try {
// //                 await ZegoExpressEngine.instance.enableCamera(false);
// //                 await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
// //               } catch (_) {}
// //             }
// //           }
//
// //         } catch (e) {
// //           LoggingService.error("❌ UNHANDLED ERROR in toggleVideo", error: e);
//
// //           // Revert to initial state on catastrophic error
// //           emit(hasCallState.copyWith(isVideoEnabled: currentVideoState));
// //         }
// //       }
// //     }
// //   }
//
// //   /// Checks and fixes video if it's in an inconsistent state
// //   Future<void> ensureCorrectVideoState() async {
// //     if (state is HasCall) {
// //       final hasCallState = state as HasCall;
// //       if (!hasCallState.isZegoCloud) return;
//
// //       final bool shouldBeEnabled = hasCallState.isVideoEnabled;
// //       LoggingService.info("Checking video consistency - should be ${shouldBeEnabled ? 'enabled' : 'disabled'}");
//
// //       try {
// //         if (shouldBeEnabled) {
// //           // Video should be enabled, verify and fix if needed
// //           await ZegoExpressEngine.instance.enableCamera(true);
// //           await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
//
// //           if (localViewID == null) {
// //             // Recreate preview if needed
// //             await startZegoPreview(isVideoEnabled: true);
// //           }
// //         } else {
// //           // Video should be disabled, verify and fix if needed
// //           await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
// //           await ZegoExpressEngine.instance.enableCamera(false);
// //         }
// //       } catch (e) {
// //         LoggingService.error("Error ensuring video state", error: e);
// //       }
// //     }
// //   }
//
// //   /// Alternative implementation using the video timing manager
// //   Future<void> startZegoPreviewWithTimingManager({required bool isVideoEnabled}) async {
// //     final hasCallState = state as HasCall;
//
// //     try {
// //       LoggingService.info("🎬 Starting Zego preview with timing manager - video enabled: $isVideoEnabled");
//
// //       // Clean up any existing preview first
// //       if (localViewID != null) {
// //         await stopZegoPreview();
// //         localViewID = null;
// //       }
//
// //       // Use the timing manager for better synchronization
// //       final result = await ZegoVideoTimingManager.instance.initializeVideo(
// //         enableVideo: isVideoEnabled,
// //         onCanvasCreated: (viewId) {
// //           localViewID = viewId;
// //           LoggingService.info("📋 Canvas created with ID: $viewId via timing manager");
// //         },
// //         timeout: Duration(seconds: 10),
// //       );
//
// //       if (result.success) {
// //         LoggingService.info("✅ Video initialization successful via timing manager");
// //         LoggingService.info("   Total time: ${result.totalTimeMs}ms");
// //         LoggingService.info("   View ID: ${result.viewId}");
//
// //         // Update state after successful initialization
// //         if (isVideoEnabled) {
// //           emit(hasCallState.copyWith(
// //             localView: null, // Let the widget rebuild
// //             isVideoEnabled: true,
// //           ));
// //           LoggingService.info("✅ Local video view enabled and emitted");
// //         } else {
// //           emit(hasCallState.copyWith(
// //             localView: const SizedBox(),
// //             isVideoEnabled: false,
// //           ));
// //           LoggingService.info("✅ Local audio-only view enabled");
// //         }
//
// //       } else {
// //         LoggingService.warning("❌ Video initialization failed via timing manager");
// //         LoggingService.warning("   Error: ${result.error}");
// //         LoggingService.warning("   Error type: ${result.errorType}");
//
// //         // Fallback to original implementation
// //         LoggingService.info("🔄 Falling back to original implementation...");
// //         await startZegoPreview(isVideoEnabled: isVideoEnabled);
// //       }
//
// //     } catch (e) {
// //       LoggingService.error("❌ Error in timing manager implementation", error: e);
//
// //       // Fallback to original implementation
// //       LoggingService.info("🔄 Falling back to original implementation...");
// //       await startZegoPreview(isVideoEnabled: isVideoEnabled);
// //     }
// //   }
//
// //   // DIAGNOSTIC METHODS for timing and race condition debugging
//
// //   /// Validates the current state of video initialization sequence
// //   Future<Map<String, dynamic>> validateVideoState() async {
// //     final hasCallState = state as HasCall;
// //     final diagnostics = <String, dynamic>{};
//
// //     try {
// //       // Check camera state - ZegoCloud doesn't have direct camera state query
// //       // We'll use our local state tracking instead
// //       diagnostics['cameraEnabled'] = hasCallState.isVideoEnabled;
//
// //       // Check if preview is running (we can't directly query this, but check view state)
// //       diagnostics['localViewID'] = localViewID;
// //       diagnostics['hasLocalView'] = localViewID != null;
//
// //       // Check video publishing state
// //       diagnostics['isVideoEnabled'] = hasCallState.isVideoEnabled;
// //       diagnostics['isRemoteVideoEnabled'] = hasCallState.isRemoteVideoEnabled;
//
// //       // Check call type
// //       diagnostics['callType'] = hasCallState.callData.callType;
// //       diagnostics['isVideoCall'] = hasCallState.callData.callType == CallType.video.name;
//
// //       // Check room state
// //       diagnostics['isZegoCloud'] = hasCallState.isZegoCloud;
// //       diagnostics['roomId'] = hasCallState.callData.zegoRoomId;
//
// //       print("📊 Video State Diagnostics: $diagnostics");
// //       return diagnostics;
//
// //     } catch (e) {
// //       diagnostics['error'] = e.toString();
// //       print("❌ Error in video state validation: $e");
// //       return diagnostics;
// //     }
// //   }
//
// //   /// Forces video re-initialization with improved timing
// //   Future<void> forceVideoReinitialization() async {
// //     final hasCallState = state as HasCall;
//
// //     if (!hasCallState.isZegoCloud || hasCallState.callData.callType != CallType.video.name) {
// //       print("❌ Not a ZegoCloud video call, skipping re-initialization");
// //       return;
// //     }
//
// //     try {
// //       print("🔄 Starting forced video re-initialization...");
//
// //       // STEP 1: Stop everything cleanly
// //       await stopZegoPreview();
// //       await Future.delayed(Duration(milliseconds: 300));
//
// //       // STEP 2: Clear any hanging callbacks
// //       ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = null;
// //       ZegoExpressEngine.onPublisherRenderVideoFirstFrame = null;
//
// //       // STEP 3: Re-setup event handlers
// //       startZegoListenEvent();
//
// //       // STEP 4: Restart video with proper timing
// //       await Future.delayed(Duration(milliseconds: 200));
// //       await startZegoPreview(isVideoEnabled: true);
//
// //       print("✅ Video re-initialization completed");
//
// //     } catch (e) {
// //       print("❌ Error during video re-initialization: $e");
// //     }
// //   }
//
// //   /// Checks if video timing issues are occurring
// //   Future<bool> detectVideoTimingIssues() async {
// //     final diagnostics = await validateVideoState();
//
// //     // Check for common timing issue patterns
// //     final hasTimingIssues =
// //       (diagnostics['isVideoCall'] == true &&
// //        diagnostics['cameraEnabled'] == true &&
// //        diagnostics['hasLocalView'] == false) ||
// //       (diagnostics['isVideoEnabled'] == true &&
// //        diagnostics['localViewID'] == null) ||
// //       (diagnostics['callType'] == CallType.video.name &&
// //        diagnostics['cameraEnabled'] == false);
//
// //     if (hasTimingIssues) {
// //       print("⚠️ Video timing issues detected! Diagnostics: $diagnostics");
// //       return true;
// //     }
//
// //     return false;
// //   }
//
// //   /// Simple, reliable implementation of video toggle that uses VideoFixHelper
// //   /// This is the preferred method to use from UI components
// //   void toggleVideoSimple() async {
// //     LoggingService.methodCall("CallCubit", "toggleVideoSimple");
//
// //     if (state is HasCall) {
// //       final hasCallState = state as HasCall;
//
// //       if (!hasCallState.isZegoCloud) {
// //         // Fall back to original implementation for non-ZegoCloud
// //         toggleVideo();
// //         return;
// //       }
//
// //       try {
// //         final bool currentState = hasCallState.isVideoEnabled;
// //         LoggingService.info("🎬 Simple video toggle: $currentState → ${!currentState}");
//
// //         // Use the reliable implementation from VideoFixHelper
// //         final success = await VideoFixHelper.toggleVideo(
// //           currentlyEnabled: currentState,
// //           onStateChanged: (newState) {
// //             // This callback is called immediately to update UI
// //             emit(hasCallState.copyWith(isVideoEnabled: newState));
// //             LoggingService.info("✅ UI state updated immediately to: $newState");
// //           }
// //         );
//
// //         if (success) {
// //           LoggingService.info("✅ Video toggle completed successfully");
//
// //           // After successful toggle, update preview if needed
// //           if (!currentState) {  // If turning ON
// //             // Small delay to ensure state changes are synchronized
// //             await Future.delayed(Duration(milliseconds: 100));
//
// //             final Widget? canvasWidget = await VideoFixHelper.startPreviewWithReliableCanvas(
// //               isVideoEnabled: true
// //             );
//
// //             if (canvasWidget != null) {
// //               emit(hasCallState.copyWith(
// //                 localView: canvasWidget,
// //                 isVideoEnabled: true
// //               ));
// //               LoggingService.info("✅ Local view updated with new canvas");
// //             } else {
// //               // Fallback to empty widget if canvas creation failed
// //               emit(hasCallState.copyWith(
// //                 localView: const SizedBox(),
// //                 isVideoEnabled: false
// //               ));
// //               LoggingService.warning("⚠️ Canvas widget is null, falling back to empty view");
// //             }
// //           }
// //         } else {
// //           LoggingService.warning("⚠️ Video toggle operation failed");
//
// //           // Ensure UI matches actual camera state
// //           await ensureCorrectVideoState();
// //         }
//
// //       } catch (e) {
// //         LoggingService.error("❌ Error in toggleVideoSimple", error: e);
//
// //         // Fall back to old implementation on error
// //         LoggingService.info("🔄 Falling back to original implementation");
// //         toggleVideo();
// //       }
// //     }
// //   }
//
// //   /// Manually refreshes the remote video stream when user reports problems
// //   Future<void> manualRefreshRemoteVideo() async {
// //     if (state is! HasCall || _remoteStreamID == null) {
// //       LoggingService.warning("Cannot refresh remote video - no active call or stream");
// //       return;
// //     }
//
// //     final hasCallState = state as HasCall;
// //     final streamID = _remoteStreamID!;
// //     final isVideoCall = hasCallState.callData.callType == CallType.video.name;
//
// //     if (!isVideoCall) {
// //       LoggingService.info("Not a video call - nothing to refresh");
// //       return;
// //     }
//
// //     try {
// //       LoggingService.info("🔄 Manual refresh of remote video requested");
//
// //       // First show loading indicator
// //       emit(hasCallState.copyWith(
// //         remoteView: Center(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               CircularProgressIndicator(color: Colors.white),
// //               SizedBox(height: 16),
// //               Text("Refreshing video...", style: TextStyle(color: Colors.white))
// //             ],
// //           ),
// //         ),
// //       ));
//
// //       // Step 1: Stop existing stream playback
// //       await ZegoExpressEngine.instance.stopPlayingStream(streamID);
// //       LoggingService.info("✅ Previous stream stopped");
//
// //       // Step 2: Short delay for system to clean up resources
// //       await Future.delayed(Duration(milliseconds: 300));
//
// //       // Step 3: Start playing stream again with canvas
// //       if (remoteViewID != null) {
// //         await ZegoExpressEngine.instance.destroyCanvasView(remoteViewID!);
// //         remoteViewID = null;
// //       }
//
// //       // Step 4: Create new canvas view
// //       final Widget? canvasWidget = await ZegoExpressEngine.instance.createCanvasView((viewID) {
// //         remoteViewID = viewID;
//
// //         // Create canvas with view mode that preserves aspect ratio
// //         final canvas = ZegoCanvas(
// //           viewID,
// //           viewMode: ZegoViewMode.AspectFill,
// //         );
//
// //         // Start playing the stream
// //         ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
// //         LoggingService.info("✅ Remote stream playback restarted");
// //       });
//
// //       // Step 5: Update UI with new canvas if available
// //       if (canvasWidget != null) {
// //         emit(hasCallState.copyWith(
// //           remoteView: canvasWidget,
// //           isRemoteVideoEnabled: true,
// //         ));
// //         LoggingService.info("✅ Remote video UI refreshed successfully");
// //       } else {
// //         // Fallback UI if canvas creation failed
// //         emit(hasCallState.copyWith(
// //           remoteView: Container(
// //             color: Colors.black54,
// //             child: Center(
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Icon(Icons.error_outline, color: Colors.white, size: 48),
// //                   SizedBox(height: 12),
// //                   Text("Could not refresh video", style: TextStyle(color: Colors.white)),
// //                   SizedBox(height: 8),
// //                   Text("Try again later", style: TextStyle(color: Colors.white70, fontSize: 12)),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           isRemoteVideoEnabled: false,
// //         ));
// //         LoggingService.error("❌ Failed to create canvas for remote video");
// //       }
//
// //       // Step 6: Ensure audio is always working regardless of video state
// //       await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
//
// //     } catch (e) {
// //       LoggingService.error("❌ Error refreshing remote video", error: e);
//
// //       // Update UI with error state
// //       emit(hasCallState.copyWith(
// //         remoteView: Container(
// //           color: Colors.black54,
// //           child: Center(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
// //                 SizedBox(height: 12),
// //                 Text("Video refresh failed", style: TextStyle(color: Colors.white)),
// //                 SizedBox(height: 8),
// //                 Text("Error: ${e.toString().substring(0, min(e.toString().length, 50))}",
// //                   style: TextStyle(color: Colors.white70, fontSize: 12)),
// //               ],
// //             ),
// //           ),
// //         ),
// //         isRemoteVideoEnabled: false,
// //       ));
//
// //       // Try to recover audio at least
// //       try {
// //         await ZegoExpressEngine.instance.startPlayingStream(streamID);
// //         await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
// //       } catch (_) {}
// //     }
// //   }
// // }
