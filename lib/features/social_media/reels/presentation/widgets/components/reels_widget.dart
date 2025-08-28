import 'dart:developer';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/explore_reels_cubit/reel_cubit.dart';
import '../../controllers/preload_cubit/preload_bloc.dart';
import '../../controllers/preload_cubit/preload_state.dart';
import '../full_screen_widget.dart';
import '../../pages/reel_actions.dart';
import 'animated_heart_wiidget.dart';
import 'unified_widget_view.dart';

class ReelsWidget extends StatefulWidget {
  const ReelsWidget({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.index,
    required this.receiverId,
  });

  final bool isLoading;
  final BetterPlayerController controller;
  final int index;
  final int receiverId;

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _showPlayPauseIcon = false;

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _pendingPlay = false; // queue play until initialized

  late final AnimationController _rotationController;
  BetterPlayerController get _bp => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    _bp.addEventsListener(_onBetterPlayerEvent);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bp.setLooping(true);

      // If I'm already focused on first build, queue/play
      final focused = context.read<PreloadBloc>().state.focusedIndex;
      if (focused == widget.index) {
        if (_isInitialized) {
          _playVideo();
        } else {
          _pendingPlay = true;
        }
        _safeSetVolume(1.0);
      } else {
        _safeSetVolume(0.0);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ReelsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeEventsListener(_onBetterPlayerEvent);
      try {
        oldWidget.controller.pause();
      } catch (_) {}

      _isInitialized = false;
      _isPlaying = false;
      _pendingPlay = false;

      _bp.addEventsListener(_onBetterPlayerEvent);
      _bp.setLooping(true);
    }
  }

  void _onBetterPlayerEvent(BetterPlayerEvent e) {
    switch (e.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        _isInitialized = true;
        _bp.setLooping(true);
        final focused = context.read<PreloadBloc>().state.focusedIndex;
        if (_pendingPlay || focused == widget.index) {
          _pendingPlay = false;
          _playVideo();
          _safeSetVolume(1.0);
        }
        break;
      case BetterPlayerEventType.play:
        _isPlaying = true;
        break;
      case BetterPlayerEventType.pause:
      case BetterPlayerEventType.finished:
        _isPlaying = false;
        break;
      default:
        break;
    }
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pauseVideo();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _rotationController.dispose();
    _bp.removeEventsListener(_onBetterPlayerEvent); // bloc owns controller
    super.dispose();
  }

  Future<void> _safeSetVolume(double v) async {
    try {
      await _bp.setVolume(v);
    } catch (_) {}
  }

  Future<void> _togglePlayPause() async {
    if (!_isInitialized) return;
    if (_isPlaying) {
      await _pauseVideo();
    } else {
      await _playVideo();
    }
  }

  Future<void> _playVideo() async {
    try {
      await _bp.play();
      if (!mounted) return;
      setState(() => _showPlayPauseIcon = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showPlayPauseIcon = false);
      });
    } catch (e) {
      log('⚠️ play() error: $e');
    }
  }

  Future<void> _pauseVideo() async {
    try {
      await _bp.pause();
      if (!mounted) return;
      setState(() => _showPlayPauseIcon = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showPlayPauseIcon = false);
      });
    } catch (e) {
      log('⚠️ pause() error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final reels = context.read<ReelsCubit>().state.globalReels;
    final reel = (widget.index >= 0 && widget.index < reels.length)
        ? reels[widget.index]
        : null;

    return BlocListener<PreloadBloc, PreloadState>(
      listenWhen: (prev, curr) => prev.focusedIndex != curr.focusedIndex,
      listener: (context, curr) async {
        if (curr.focusedIndex == widget.index) {
          // I’m focused → play or queue until initialized
          if (_isInitialized) {
            await _playVideo();
          } else {
            _pendingPlay = true;
          }
          await _safeSetVolume(1.0);
        } else {
          // Not focused → cancel any pending play, pause & mute
          _pendingPlay = false;
          await _pauseVideo();
          await _safeSetVolume(0.0);
        }
      },
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: DoubleTapHeart(
          iconSize: 40,
          animationDuration: const Duration(seconds: 1),
          heartIcon: Icons.favorite_outline,
          iconColor: Colors.pink,
          onDoubleTap: reel == null
              ? null
              : () async {
                  final reelCubit = context.read<ReelsCubit>();
                  await reelCubit.likeReel(reel.id);
                },
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.black)),

              // Video
              Positioned.fill(
                child: BetterPlayer(
                  key: ValueKey('bp_${widget.index}'),
                  controller: _bp,
                ),
              ),

              // Play/Pause toast icon
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: _showPlayPauseIcon ? 1 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Center(
                      child: Icon(
                        (_isInitialized && _isPlaying)
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white.withOpacity(0.6),
                        size: 84,
                      ),
                    ),
                  ),
                ),
              ),

              // Right-side actions
              if (reel != null)
                Positioned(
                  right: 0,
                  bottom: 20,
                  child: ReelActions(
                    reel: reel,
                    itemType: ReelItemType.main,
                    rotationController: _rotationController,
                  ),
                ),

              // Bottom bar (title only; Better Player shows progress)
              if (reel != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 56,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.black.withOpacity(0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            reel.audio.audioName.isNotEmpty
                                ? reel.audio.audioName
                                : "No audio",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.white70, size: 20),
                      ],
                    ),
                  ),
                ),

              // Fullscreen button (your widget)
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.5,
                left: MediaQuery.of(context).size.width * 0.115,
                child: const FullScreenWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
