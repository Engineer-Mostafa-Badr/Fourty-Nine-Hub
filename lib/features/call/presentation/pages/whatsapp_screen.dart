// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'dart:io';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../authentication/data/models/user_model.dart';
// import '../../domain/entities/call_data.dart';
// import '../controller/call_controller/call_cubit.dart';
// import '../controller/call_controller/call_state.dart';
// import '../controller/send_call_controller.dart/send_call_cubit.dart';
// import '../controller/send_call_controller.dart/send_call_states.dart';
// import 'zego_call_page.dart';
// import '../../widgets/build_app_bar.dart';
// import '../../widgets/build_bottom_btns.dart';
// import '../../widgets/screen_lock_manager.dart';
// import '../../widgets/ui_fake_call.dart';
// import 'package:zego_express_engine/zego_express_engine.dart';
//
// class WhatsAppCallScreen extends StatefulWidget {
//   const WhatsAppCallScreen({
//     super.key,
//   });
//
//   @override
//   State<WhatsAppCallScreen> createState() => _WhatsAppCallScreenState();
// }
//
// class _WhatsAppCallScreenState extends State<WhatsAppCallScreen>
//     with WidgetsBindingObserver {
//   static const platform =
//       MethodChannel('com.fourtyninehub.app/background_service');
//   bool isKeepScreenOn = true;
//   late final CallCubit _callCubit;
//   bool _isDisposed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _callCubit = context.read<CallCubit>();
//     _initializeZegoEngine();
//
//     _enableKeepScreenOn();
//   }
//
//   Future<void> _initializeZegoEngine() async {
//     try {
//       print('Initializing ZegoCloud engine...');
//       // Use the centralized engine initialization
//       await CallCubit.initializeZegoEngine();
//       await Future.delayed(const Duration(milliseconds: 100));
//       _callCubit.checkIfThereIsCall();
//     } catch (e) {
//       print('Error initializing ZegoCloud engine: $e');
//       _callCubit.checkIfThereIsCall();
//     }
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       // App is in background or screen is locked
//       _handleAppInBackground();
//     } else if (state == AppLifecycleState.resumed) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _handleResumed();
//       });
//       if (isKeepScreenOn) {
//         _enableKeepScreenOn();
//       }
//     }
//     super.didChangeAppLifecycleState(state);
//   }
//
//   void _handleAppInBackground() {
//     // Safety check
//     if (!mounted) return;
//
//     final callState = context.read<CallCubit>().state;
//     if (callState is HasCall) {
//       if (callState.isZegoCloud) {
//         ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
//           advancedConfig: {
//             "audio.capture.force_using_media_recorder": "true",
//             "audio.captureAndRender.androidLowLatencyEnabled": "true",
//             "background.mode.enabled": "true",
//             "audio.process.continue.in.background": "true",
//             "audio.audioRecord.bluetooth_disable_aec": "true",
//             "audio.audioRecord.disable_aes": "true",
//             "audio.audioRecord.keep.audiosession.active": "true",
//             "audio.capture.prevent.system.suspend": "true",
//             "audio.capture.continuous.background.mode": "true",
//             "audio.audioRecord.low.latency": "true",
//             "audio.voice.communication.mode": "true",
//             "android.audio.session.alwaysOn": "true",
//             "audio.record.keep.awake": "true",
//             "audio.capture.nodata.protection": "false",
//             "android.audio.focus.permanent": "true",
//           },
//         ));
//         if (Platform.isAndroid) {
//           _safelyCallPlatformMethod('releaseWakeLock');
//         }
//         ZegoExpressEngine.instance.enableAudioCaptureDevice(true);
//       } else if (callState.engine != null) {
//         callState.engine!.enableAudio();
//       }
//     }
//   }
//
//   // Safely call platform methods with proper error handling
//   Future<void> _safelyCallPlatformMethod(String method,
//       [dynamic arguments]) async {
//     if (Platform.isAndroid) {
//       try {
//         await platform.invokeMethod(method, arguments);
//       } catch (e) {
//         // Check if this is a MissingPluginException
//         if (e.toString().contains('MissingPluginException')) {
//           print(
//               'Method $method not implemented in native platform. This is expected in some environments.');
//         } else {
//           print('Error calling platform method $method: $e');
//         }
//       }
//     }
//   }
//
//   void _handleResumed() async {
//     // await Future.delayed(const Duration(seconds: 1));
//     // if (mounted) context.read<CallCubit>().checkIfThereIsCall();
//   }
//
//   // Enable wakelock to keep screen on
//   Future<void> _enableKeepScreenOn() async {
//     await ScreenWakeLockManager.keepScreenOn();
//     setState(() {
//       isKeepScreenOn = true;
//     });
//   }
//
//   // Disable wakelock to allow screen to turn off
//   Future<void> _disableKeepScreenOn() async {
//     await ScreenWakeLockManager.allowScreenOff();
//     setState(() {
//       isKeepScreenOn = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     if (context.read<CallCubit>().state is HasCall) {
//       final state = context.read<CallCubit>().state as HasCall;
//       if (state.engine != null) {
//         state.engine!.registerEventHandler(RtcEngineEventHandler());
//       }
//     }
//     _isDisposed = true; // Mark as disposed
//     WidgetsBinding.instance.removeObserver(this);
//     _disableKeepScreenOn();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       onPopInvoked: (val) {
//         // When user tries to go back, minimize the call instead
//       },
//       child:
//           BlocBuilder<SendCallCubit, SendCallState>(builder: (context, state) {
//         if (state is CallMinimized) {
//           return const SizedBox();
//         }
//         return BlocBuilder<CallCubit, CallState>(
//           builder: (context, state) {
//             print("📞 DEBUG: WhatsAppCallScreen state change - ${state.runtimeType}");
//
//             if (state is HasCall) {
//               print("📞 DEBUG: Building call UI for HasCall state");
//               print("📞 DEBUG: Call details - Channel: ${state.callData.channelId}, isZegoCloud: ${state.isZegoCloud}");
//               print("📞 DEBUG: Room ID: ${state.callData.zegoRoomId}");
//
//               if (state.isZegoCloud) {
//                 print("📞 DEBUG: Rendering ZegoCallPage");
//                 return Positioned.fill(
//                   child: ZegoCallPage(
//                     callData: state.callData,
//                   ),
//                 );
//               } else {
//                 print("📞 DEBUG: Rendering VoiceCallingScreen (Agora)");
//                 return Positioned.fill(
//                     child: VoiceCallingScreen(callData: state.callData));
//               }
//             } else {
//               print("📞 DEBUG: No active call detected - state is ${state.runtimeType}");
//               print("📞 DEBUG: Initiating navigation pop to return to previous screen");
//
//               // If there's no active call, pop back to previous screen
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 print("📞 DEBUG: PostFrameCallback executing - checking navigation conditions");
//                 print("📞 DEBUG: _isDisposed: $_isDisposed, Navigator.canPop: ${Navigator.canPop(context)}");
//
//                 if (!_isDisposed && Navigator.canPop(context)) {
//                   print("📞 DEBUG: ✅ Popping WhatsAppCallScreen - returning to previous screen");
//                   Navigator.of(context).pop();
//                 } else {
//                   print("📞 DEBUG: ❌ Cannot pop - either disposed or no route to pop");
//                   if (_isDisposed) print("📞 DEBUG: Screen is disposed");
//                   if (!Navigator.canPop(context)) print("📞 DEBUG: No route to pop");
//                 }
//               });
//               return const SizedBox();
//             }
//           },
//         );
//       }),
//     );
//   }
// }
//
// class VoiceCallingScreen extends StatefulWidget {
//   const VoiceCallingScreen({
//     super.key,
//     required this.callData,
//   });
//
//   final CallData callData;
//
//   @override
//   State<VoiceCallingScreen> createState() => _VoiceCallingScreenState();
// }
//
// class _VoiceCallingScreenState extends State<VoiceCallingScreen> {
//   int? _remoteUid;
//   bool _isRemoteVideoEnabled = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color(0xFF121212),
//         extendBody: true,
//         body: BlocBuilder<SendCallCubit, SendCallState>(
//           builder: (context, state) {
//             if (state is CallMinimized) {
//               return const SizedBox();
//             }
//             return BlocBuilder<CallCubit, CallState>(
//               builder: (context, state) {
//                 if (state is HasCall) {
//                   print("VoiceCallingScreen call state1 $state");
//                   if (state.callData.isRealCall == true.toString()) {
//                     print("VoiceCallingScreen call state2 $state");
//                     if (state.engine != null) {
//                       // Setup event handler for remote user
//                       state.engine!.registerEventHandler(
//                         RtcEngineEventHandler(
//                           onJoinChannelSuccess: (connection, elapsed) {
//                             print(
//                                 "Local user joined channel: ${connection.channelId}");
//                           },
//                           onUserJoined: (connection, remoteUid, elapsed) {
//                             print("Remote user joined: $remoteUid");
//                             setState(() {
//                               _remoteUid = remoteUid;
//                             });
//                           },
//                           onUserOffline: (connection, remoteUid, reason) {
//                             print("Remote user left: $remoteUid");
//                             setState(() {
//                               _remoteUid = null;
//                               _isRemoteVideoEnabled = false;
//                             });
//                           },
//                           onRemoteVideoStateChanged:
//                               (connection, remoteUid, state, reason, elapsed) {
//                             print(
//                                 "Remote video state changed: uid=$remoteUid, state=$state, reason=$reason");
//                             setState(() {
//                               _remoteUid = remoteUid;
//                               _isRemoteVideoEnabled = state ==
//                                       RemoteVideoState
//                                           .remoteVideoStateStarting ||
//                                   state ==
//                                       RemoteVideoState.remoteVideoStateDecoding;
//                               print(
//                                   '_isRemoteVideoEnabled $_isRemoteVideoEnabled and remoteUid $_remoteUid');
//                             });
//                           },
//                         ),
//                       );
//                     }
//
//                     return Stack(
//                       children: [
//                         // Video Layer or Background
//                         state.isVideoEnabled
//                             ? _buildAgoraVideoLayer(state)
//                             : Image.asset(
//                                 'assets/images/whatsapp_bacground.png',
//                                 fit: BoxFit.cover,
//                                 height: double.infinity,
//                                 width: double.infinity,
//                               ),
//
//                         // UI Layer with controls and info
//                         _buildUILayer(state),
//                       ],
//                     );
//                   } else {
//                     print("VoiceCallingScreen call state3 $state");
//                     return UIFakeCall(
//                       receiver: UserModel(
//                         id: widget.callData.receiverId,
//                         firstName: widget.callData.receiverName,
//                         lastName: '',
//                         profilePicture: widget.callData.receiverImage,
//                       ),
//                       onMorePressed: () {},
//                     );
//                   }
//                 }
//                 return const SizedBox();
//               },
//             );
//           }, // BlocBuilder<CallCubit, CallState>(builder: (context, state) {
//         ));
//   }
//
//   Widget _buildAgoraVideoLayer(HasCall state) {
//     if (state.engine == null) return Container(color: Colors.black);
//
//     return Stack(
//       children: [
//         // Background color
//         Container(color: Colors.black),
//
//         // Remote Video (if available and enabled)
//         if (_remoteUid != null && _isRemoteVideoEnabled)
//           Positioned.fill(
//             child: AgoraVideoView(
//               controller: VideoViewController.remote(
//                 rtcEngine: state.engine!,
//                 canvas: VideoCanvas(
//                   uid: _remoteUid,
//                   renderMode: RenderModeType.renderModeFit,
//                   sourceType: VideoSourceType.videoSourceRemote,
//                 ),
//                 connection: RtcConnection(
//                   channelId:
//                       //  "8a5e17cd-d07c-4b2c-83ba-9e59a0dfd864"
//                       state.callData.channel,
//                 ),
//               ),
//             ),
//           ),
//
//         // Local Video
//         if (state.isVideoEnabled)
//           Positioned(
//             right: 16,
//             top: 100,
//             child: Container(
//               width: 150,
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.white, width: 2),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: state.engine!,
//                     canvas: const VideoCanvas(
//                       uid: 0,
//                       renderMode: RenderModeType.renderModeFit,
//                       mirrorMode: VideoMirrorModeType.videoMirrorModeEnabled,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildUILayer(HasCall state) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         BuildAppBar(
//           receiver: UserModel(
//             id: widget.callData.receiverId,
//             firstName: widget.callData.receiverName,
//             lastName: '',
//             profilePicture: widget.callData.receiverImage,
//           ),
//         ),
//
//         // Profile Picture (only show when video is off)
//         if (!state.isVideoEnabled && !_isRemoteVideoEnabled)
//           Container(
//             width: 220,
//             height: 220,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: NetworkImage(state.callData.receiverImage ??
//                     'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
//               ),
//             ),
//           ),
//
//         // Bottom Buttons
//         BuildBottomBtns(
//             currentContext: context,
//             state: state,
//             callData: widget.callData,
//             onMorePressed: () {
//               // Handle more options
//             }),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     if (context.read<CallCubit>().state is HasCall) {
//       final state = context.read<CallCubit>().state as HasCall;
//       if (state.engine != null) {
//         state.engine!.registerEventHandler(RtcEngineEventHandler());
//       }
//     }
//     super.dispose();
//   }
// }
