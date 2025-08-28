import 'dart:developer';
import 'dart:convert';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/animated_heart_wiidget.dart';
import 'package:http/http.dart' as http;

import '../../controllers/explore_reels_cubit/reel_cubit.dart';
import '../../controllers/preload_cubit/preload_bloc.dart';
import '../../controllers/preload_cubit/preload_state.dart';
import '../full_screen_widget.dart';
import '../../pages/reel_actions.dart';
import 'unified_widget_view.dart';

class ReelsWidget extends StatefulWidget {
  const ReelsWidget({
    super.key,
    required this.isLoading,
    required this.index,
    required this.url,
  });

  final bool isLoading;
  final int index;
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
  BetterPlayerController? _bp;

  BetterPlayerController get _controller => _bp!;

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

    _initController(); // async bootstrap
  }

  Future<void> _initController() async {
    // 1) Resolve the lowest-variant URL if this is a master HLS.
    final effectiveUrl = await _pickLowestVariantIfHls(widget.url);

    // 2) Build data source. IMPORTANT: disable ASMS track switching so it won’t upscale.
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      effectiveUrl,
      // Keep tracks off so it sticks to the URL we gave it:
      useAsmsTracks: false,
      useAsmsAudioTracks: true,
      // Optional caching/buffering as you had:
      cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 1000,
        maxBufferMs: 10000,
        bufferForPlaybackMs: 500,
        bufferForPlaybackAfterRebufferMs: 1000,
      ),
      videoFormat: effectiveUrl.toLowerCase().endsWith('.m3u8')
          ? BetterPlayerVideoFormat.hls
          : BetterPlayerVideoFormat.other,
    );

    _bp = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        looping: true,
        expandToFill: false,
        fit: BoxFit.fill, // cover = full screen with crop (like Reels)
        handleLifecycle: false,
        showPlaceholderUntilPlay: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
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

    _controller.addEventsListener(_onBetterPlayerEvent);

    // Keep your pauseCurrent etc. hooks working:
    context.read<PreloadBloc>().attachController(widget.index, _controller);

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _controller.setLooping(true);

      // Focus logic as you had:
      final focus = context.read<PreloadBloc>().state.focusedIndex;
      if (focus == widget.index) {
        if (_isInitialized) {
          await _playVideo();
        } else {
          _pendingPlay = true;
        }
        await _safeSetVolume(1.0);
      } else {
        await _safeSetVolume(0.0);
      }
      setState(() {}); // to paint player after init
    });
  }

  void _onBetterPlayerEvent(BetterPlayerEvent e) {
    switch (e.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        _isInitialized = true;
        _controller.setLooping(true);
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

    final bp = _bp;
    if (bp != null) {
      bp.removeEventsListener(_onBetterPlayerEvent);
      context.read<PreloadBloc>().detachController(widget.index, bp);
      bp.dispose();
    }
    super.dispose();
  }

  Future<void> _safeSetVolume(double v) async {
    try {
      await _controller.setVolume(v);
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
      await _controller.play();
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
      await _controller.pause();
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
  @override
  Widget build(BuildContext context) {
    final reels = context.read<ReelsCubit>().state.globalReels;
    final reel = (widget.index >= 0 && widget.index < reels.length)
        ? reels[widget.index]
        : null;

    return BlocListener<PreloadBloc, PreloadState>(
      listenWhen: (prev, curr) => prev.focusedIndex != curr.focusedIndex,
      listener: (context, curr) async {
        if (_bp == null) return;
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

              // Player
              if (_bp != null)
                Positioned.fill(
                  child: BetterPlayer(
                    key: ValueKey('bp_${widget.index}_${_bp.hashCode}'),
                    controller: _controller,
                  ),
                ),

              // Play/Pause toast
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

              // Bottom caption
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

              // Fullscreen button
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

  // --------- LOWEST-RES HLS PICKER ----------

  Future<String> _pickLowestVariantIfHls(String url) async {
    final lower = url.toLowerCase();
    if (!lower.endsWith('.m3u8')) return url;

    // Bunny quick path: master ".../video.m3u8" -> ".../240p/video.m3u8"
    // Comment this out if your paths differ.
    if (lower.endsWith('/video.m3u8')) {
      return url.replaceFirst(
          RegExp(r'/video\.m3u8$', caseSensitive: false), '/240p/video.m3u8');
    }

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return url;

      final lines = const LineSplitter().convert(res.body);
      if (!lines.any((l) => l.startsWith('#EXT-X-STREAM-INF'))) {
        // Not a master manifest, just return as-is
        return url;
      }

      final variants = <Map<String, dynamic>>[];
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.startsWith('#EXT-X-STREAM-INF:')) {
          final bw = _parseBandwidth(line);
          final next = (i + 1 < lines.length) ? lines[i + 1].trim() : '';
          if (bw != null && next.isNotEmpty && !next.startsWith('#')) {
            final resolved = Uri.parse(url).resolve(next).toString();
            variants.add({'bw': bw, 'uri': resolved});
          }
        }
      }

      if (variants.isEmpty) return url;
      variants.sort((a, b) => (a['bw'] as int).compareTo(b['bw'] as int));
      return variants.first['uri'] as String; // lowest BANDWIDTH
    } catch (_) {
      return url;
    }
  }

  int? _parseBandwidth(String line) {
    final reg = RegExp(r'BANDWIDTH=(\d+)');
    final m = reg.firstMatch(line);
    return m != null ? int.tryParse(m.group(1)!) : null;
  }
}
