import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/explore_reels_cubit/reel_cubit.dart';
import '../full_screen_widget.dart';
import 'animated_heart_wiidget.dart';
import 'custom_progress_bar.dart';
import '../../pages/reel_actions.dart';
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
  final VideoPlayerController controller;
  final int index;
  final int receiverId;

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _showPlayPauseIcon = false;
  bool _hasAutoPlayed = false; // guard to avoid double-autoplay
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Always loop; bloc already primes with seekTo(0)
    widget.controller.setLooping(true);

    // Start playback only after mount + initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.controller.value.isInitialized) {
        _autoPlayOnce();
      } else {
        void onInitListener() {
          if (widget.controller.value.isInitialized) {
            widget.controller.removeListener(onInitListener);
            if (mounted) _autoPlayOnce();
          }
        }

        widget.controller.addListener(onInitListener);
      }
    });

    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
  }

  @override
  void didUpdateWidget(covariant ReelsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _hasAutoPlayed = false; // reset guard for new controller
      try {
        oldWidget.controller.pause();
      } catch (_) {}
      widget.controller.setLooping(true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.controller.value.isInitialized) {
          _autoPlayOnce();
        } else {
          void onInitListener() {
            if (widget.controller.value.isInitialized) {
              widget.controller.removeListener(onInitListener);
              if (mounted) _autoPlayOnce();
            }
          }

          widget.controller.addListener(onInitListener);
        }
      });
    }
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
    try {
      if (widget.controller.value.isInitialized &&
          widget.controller.value.isPlaying) {
        widget.controller.pause();
      }
    } catch (_) {}
    WidgetsBinding.instance.removeObserver(this);
    _rotationController.dispose();
    super.dispose();
  }

  // ---------- playback helpers ----------

  void _autoPlayOnce() {
    if (_hasAutoPlayed) return;
    _hasAutoPlayed = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.controller.value.isInitialized) {
        _playVideo();
      } else {
        void onInitListener() {
          if (widget.controller.value.isInitialized) {
            widget.controller.removeListener(onInitListener);
            if (mounted) _playVideo();
          }
        }

        widget.controller.addListener(onInitListener);
      }
    });
  }

  void _togglePlayPause() {
    if (!widget.controller.value.isInitialized) return;
    if (widget.controller.value.isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
  }

  void _playVideo() {
    if (!mounted || !widget.controller.value.isInitialized) return;
    try {
      widget.controller.play();
      setState(() => _showPlayPauseIcon = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showPlayPauseIcon = false);
      });
    } catch (e) {
      log('⚠️ play() error: $e');
    }
  }

  void _pauseVideo() {
    if (!mounted || !widget.controller.value.isInitialized) return;
    try {
      widget.controller.pause();
      setState(() => _showPlayPauseIcon = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showPlayPauseIcon = false);
      });
    } catch (e) {
      log('⚠️ pause() error: $e');
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final reel = context.read<ReelsCubit>().state.globalReels[widget.index];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: DoubleTapHeart(
          iconSize: 40,
          animationDuration: const Duration(seconds: 1),
          heartIcon: Icons.favorite_outline,
          iconColor: Colors.pink,
          onDoubleTap: () async {
            final reelCubit = context.read<ReelsCubit>();
            await reelCubit.likeReel(reel.id);
          },
          child: Stack(
            children: [
              // Rebuild as controller value changes (init → ready)
              ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: widget.controller,
                builder: (context, value, _) {
                  if (value.isInitialized && !_hasAutoPlayed) {
                    _autoPlayOnce();
                  }

                  if (!value.isInitialized) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white54),
                    );
                  }

                  return VideoPlayer(
                    widget.controller,
                    key: ValueKey('reel_video_${widget.index}'),
                  );
                },
              ),

              // Play/Pause toast icon
              AnimatedOpacity(
                opacity: _showPlayPauseIcon ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                child: Center(
                  child: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white.withOpacity(0.6),
                    size: 84,
                  ),
                ),
              ),

              // Right-side actions (likes, comments, etc.)
              Positioned(
                right: 0,
                bottom: 20,
                child: ReelActions(
                  reel: reel,
                  itemType: ReelItemType.main,
                  rotationController: _rotationController,
                ),
              ),

              // Bottom bar: audio + progress
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
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
                      const SizedBox(height: 5),
                      CustomProgressBar(
                        videoPlayerController: widget.controller,
                      ),
                    ],
                  ),
                ),
              ),

              // Extra UI
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
