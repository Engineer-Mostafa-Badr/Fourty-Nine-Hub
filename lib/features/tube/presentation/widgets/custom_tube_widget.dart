import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';
import 'package:video_player/video_player.dart';

class CustomVideoControls extends StatefulWidget {
  final TubeCubit cubit;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onDoubleTapLeft;
  final VoidCallback onDoubleTapRight;
  final bool Function() hasPrevious;
  final bool Function() hasNext;
  final String videoUrl;

  const CustomVideoControls({
    super.key,
    required this.cubit,
    required this.onPrevious,
    required this.onNext,
    required this.onDoubleTapLeft,
    required this.onDoubleTapRight,
    required this.hasPrevious,
    required this.hasNext,
    required this.videoUrl,
  });

  @override
  State<CustomVideoControls> createState() => _CustomVideoControlsState();
}
class _CustomVideoControlsState extends State<CustomVideoControls>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _previewController;
  bool _isPreviewReady = false;
  bool _isDragging = false;
  double _dragValue = 0.0;
  Offset? _dragPosition;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Timer? _hideTimer;
  bool _showControls = true;
  double _currentPlaybackSpeed = 1.0;
  Duration _currentPosition = Duration.zero;
  int _currentQuality = 720;
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    _initializePreviewController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializePreviewController() async {
    if (widget.videoUrl.isEmpty || _currentVideoUrl == widget.videoUrl) return;

    await _disposePreviewController();
    _currentVideoUrl = widget.videoUrl;
    _isPreviewReady = false;

    try {
      _previewController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );
      await _previewController?.initialize();
      await _previewController?.setVolume(0);
      if (mounted) {
        setState(() {
          _isPreviewReady = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing preview controller: $e');
      if (mounted) {
        setState(() => _isPreviewReady = false);
      }
    }
  }

  Future<void> _disposePreviewController() async {
    if (_previewController != null) {
      try {
        await _previewController!.pause();
        await _previewController!.dispose();
      } catch (e) {
        debugPrint('Error disposing preview controller: $e');
      }
      _previewController = null;
    }
  }

  void _startHideTimer(VideoPlayerController? playerController) {
    _hideTimer?.cancel();
    if (playerController != null && playerController.value.isPlaying && !_isDragging) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDragging) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  void _addPositionListener(VideoPlayerController playerController) {
    playerController.addListener(() {
      if (mounted && !_isDragging) {
        setState(() {
          _currentPosition = playerController.value.position;
        });
      }
    });
  }

  @override
  void didUpdateWidget(CustomVideoControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializePreviewController();
    }
  }

  @override
  void dispose() {
    _disposePreviewController();
    _animationController?.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      bloc: widget.cubit,
      builder: (context, state) {
        final chewieController = state.chewieController;
        final playerController = state.videoPlayerController;

        if (chewieController == null || playerController == null || !playerController.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        // Add listener to update position
        _addPositionListener(playerController);

        final position = _isDragging ? Duration(milliseconds: _dragValue.toInt()) : _currentPosition;
        final duration = playerController.value.duration;
        final currentValue = _isDragging ? _dragValue : _currentPosition.inMilliseconds.toDouble();

        if (playerController.value.isPlaying && _showControls && !_isDragging) {
          _startHideTimer(playerController);
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
            if (_showControls && playerController.value.isPlaying && !_isDragging) {
              _startHideTimer(playerController);
            }
          },
          onDoubleTapDown: _showControls
              ? (details) {
            final tapPosition = details.localPosition.dx;
            final screenWidth = MediaQuery.of(context).size.width;
            if (tapPosition < screenWidth / 2) {
              _animationController?.forward().then((_) => _animationController?.reverse());
              widget.onDoubleTapLeft();
            } else {
              _animationController?.forward().then((_) => _animationController?.reverse());
              widget.onDoubleTapRight();
            }
          }
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(playerController),
              if (state.showForwardIndicator)
                PositionedDirectional(
                  start: 20,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: _indicatorWidget(Icons.fast_forward, context.isArabic ? 'تقديم 20 ثانية' : 'Fast Forward 20s'),
                  ),
                ),
              if (state.showBackwardIndicator)
                PositionedDirectional(
                  end: 20,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: _indicatorWidget(Icons.fast_rewind, context.isArabic ? 'رجوع 20 ثانية' : 'Rewind 20s'),
                  ),
                ),
              if (_showControls)
                _buildControls(context, playerController, chewieController, duration, currentValue, position),
            ],
          ),
        );
      },
    );
  }

  Widget _indicatorWidget(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildControls(
      BuildContext context,
      VideoPlayerController playerController,
      ChewieController chewieController,
      Duration duration,
      double currentValue,
      Duration position,
      ) {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topControls(context, playerController),
              _centerControls(context, playerController, chewieController),
              _bottomControls(context, playerController, chewieController, duration, currentValue, position),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topControls(BuildContext context, VideoPlayerController playerController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<double>(
            icon: Row(
              children: [
                const Icon(Icons.speed, color: Colors.white),
                const SizedBox(width: 4),
                Text('${_currentPlaybackSpeed}x', style: const TextStyle(color: Colors.white)),
              ],
            ),
            onSelected: (value) {
              setState(() => _currentPlaybackSpeed = value);
              playerController.setPlaybackSpeed(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 0.5, child: Text('0.5x')),
              PopupMenuItem(value: 1.0, child: Text('1.0x')),
              PopupMenuItem(value: 1.5, child: Text('1.5x')),
              PopupMenuItem(value: 2.0, child: Text('2.0x')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _centerControls(
      BuildContext context,
      VideoPlayerController playerController,
      ChewieController chewieController,
      ) {
    final hasPrevious = widget.hasPrevious();
    final hasNext = widget.hasNext();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 40,
              icon: Icon(context.isArabic ? Icons.skip_next : Icons.skip_previous,
                  color: hasPrevious ? Colors.white : Colors.grey.withOpacity(0.5)),
              onPressed: hasPrevious ? widget.onPrevious : null,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 64,
              icon: Icon(
                playerController.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
              ),
              onPressed: () {
                chewieController.togglePause();
                setState(() {
                  _showControls = true;
                  if (!playerController.value.isPlaying) _hideTimer?.cancel();
                });
                if (playerController.value.isPlaying && !_isDragging)
                  _startHideTimer(playerController);
              },
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 40,
              icon: Icon(context.isArabic ? Icons.skip_previous : Icons.skip_next,
                  color: hasNext ? Colors.white : Colors.grey.withOpacity(0.5)),
              onPressed: hasNext ? widget.onNext : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomControls(
      BuildContext context,
      VideoPlayerController playerController,
      ChewieController chewieController,
      Duration duration,
      double currentValue,
      Duration position,
      ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.red,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayColor: Colors.red.withOpacity(0.2),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: currentValue,
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                  onChangeStart: (value) async {
                    setState(() {
                      _isDragging = true;
                      _dragValue = value;
                      _showControls = true;
                      _hideTimer?.cancel();
                    });
                    if (playerController.value.isPlaying) {
                      await playerController.pause();
                    }
                    if (_previewController != null && _isPreviewReady) {
                      await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
                      await _previewController!.setLooping(true);
                    }
                  },
                  onChanged: (value) async {
                    setState(() {
                      _dragValue = value;
                      _currentPosition = Duration(milliseconds: value.toInt());
                      final box = context.findRenderObject() as RenderBox?;
                      if (box != null) {
                        final width = box.size.width;
                        final percentage = value / duration.inMilliseconds.toDouble();
                        _dragPosition = Offset(width * percentage, 0);
                      }
                    });
                    if (_previewController != null && _isPreviewReady) {
                      await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
                    }
                  },
                  onChangeEnd: (value) async {
                    await playerController.seekTo(Duration(milliseconds: value.toInt()));
                    if (chewieController.isPlaying) {
                      await playerController.play();
                    }
                    setState(() {
                      _isDragging = false;
                      _dragPosition = null;
                      _currentPosition = Duration(milliseconds: value.toInt());
                    });
                    if (_previewController != null && _isPreviewReady) {
                      await _previewController!.setLooping(false);
                      await _previewController!.pause();
                    }
                    if (playerController.value.isPlaying && !_isDragging) {
                      _startHideTimer(playerController);
                    }
                  },
                ),
              ),
              if (_isDragging && _dragPosition != null && _isPreviewReady)
                Positioned(
                  left: (_dragPosition!.dx - 60).clamp(0.0, MediaQuery.of(context).size.width - 120),
                  top: -100,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 140,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _previewController != null
                                ? VideoPlayer(_previewController!)
                                : const SizedBox.shrink(),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _formatDuration(Duration(milliseconds: _dragValue.toInt())),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  playerController.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  playerController.setVolume(playerController.value.volume > 0 ? 0.0 : 1.0);
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(
                  chewieController.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: chewieController.toggleFullScreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*
class _CustomVideoControlsState extends State<CustomVideoControls>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _previewController;
  bool _isPreviewReady = false;
  bool _isDragging = false;
  double _dragValue = 0.0;
  Offset? _dragPosition;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Timer? _hideTimer;
  bool _showControls = true;
  double _currentPlaybackSpeed = 1.0;
  Timer? _positionUpdateTimer;
  Duration _currentPosition = Duration.zero;
  int _currentQuality = 720;
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    _initializePreviewController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializePreviewController() async {
    if (widget.videoUrl.isEmpty || _currentVideoUrl == widget.videoUrl) return;

    // Dispose of the existing controller
    await _disposePreviewController();

    _currentVideoUrl = widget.videoUrl;
    _isPreviewReady = false;

    try {
      _previewController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );
      await _previewController?.initialize();
      await _previewController?.setVolume(0);
      if (mounted) {
        setState(() {
          _isPreviewReady = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing preview controller: $e');
      if (mounted) {
        setState(() => _isPreviewReady = false);
      }
    }
  }

  Future<void> _disposePreviewController() async {
    if (_previewController != null) {
      try {
        await _previewController!.pause();
        await _previewController!.dispose();
      } catch (e) {
        debugPrint('Error disposing preview controller: $e');
      }
      _previewController = null;
    }
  }

  void _startPositionUpdates(VideoPlayerController? playerController) {
    _positionUpdateTimer?.cancel();
    if (playerController == null || !playerController.value.isInitialized) return;
    _positionUpdateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && !_isDragging && playerController.value.isInitialized) {
        setState(() => _currentPosition = playerController.value.position);
      }
    });
  }

  void _startHideTimer(VideoPlayerController? playerController) {
    _hideTimer?.cancel();
    if (playerController != null && playerController.value.isPlaying && !_isDragging) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDragging) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  @override
  void didUpdateWidget(CustomVideoControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializePreviewController();
    }
  }

  @override
  void dispose() {
    _disposePreviewController();
    _animationController?.dispose();
    _hideTimer?.cancel();
    _positionUpdateTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${minutes}:${twoDigits(seconds)}';
  }

  String getBaseUrl(String url) {
    return url.contains('/playlist.m3u8') ? url.replaceAll('/playlist.m3u8', '') : url;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TubeCubit, TubeState>(
      bloc: widget.cubit,
      builder: (context, state) {
        final chewieController = state.chewieController;
        final playerController = state.videoPlayerController;

        if (chewieController == null || playerController == null || !playerController.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        _startPositionUpdates(playerController);
        final position = _isDragging ? Duration(milliseconds: _dragValue.toInt()) : _currentPosition;
        final duration = playerController.value.duration;
        final currentValue = _isDragging ? _dragValue : _currentPosition.inMilliseconds.toDouble();

        if (playerController.value.isPlaying && _showControls && !_isDragging) {
          _startHideTimer(playerController);
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
            if (_showControls && playerController.value.isPlaying && !_isDragging) {
              _startHideTimer(playerController);
            }
          },
          onDoubleTapDown: _showControls
              ? (details) {
            final tapPosition = details.localPosition.dx;
            final screenWidth = MediaQuery.of(context).size.width;
            if (tapPosition < screenWidth / 2) {
              _animationController?.forward().then((_) => _animationController?.reverse());
              widget.onDoubleTapLeft();
            } else {
              _animationController?.forward().then((_) => _animationController?.reverse());
              widget.onDoubleTapRight();
            }
          }
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(playerController),
              if (state.showForwardIndicator)
                PositionedDirectional(
                  start: 20,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: _indicatorWidget(Icons.fast_forward, context.isArabic ? 'تقديم 20 ثانية' : 'Fast Forward 20s'),
                  ),
                ),
              if (state.showBackwardIndicator)
                PositionedDirectional(
                  end: 20,
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: _indicatorWidget(Icons.fast_rewind, context.isArabic ? 'رجوع 20 ثانية' : 'Rewind 20s'),
                  ),
                ),
              if (_showControls)
                _buildControls(context, playerController, chewieController, duration, currentValue, position),
            ],
          ),
        );
      },
    );
  }

  Widget _indicatorWidget(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildControls(
      BuildContext context,
      VideoPlayerController playerController,
      ChewieController chewieController,
      Duration duration,
      double currentValue,
      Duration position,
      ) {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topControls(context, playerController),
              _centerControls(context, playerController, chewieController),
              _bottomControls(context, playerController, chewieController, duration, currentValue, position),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topControls(BuildContext context, VideoPlayerController playerController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<double>(
            icon: Row(
              children: [
                const Icon(Icons.speed, color: Colors.white),
                const SizedBox(width: 4),
                Text('${_currentPlaybackSpeed}x', style: const TextStyle(color: Colors.white)),
              ],
            ),
            onSelected: (value) {
              setState(() => _currentPlaybackSpeed = value);
              playerController.setPlaybackSpeed(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 0.5, child: Text('0.5x')),
              PopupMenuItem(value: 1.0, child: Text('1.0x')),
              PopupMenuItem(value: 1.5, child: Text('1.5x')),
              PopupMenuItem(value: 2.0, child: Text('2.0x')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _centerControls(
      BuildContext context,
      VideoPlayerController playerController,
      ChewieController chewieController,
      ) {
    final hasPrevious = widget.hasPrevious();
    final hasNext = widget.hasNext();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // ✅ prevents full width usage
        children: [
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 40,
              icon: Icon(context.isArabic ? Icons.skip_next : Icons.skip_previous,
                  color: hasPrevious ? Colors.white : Colors.grey.withOpacity(0.5)),
              onPressed: hasPrevious ? widget.onPrevious : null,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 64,
              icon: Icon(
                playerController.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
              ),
              onPressed: () {
                chewieController.togglePause();
                setState(() {
                  _showControls = true;
                  if (!playerController.value.isPlaying) _hideTimer?.cancel();
                });
                if (playerController.value.isPlaying && !_isDragging)
                  _startHideTimer(playerController);
              },
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 40,
              icon: Icon(context.isArabic ? Icons.skip_previous : Icons.skip_next,
                  color: hasNext ? Colors.white : Colors.grey.withOpacity(0.5)),
              onPressed: hasNext ? widget.onNext : null,
            ),
          ),
        ],
      ),
    );

  }

  Widget _bottomControls(
      BuildContext context,
      VideoPlayerController playerController,
      ChewieController chewieController,
      Duration duration,
      double currentValue,
      Duration position,
      ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.red,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayColor: Colors.red.withOpacity(0.2),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: currentValue,
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
                  onChangeStart: (value) async {
                    setState(() {
                      _isDragging = true;
                      _dragValue = value;
                      _showControls = true;
                      _hideTimer?.cancel();
                    });
                    if (playerController.value.isPlaying) {
                      await playerController.pause();
                    }
                    if (_previewController != null && _isPreviewReady) {
                      await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
                      await _previewController!.setLooping(true);
                    }
                  },
                  onChanged: (value) async {
                    setState(() {
                      _dragValue = value;
                      _currentPosition = Duration(milliseconds: value.toInt());
                      final box = context.findRenderObject() as RenderBox?;
                      if (box != null) {
                        final width = box.size.width;
                        final percentage = value / duration.inMilliseconds.toDouble();
                        _dragPosition = Offset(width * percentage, 0);
                      }
                    });
                    if (_previewController != null && _isPreviewReady) {
                      await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
                    }
                  },
                  onChangeEnd: (value) async {
                    await playerController.seekTo(Duration(milliseconds: value.toInt()));
                    if (chewieController.isPlaying) {
                      await playerController.play();
                    }
                    setState(() {
                      _isDragging = false;
                      _dragPosition = null;
                      _currentPosition = Duration(milliseconds: value.toInt());
                    });
                    if (_previewController != null && _isPreviewReady) {
                      await _previewController!.setLooping(false);
                      await _previewController!.pause();
                    }
                    if (playerController.value.isPlaying && !_isDragging) {
                      _startHideTimer(playerController);
                    }
                  },
                ),
              ),
              if (_isDragging && _dragPosition != null && _isPreviewReady)
                Positioned(
                  left: (_dragPosition!.dx - 60).clamp(0.0, MediaQuery.of(context).size.width - 120),
                  top: -100,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 140,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _previewController != null
                                ? VideoPlayer(_previewController!)
                                : const SizedBox.shrink(),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _formatDuration(Duration(milliseconds: _dragValue.toInt())),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  playerController.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  playerController.setVolume(playerController.value.volume > 0 ? 0.0 : 1.0);
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(
                  chewieController.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: chewieController.toggleFullScreen,
              ),
            ],
          ),
        ),

      ],
    );
  }
  // Widget _bottomControls(
  //     BuildContext context,
  //     VideoPlayerController playerController,
  //     ChewieController chewieController,
  //     Duration duration,
  //     double currentValue,
  //     Duration position,
  //     ) {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         child: Stack(
  //           clipBehavior: Clip.none,
  //           children: [
  //             SliderTheme(
  //               data: SliderTheme.of(context).copyWith(
  //                 activeTrackColor: Colors.red,
  //                 inactiveTrackColor: Colors.white.withOpacity(0.3),
  //                 thumbColor: Colors.red,
  //                 thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
  //                 overlayColor: Colors.red.withOpacity(0.2),
  //                 overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
  //                 trackHeight: 3,
  //               ),
  //               child: Slider(
  //                 value: currentValue,
  //                 min: 0.0,
  //                 max: duration.inMilliseconds.toDouble() > 0 ? duration.inMilliseconds.toDouble() : 1.0,
  //                 onChangeStart: (value) async {
  //                   setState(() {
  //                     _isDragging = true;
  //                     _dragValue = value;
  //                     _showControls = true;
  //                     _hideTimer?.cancel();
  //                   });
  //                   // إيقاف المشغل الرئيسي لتجنب التخزين المؤقت
  //                   if (playerController.value.isPlaying) {
  //                     await playerController.pause();
  //                   }
  //                   // تحديث المعاينة فقط
  //                   if (_previewController != null && _isPreviewReady) {
  //                     await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
  //                     await _previewController!.setLooping(true);
  //                   }
  //                 },
  //                 onChanged: (value) async {
  //                   setState(() {
  //                     _dragValue = value;
  //                     _currentPosition = Duration(milliseconds: value.toInt());
  //                     final box = context.findRenderObject() as RenderBox?;
  //                     if (box != null) {
  //                       final width = box.size.width;
  //                       final percentage = value / duration.inMilliseconds.toDouble();
  //                       _dragPosition = Offset(width * percentage, 0);
  //                     }
  //                   });
  //                   // تحديث المعاينة فقط
  //                   if (_previewController != null && _isPreviewReady) {
  //                     await _previewController!.seekTo(Duration(milliseconds: value.toInt()));
  //                   }
  //                 },
  //                 onChangeEnd: (value) async {
  //                   // السعي في المشغل الرئيسي عند إفلات الشريط
  //                   await playerController.seekTo(Duration(milliseconds: value.toInt()));
  //                   // استئناف التشغيل إذا كان يعمل
  //                   if (chewieController.isPlaying) {
  //                     await playerController.play();
  //                   }
  //                   setState(() {
  //                     _isDragging = false;
  //                     _dragPosition = null;
  //                     _currentPosition = Duration(milliseconds: value.toInt());
  //                   });
  //                   // إيقاف المعاينة لتقليل استهلاك الموارد
  //                   if (_previewController != null && _isPreviewReady) {
  //                     await _previewController!.setLooping(false);
  //                     await _previewController!.pause();
  //                   }
  //                   if (playerController.value.isPlaying && !_isDragging) {
  //                     _startHideTimer(playerController);
  //                   }
  //                 },
  //               ),
  //             ),
  //             if (_isDragging && _dragPosition != null && _isPreviewReady)
  //               Positioned(
  //                 left: (_dragPosition!.dx - 60).clamp(0.0, MediaQuery.of(context).size.width - 120),
  //                 top: -100,
  //                 child: Material(
  //                   elevation: 8,
  //                   borderRadius: BorderRadius.circular(12),
  //                   child: Container(
  //                     width: 140,
  //                     height: 100,
  //                     decoration: BoxDecoration(
  //                       color: Colors.black,
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(10),
  //                       child: Stack(
  //                         fit: StackFit.expand,
  //                         children: [
  //                           _previewController != null
  //                               ? VideoPlayer(_previewController!)
  //                               : const SizedBox.shrink(), // تجنب مؤشر التحميل في المعاينة
  //                           Positioned(
  //                             top: 4,
  //                             right: 4,
  //                             child: Container(
  //                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //                               decoration: BoxDecoration(
  //                                 color: Colors.black.withOpacity(0.7),
  //                                 borderRadius: BorderRadius.circular(12),
  //                               ),
  //                               child: Text(
  //                                 _formatDuration(Duration(milliseconds: _dragValue.toInt())),
  //                                 style: const TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 11,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               '${_formatDuration(position)} / ${_formatDuration(duration)}',
  //               style: const TextStyle(color: Colors.white, fontSize: 12),
  //             ),
  //             Row(
  //               children: [
  //                 IconButton(
  //                   icon: Icon(
  //                     playerController.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
  //                     color: Colors.white,
  //                     size: 24,
  //                   ),
  //                   onPressed: () {
  //                     playerController.setVolume(playerController.value.volume > 0 ? 0.0 : 1.0);
  //                     setState(() {});
  //                   },
  //                 ),
  //                 IconButton(
  //                   icon: Icon(
  //                     chewieController.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
  //                     color: Colors.white,
  //                     size: 24,
  //                   ),
  //                   onPressed: chewieController.toggleFullScreen,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }


}

*/