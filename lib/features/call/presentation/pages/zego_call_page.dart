import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_states.dart';
import 'package:fourtyninehub/features/call/widgets/build_app_bar.dart';
import 'package:fourtyninehub/features/call/widgets/build_bottom_btns.dart';
import 'package:fourtyninehub/features/call/widgets/screen_lock_manager.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoCallPage extends StatefulWidget {
  const ZegoCallPage({
    super.key,
    required this.callData,
  });

  final CallData callData;

  @override
  State<ZegoCallPage> createState() => _ZegoCallPageState();
}

// Change from private to public to allow access from BuildBottomBtns
class _ZegoCallPageState extends State<ZegoCallPage>
    with WidgetsBindingObserver {
  static const platform =
      MethodChannel('com.fourtyninehub.app/background_service');

  final floating = Floating();

  // Make this method public by removing the underscore
  Future<void> enablePip(
    BuildContext context, {
    bool autoEnable = false,
  }) async {
    const rational = Rational.landscape();
    final screenSize =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final arguments = autoEnable
        ? OnLeavePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          )
        : ImmediatePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          );

    final status = await floating.enable(arguments);
    debugPrint('PiP enabled? $status');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
      advancedConfig: {
        "audio.capture.force_using_media_recorder": "true",
        "audio.enable.aec": "true", // Echo cancellation
        "audio.enable.agc": "true", // Auto gain control
        "audio.enable.ans": "true", // Noise suppression
        "audio.voice.communication.mode": "true",
        "background.mode.enabled": "true",
        "audio.process.continue.in.background": "true",
        "android.audio.focus.request": "true",
        "audio.audioRecord.keep.audiosession.active": "true",
        "audio.audioRecord.low.latency": "true",
      },
    ));

    if (!widget.callData.isCaller) {
      context.read<SendCallCubit>().setCallConnected();
    }

    // CRITICAL: Use consistent user ID
    final userId =
        getUserId(); // This will now return receiverId for both users

    print("=== ZEGO CALL INIT ===");
    print("Is Caller: ${widget.callData.isCaller}");
    print("User ID: $userId");
    print("Room ID: ${widget.callData.zegoRoomId}");
    print("Receiver Name: ${widget.callData.receiverName}");

    // Start the call process
    context.read<CallCubit>().loginZegoRoom(
          roomId: widget.callData.zegoRoomId,
          userID: userId,
          userName: userId, // Use same value for consistency
        );

    _enableKeepScreenOn();
    _setupBackgroundKeepAlive();
    enableFloatingWhileMinimizedViaSystem();
  }

  enableFloatingWhileMinimizedViaSystem() async {
    print('Enabling floating while minimized via system...');
    await floating.enable(const OnLeavePiP()
        // const ImmediatePiP(),
        );
  }

  bool isKeepScreenOn = true;
  Timer? _backgroundTimer;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      enableFloatingWhileMinimizedViaSystem();
      // App is in background or screen is locked
      _handleAppInBackground();
    } else if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleResumed();
      });
      if (isKeepScreenOn) {
        _enableKeepScreenOn();
      }
    } else if (state == AppLifecycleState.detached) {
      enableFloatingWhileMinimizedViaSystem();
      // App is in background or screen is locked
      _handleAppInBackground();
    } else if (state == AppLifecycleState.hidden) {
      _handleAppInBackground();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _handleAppInBackground() {
    // Safety check
    if (!mounted) return;

    final callState = context.read<CallCubit>().state;
    if (callState is HasCall) {
      if (callState.isZegoCloud) {
        print('Zego Cloud Call in background - ensuring audio continues');

        // Start the native background service to maintain audio
        _startBackgroundService();

        // Ultra aggressive background mode config
        ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
          advancedConfig: {
            "audio.captureAndRender.continuousInBackgroundMode": "true",
            "background.mode.enabled": "true",
            "audio.process.continue.in.background": "true",
            "audio.audioRecord.keep.audiosession.active": "true",
            "audio.capture.prevent.system.suspend": "true",
            "audio.capture.continuous.background.mode": "true",
            "audio.audioRecord.low.latency": "true",
            "audio.voice.communication.mode": "true",
            "android.audio.session.alwaysOn": "true",
            "audio.record.keep.awake": "true",
            "audio.capture.nodata.protection": "false",
            "android.audio.focus.permanent": "true",
          },
        ));

        // Call the special background handling method
        context.read<CallCubit>().handleAppBackground();

        // Use safer wakelock handling through the native side
        if (Platform.isAndroid) {
          _safelyCallPlatformMethod('acquireWakeLock');
        }

        // Super aggressive background timer with slightly longer interval to reduce battery usage
        _backgroundTimer?.cancel();
        _backgroundTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
          // Check if we're still in a call state before taking actions
          if (!mounted) {
            timer.cancel();
            return;
          }

          try {
            final currentState = context.read<CallCubit>().state;
            if (currentState is HasCall) {
              // Force enable audio
              ZegoExpressEngine.instance.enableAudioCaptureDevice(true);

              if (!currentState.isMute) {
                ZegoExpressEngine.instance.muteMicrophone(false);
                // Use moderate volume for better quality
                ZegoExpressEngine.instance.setCaptureVolume(80);
              }

              // Re-publish stream frequently to keep connection active
              final userId = widget.callData.receiverName;
              final streamID = '${widget.callData.zegoRoomId}_${userId}_call';
              ZegoExpressEngine.instance.startPublishingStream(streamID);

              // Refresh wakelock and audio focus periodically
              if (timer.tick % 10 == 0) {
                // Every 5 seconds
                if (Platform.isAndroid) {
                  _safelyCallPlatformMethod('keepServiceAlive');
                }
              }
            } else {
              timer.cancel();
              _backgroundTimer = null;
            }
          } catch (e) {
            print('Error in background timer: $e');
          }
        });
      } else if (callState.engine != null) {
        callState.engine!.enableAudio();
      }
    }
  }

  Future<void> _startBackgroundService() async {
    if (Platform.isAndroid) {
      // Pass call data to the background service
      final callInfo = {
        'roomId': widget.callData.zegoRoomId,
        'userId': getUserId(),
        'isVideoCall': widget.callData.callType == 'video',
      };
      _safelyCallPlatformMethod('startBackgroundService', callInfo);
    }
  }

  Future<void> _handleResumed() async {
    // Cancel background timer when app resumes
    _backgroundTimer?.cancel();
    _backgroundTimer = null;

    // await Future.delayed(const Duration(seconds: 1));
    // if (mounted) context.read<CallCubit>().checkIfThereIsCall();
  }

  // Enable wakelock to keep screen on
  Future<void> _enableKeepScreenOn() async {
    await ScreenWakeLockManager.keepScreenOn();
    setState(() {
      isKeepScreenOn = true;
    });
  }

  // Disable wakelock to allow screen to turn off
  Future<void> _disableKeepScreenOn() async {
    await ScreenWakeLockManager.allowScreenOff();
    setState(() {
      isKeepScreenOn = false;
    });
  }

  String getUserId() {
    // Use a more consistent user ID generation
    final callData = widget.callData;
    if (callData.isCaller) {
      return 'caller_${callData.receiverId}';
    } else {
      return 'receiver_${callData.receiverId}';
    }
  }

  // String getUserId() {
  //   Random rand = Random();
  //   return rand.nextInt(100000000).toString();
  // }

  @override
  void dispose() {
    print("Disposing ZegoCallPage...");
    // Force disable PiP when leaving this screen
    _forceDisablePip();

    // Ensure timer is cleaned up
    _backgroundTimer?.cancel();
    _backgroundTimer = null;

    // Release wake lock
    if (Platform.isAndroid) {
      try {
        platform.invokeMethod('releaseWakeLock');
      } catch (e) {
        // Ignore errors here
      }
    }

    WidgetsBinding.instance.removeObserver(this);
    context.read<CallCubit>().stopZegoListenEvent();
    _disableKeepScreenOn();
    floating.cancelOnLeavePiP();
    super.dispose();
  }

  // More aggressive approach to force disable PiP mode
  Future<void> _forceDisablePip() async {
    print('Force disabling PiP...');
    try {
      await floating.cancelOnLeavePiP();
    } catch (e) {
      print('Failed to disable PiP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        await _forceDisablePip();
      },
      child: PiPSwitcher(
        childWhenEnabled: _viewWhenEnabledPipSwitcher(),
        childWhenDisabled: _buildBody(),
      ),
    );
  }

  Widget _viewWhenEnabledPipSwitcher() {
    return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: BlocBuilder<SendCallCubit, SendCallState>(
            builder: (context, state) {
          if (state is CallMinimized) {
            print('Call is minimized now');
            return const SizedBox.shrink();
          }
          return BlocBuilder<CallCubit, CallState>(builder: (context, state) {
            if (state is HasCall) {
              print(
                  "I am in zego call page  and pip switcher so call type is ${(state.isVideoEnabled == true)}");
              return _buildZegoVideoLayer(state);
            } else {
              print(
                  "I am in zego call page  and SizedBox.shrink() pip switcher so call type is ");
              return const SizedBox.shrink();
            }
          });
        }));
  }

  Widget _buildBody() {
    // context.read<CallCubit>().debugAudioState();
    return Scaffold(
        backgroundColor: AppColors.PRIMARY_COLOR,
        extendBody: true,
        body: BlocBuilder<CallCubit, CallState>(
          builder: (context, state) {
            if (state is HasCall) {
              print(
                  "I am in zego call page  and call type is ${(state.isVideoEnabled == true)}");

              return Stack(
                children: [
                  // Video Layer or Background
                  // state.isVideoEnabled &&

                  _buildZegoVideoLayer(state),

                  // UI Layer with controls and info
                  _buildUILayer(state),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ));
  }

  Widget _buildZegoVideoLayer(HasCall state) {
    print("Building Zego Video Layer with state: $state");
    return Stack(
      children: [
        Image.asset(
          'assets/images/whatsapp_bacground.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        // Container(color: const Color(0xFF121212)),        // Remote Video - Enhanced logic to handle both state flags and actual widget
        _buildRemoteVideoWidget(state),

        // Local Video (Small Window)
        if (state.isVideoEnabled)
          Positioned(
            right: 16,
            top: 100,
            child:            Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: state.localView,
              ),
            ),
          ),
      ],
    );
  }
  Widget _buildRemoteVideoWidget(HasCall state) {
    // Check if we have both the flag enabled AND a valid remote view widget
    final bool hasValidRemoteVideo = state.isRemoteVideoEnabled && 
        state.remoteView is! SizedBox;
    
    if (hasValidRemoteVideo) {
      print("✅ Displaying remote video - enabled: ${state.isRemoteVideoEnabled}, has widget: ${state.remoteView.runtimeType}");
      return Positioned.fill(child: state.remoteView);
    } else {
      // Determine the appropriate placeholder based on call state
      String placeholderText;
      IconData placeholderIcon;
      
      if (state.isCallConnected) {
        // if (state.callData.callType == 'video') {
          placeholderText = state.isRemoteVideoEnabled 
              ? "Connecting video..."
              : "Camera turned off";
          placeholderIcon = state.isRemoteVideoEnabled 
              ? Icons.hourglass_bottom
              : Icons.videocam_off;
        // } else {
        //   placeholderText = "Audio call";
        //   placeholderIcon = Icons.phone;
        // }
      } else {
        placeholderText = "Connecting...";
        placeholderIcon = Icons.hourglass_bottom;
      }
      
      print("📱 Remote video placeholder - enabled: ${state.isRemoteVideoEnabled}, connected: ${state.isCallConnected}, widget: ${state.remoteView.runtimeType}");
      
      return Positioned.fill(
        child: Container(
          color: const Color(0xFF121212),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  placeholderIcon,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  placeholderText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildUILayer(HasCall state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildAppBar(
          receiver: UserModel(
            id: widget.callData.receiverId,
            firstName: widget.callData.receiverName,
            lastName: '',
            profilePicture: widget.callData.receiverImage,          ),
        ),

        // Profile Picture (only show when video is off)
        if (!state.isVideoEnabled && !state.isRemoteVideoEnabled)
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(              state.callData.receiverImage.isEmpty 
                  ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
                  : state.callData.receiverImage,
            ),
          ),

        // Bottom Buttons
        BuildBottomBtns(
          currentContext: context,
          state: state,
          callData: widget.callData,
          onMorePressed: () {},
        ),
      ],
    );
  }

  // Widget _buildBottomBtns(HasCall state) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
  //     margin: const EdgeInsets.only(bottom: 34, left: 18, right: 18),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF11191C),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         CallControlButton(
  //           icon: Icons.more_horiz_rounded,
  //           onPressed: () {},
  //         ),
  //         _fixedWidth(),
  //         CallControlButton(
  //           icon: state.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
  //           onPressed: toggleVideo,
  //           backgroundColor:
  //               state.isVideoEnabled ? Colors.green : Colors.transparent,
  //           iconColor: Colors.white,
  //         ),
  //         _fixedWidth(),
  //         CallControlButton(
  //           icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
  //           onPressed: toggleSpeaker,
  //         ),
  //         _fixedWidth(),
  //         CallControlButton(
  //           icon: _isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
  //           onPressed: toggleMute,
  //         ),
  //         _fixedWidth(),
  //         CallControlButton(
  //           icon: Icons.call_end,
  //           onPressed: () => endCall(state),
  //           backgroundColor: Colors.red,
  //           iconColor: Colors.white,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _fixedWidth() {
  //   return const SizedBox(width: 12);
  // }

  /*
   Positioned(
          bottom: MediaQuery.of(context).size.height / 15,
          left: 0,
          right: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(), backgroundColor: Colors.red),
                  onPressed: () {
                    logoutRoom();
                    Navigator.pop(context);
                  },
                  child: const Center(child: Icon(Icons.call_end, size: 32)),
                ),
              ],
            ),
          ),
        ),
  */

  // Make background keep-alive more battery-efficient
  void _setupBackgroundKeepAlive() {
    _backgroundTimer?.cancel();
    _backgroundTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      // First check if the widget is still mounted before proceeding
      if (!mounted) {
        timer.cancel();
        _backgroundTimer = null;
        return;
      }

      try {
        final currentState = context.read<CallCubit>().state;
        if (currentState is HasCall) {
          // Ensure audio connection is active
          ZegoExpressEngine.instance.enableAudioCaptureDevice(true);

          if (!currentState.isMute) {
            ZegoExpressEngine.instance.setCaptureVolume(80);
            ZegoExpressEngine.instance.muteMicrophone(false);
          }

          // Use a safer wake lock mechanism
          if (Platform.isAndroid) {
            _safelyCallPlatformMethod('keepServiceAlive');
          }
        } else {
          timer.cancel();
          _backgroundTimer = null;

          // Release wake lock when call ends
          if (Platform.isAndroid) {
            _safelyCallPlatformMethod('releaseWakeLock');
          }
        }
      } catch (e) {
        print('Error in background keep-alive timer: $e');
      }
    });
  }

  // Safely call platform methods with proper error handling
  Future<void> _safelyCallPlatformMethod(String method,
      [dynamic arguments]) async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod(method, arguments);
      } catch (e) {
        // Check if this is a MissingPluginException
        if (e.toString().contains('MissingPluginException')) {
          print(
              'Method $method not implemented in native platform. This is expected in some environments.');
        } else {
          print('Error calling platform method $method: $e');
        }
      }
    }
  }
}
