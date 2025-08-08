import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/controller/call_controller/call_cubit.dart';
import '../presentation/controller/call_controller/call_state.dart';
import '../presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import '../presentation/controller/send_call_controller.dart/send_call_states.dart';
import '../services/call_timer_service.dart';
import 'screen_lock_manager.dart';
import '../../../main.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../../../helpers/manage_vibration.dart';

// Class to manage global call overlay display
class CallOverlayManager {
  static final CallOverlayManager _instance = CallOverlayManager._internal();
  factory CallOverlayManager() => _instance;
  CallOverlayManager._internal();

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  // Size of the minimized call bubble
  static const double callBubbleSize = 80.0;
  static const double callBubbleVideoSize = 160.0;

  // Check if call overlay is currently visible
  static bool get isVisible => _isVisible;

  // Show the call overlay
  static void showOverlay() {
    if (_isVisible) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => const MinimizedCallOverlay(),
    );

    // Ensure we have a valid context before inserting overlay
    final context = navigatorKey.currentContext;
    if (context != null) {
      Overlay.of(context).insert(_overlayEntry!);
      _isVisible = true;
      print("Call overlay successfully shown");
    } else {
      print("Failed to show call overlay: No valid context");
    }
  }

  // Hide the call overlay
  static void hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
      print("Call overlay hidden");
    }
  }
}

// The actual call overlay widget
class MinimizedCallOverlay extends StatefulWidget {
  const MinimizedCallOverlay({super.key});

  @override
  State<MinimizedCallOverlay> createState() => _MinimizedCallOverlayState();
}

class _MinimizedCallOverlayState extends State<MinimizedCallOverlay>
    with WidgetsBindingObserver {
  static const platform =
      MethodChannel('com.fourtyninehub.app/background_service');

  // Initial position for the draggable bubble
  Offset position = const Offset(20, 100);
  final CallTimerService _timerService = CallTimerService();

  bool isKeepScreenOn = true;
  Timer? _backgroundTimer;

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
    print("MinimizedCallOverlay initializing");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final sendCallState = context.read<SendCallCubit>().state;
        final callState = context.read<CallCubit>().state;

        if ((sendCallState is CallConnected ||
            (callState is HasCall && callState.isCallConnected))) {
          if (!_timerService.isRunning) {
            print("Starting timer in MinimizedCallOverlay - call is connected");
            _timerService.startTimer();
          }
        }
      }
    });

    // enableFloatingWhileMinimizedViaSystem();
    // Set up early background configuration right at initialization
    // ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(
    //   advancedConfig: {
    //     "audio.capture.force_using_media_recorder": "true",
    //     "audio.captureAndRender.androidLowLatencyEnabled": "true",
    //     "background.mode.enabled": "true",
    //     "audio.process.continue.in.background": "true",
    //     "android.audio.focus.request": "true",
    //     "audio.audioRecord.keep.audiosession.active": "true",
    //   },
    // ));
    // _enableKeepScreenOn();
    // _setupBackgroundKeepAlive(); // Add this line

    // enableFloatingWhileMinimizedViaSystem();
  }

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

  enableFloatingWhileMinimizedViaSystem() async {
    print('Enabling floating while minimized via system...');
    await floating.enable(const OnLeavePiP()
        // const ImmediatePiP(),
        );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // enableFloatingWhileMinimizedViaSystem();
  //     // App is in background or screen is locked
  //     _handleAppInBackground();
  //   } else if (state == AppLifecycleState.resumed) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _handleResumed();
  //     });
  //     if (isKeepScreenOn) {
  //       _enableKeepScreenOn();
  //     }
  //   } else if (state == AppLifecycleState.detached) {
  //     // enableFloatingWhileMinimizedViaSystem();
  //     // App is in background or screen is locked
  //     _handleAppInBackground();
  //   } else if (state == AppLifecycleState.hidden) {
  //     _handleAppInBackground();
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  String getUserId() {
    Random rand = Random();
    return rand.nextInt(100000000).toString();
  }

  void _handleAppInBackground() {
    // Safety check
    if (!mounted) return;

    final callState = context.read<CallCubit>().state;
    if (callState is HasCall) {
      if (callState.isZegoCloud) {
        enableFloatingWhileMinimizedViaSystem();
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
              final userId = currentState.callData.receiverName ?? getUserId();
              final streamID =
                  '${currentState.callData.zegoRoomId}_${userId}_call';
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
      final currentState = context.read<CallCubit>().state;
      if (currentState is HasCall) {
        // Force enable audio
        final callInfo = {
          'roomId': currentState.callData.zegoRoomId,
          'userId': getUserId(),
          'isVideoCall': currentState.callData.callType == 'video',
        };

        _safelyCallPlatformMethod('startBackgroundService', callInfo);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendCallCubit, SendCallState>(
      builder: (context, minimizeState) {
        final callCubit = context.read<SendCallCubit>();

        // Check if call is minimized
        if (!callCubit.isCallMinimized) {
          // Don't reset timer here - we want to preserve it
          print("Call is no longer minimized, hiding overlay");

          // Use a post-frame callback to avoid build phase errors
          WidgetsBinding.instance.addPostFrameCallback((_) {
            CallOverlayManager.hideOverlay();
          });

          return const SizedBox.shrink();
        }

        return BlocBuilder<SendCallCubit, SendCallState>(
            builder: (context, sendCallState) {
          // Don't reset timer here - we want to continue the existing timer
          if (!_timerService.isRunning && sendCallState is CallConnected) {
            print("Call is connected but timer not running, restarting timer");
            _timerService.startTimer();
          }

          return BlocBuilder<CallCubit, CallState>(
              builder: (context, callState) {
            final screenSize = MediaQuery.of(context).size;
            final safeAreaTop = MediaQuery.of(context).viewPadding.top;
            final safeAreaBottom = MediaQuery.of(context).viewPadding.bottom;

            // Determine if we should show video based on current call state
            final bool hasVideo = callState is HasCall &&
                (callState.isVideoEnabled || callState.isRemoteVideoEnabled);

            // Use different size bubble based on whether we're showing video
            final bubbleSize = hasVideo
                ? CallOverlayManager.callBubbleVideoSize
                : CallOverlayManager.callBubbleSize;

            return Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Update the position but keep within screen bounds
                    final newX = position.dx + details.delta.dx;
                    final newY = position.dy + details.delta.dy;

                    // Apply bounds checking to keep bubble on screen
                    position = Offset(
                      newX.clamp(0, screenSize.width - bubbleSize),
                      newY.clamp(safeAreaTop,
                          screenSize.height - bubbleSize - safeAreaBottom),
                    );
                  });
                },
                onPanEnd: (details) {
                  // Snap to edge after dragging
                  setState(() {
                    if (position.dx < screenSize.width / 2) {
                      // Snap to left edge
                      position = Offset(0, position.dy);
                    } else {
                      // Snap to right edge
                      position =
                          Offset(screenSize.width - bubbleSize, position.dy);
                    }
                  });
                },
                onDoubleTap: () {
                  // End call on double tap
                  // if (sendCallState is CallConnected) {
                  //   context.read<CallCubit>().endCall();
                  // }
                },
                onTap: () {
      ManageVibration.vibrate();
                  // Don't stop the timer when returning to call screen
                  print(
                      "Tapped on minimized overlay. Current timer: ${_timerService.formatDuration(_timerService.duration.value)}");

                  // First maximize the call in state
                  callCubit.maximizeCall();

                  // Hide the overlay before navigation to avoid UI conflicts
                  // CallOverlayManager.hideOverlay();

                  // Then navigate to call screen
                  // Navigator.of(navigatorKey.currentContext!).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const WhatsAppCallScreen(),
                  //     fullscreenDialog: true, // Make it a modal dialog to avoid back stack issues
                  //   ),
                  // );
                },
                child: hasVideo
                    ? _buildVideoCallBubble(
                        context, minimizeState, callState)
                    : _buildCallBubble(context, minimizeState),
              ),
            );
          });
        });
      },
    );
  }

  Widget _buildCallBubble(BuildContext context, SendCallState state) {
    return const SizedBox.shrink();
    //     Material(
    //   elevation: 8,
    //   borderRadius:
    //       BorderRadius.circular(CallOverlayManager.callBubbleSize / 2),
    //   color: Colors.transparent,
    //   child: Container(
    //     height: CallOverlayManager.callBubbleSize,
    //     width: CallOverlayManager.callBubbleSize,
    //     decoration: BoxDecoration(
    //       color: Colors.green.shade600,
    //       borderRadius:
    //           BorderRadius.circular(CallOverlayManager.callBubbleSize / 2),
    //       border: Border.all(color: Colors.white, width: 2),
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Icon(
    //           Icons.phone,
    //           color: Colors.white,
    //           size: 28,
    //         ),
    //         const SizedBox(height: 4),
    //         ValueListenableBuilder<Duration>(
    //           valueListenable: _timerService.duration,
    //           builder: (context, duration, _) {
    //             final formattedTime = _timerService.formatDuration(duration);
    //             return Text(
    //               formattedTime,
    //               style: const TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 12,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildVideoCallBubble(
      BuildContext context, SendCallState sendCallState, HasCall callState) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: Container(
        height: CallOverlayManager.callBubbleVideoSize,
        width: CallOverlayManager.callBubbleVideoSize,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Stack(
          children: [
            // Show remote video when available, or a placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox.expand(
                child: callState.isRemoteVideoEnabled &&
                        callState.remoteView is! SizedBox
                    ? callState.remoteView
                    : Container(
                        color: const Color(0xFF121212),
                        child: const Center(
                          child: Icon(
                            Icons.videocam_off,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),

            // Show local video in corner when available
            if (callState.isVideoEnabled && callState.localView is! SizedBox)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: callState.localView,
                  ),
                ),
              ),

            // Call timer at bottom - always show timer in video mode
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: ValueListenableBuilder<Duration>(
                    valueListenable: _timerService.duration,
                    builder: (context, duration, _) {
                      return Text(
                        _timerService.formatDuration(duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("Disposing minimized overlay, but NOT stopping the timer");
    // Don't reset or stop the timer on dispose - important for state persistence
    super.dispose();
  }
}

// App wrapper for handling calls - no longer needs special padding since we use the bubble UI
class CallAwareApp extends StatelessWidget {
  final Widget child;

  const CallAwareApp({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main app without padding since we use a bubble UI now
        child,
      ],
    );
  }
}