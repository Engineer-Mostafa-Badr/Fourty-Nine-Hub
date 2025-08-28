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
    required this.index,
    required this.receiverId,
    required this.url,
  });

  final bool isLoading;
  final int index;
  final int receiverId;
  final String url;

  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _showPlayPauseIcon = false;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _pendingPlay = false;

  late final AnimationController _rotationController;
  late final BetterPlayerController _bp;

  BetterPlayerController get _controller => _bp;

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

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.url,
      cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
      videoFormat: widget.url.toLowerCase().endsWith('.m3u8')
          ? BetterPlayerVideoFormat.hls
          : BetterPlayerVideoFormat.other,
    );

    _bp = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        looping: true,
        fit: BoxFit.cover, // full-screen cover
        handleLifecycle: false,
        showPlaceholderUntilPlay: false,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          showControls: false,
          enableProgressBar: true,
          enableProgressBarDrag: false,
          enablePlayPause: false,
          enableMute: false,
          enableSkips: false,
          enableFullscreen: false,
          enableProgressText: false,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );

    _bp.addEventsListener(_onBetterPlayerEvent);

    // Attach to bloc (so pauseCurrent etc. keep working)
    context.read<PreloadBloc>().attachController(widget.index, _bp);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      _bp.setLooping(true);

      final focus = context.read<PreloadBloc>().state.focusedIndex;
      if (focus == widget.index) {
        // focus → play now or queue
        if (_isInitialized) {
          await _playVideo();
        } else {
          _pendingPlay = true;
        }
        await _safeSetVolume(1.0);
      } else {
        await _safeSetVolume(0.0);
      }
    });
  }

  void _onBetterPlayerEvent(BetterPlayerEvent e) {
    switch (e.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        _isInitialized = true;
        _bp.setLooping(true);

        final focus = context.read<PreloadBloc>().state.focusedIndex;
        if (_pendingPlay || focus == widget.index) {
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
    _bp.removeEventsListener(_onBetterPlayerEvent);

    // Detach (don’t dispose in bloc)
    context.read<PreloadBloc>().detachController(widget.index, _bp);

    // Widget owns the controller → dispose here
    _bp.dispose();
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
          if (_isInitialized) {
            await _playVideo();
          } else {
            _pendingPlay = true;
          }
          await _safeSetVolume(1.0);
        } else {
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

              // Video (full screen cover)
              Positioned.fill(
                child: BetterPlayer(
                  key: ValueKey('bp_${widget.index}_${_bp.hashCode}'),
                  controller: _controller,
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

              // Bottom bar (title only)
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
