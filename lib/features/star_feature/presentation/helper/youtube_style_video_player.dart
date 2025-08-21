import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class YouTubeStyleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final bool autoPlay;
  final bool startMuted;
  final VoidCallback? onTap;
  final bool showLiveIndicator;
  final String? thumbnailUrl;

  const YouTubeStyleVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
    this.autoPlay = false,
    this.startMuted = true,
    this.onTap,
    this.showLiveIndicator = false,
    this.thumbnailUrl,
  });

  @override
  State<YouTubeStyleVideoPlayer> createState() =>
      _YouTubeStyleVideoPlayerState();
}

class _YouTubeStyleVideoPlayerState extends State<YouTubeStyleVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showControls = true;
  bool _isFavorite = false;
  bool _isDragging = false; // ← أضفنا المتغير ده
  double _visibilityFraction = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _isMuted = widget.startMuted;
            _controller.setVolume(_isMuted ? 0 : 1);
          });

          // Auto-play if specified and visible
          if (widget.autoPlay && _visibilityFraction > 0.5) {
            _controller.play();
            setState(() => _isPlaying = true);
          }
        }
      });

    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // يمكنك إضافة منطق حفظ الفيديو هنا
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    _visibilityFraction = info.visibleFraction;

    if (!_isInitialized) return;

    // Play when 50% or more is visible
    if (info.visibleFraction > 0.5) {
      if (!_controller.value.isPlaying && widget.autoPlay) {
        _controller.play();
        setState(() => _isPlaying = true);
      }
    } else {
      // Pause when less than 50% is visible
      if (_controller.value.isPlaying) {
        _controller.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  void _seekToPosition(double localX) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && _controller.value.duration.inMilliseconds > 0) {
      final position = (localX / renderBox.size.width).clamp(0.0, 1.0);
      final duration = _controller.value.duration;
      final newPosition = Duration(
        milliseconds: (position * duration.inMilliseconds).round(),
      );
      _controller.seekTo(newPosition);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.videoUrl}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
          widget.onTap?.call();
        },
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.3,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Thumbnail - يظهر دائماً لما الفيديو مش شغال
              if (widget.thumbnailUrl != null && !_isPlaying)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.thumbnailUrl!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              // Video Player - يظهر فقط لما الفيديو متهيأ
              if (_isInitialized)
                AnimatedOpacity(
                  opacity: _isPlaying ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),

              // Loading Indicator - يظهر فقط لما الفيديو لسه بيتحمل
              if (!_isInitialized)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),

              // Top Left Controls (Favorite)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: _isPlaying
                        ? Colors.black12
                        : Color(0xffD9D9D9).withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite
                          ? Icons.favorite_border_rounded
                          : Icons.favorite_rounded,
                      color: Color(0xffFF0000),
                      size: 25,
                    ),
                    onPressed: _toggleFavorite,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),

              // Top Right Controls (Mute)
              if (_isInitialized)
                Positioned(
                  top: 10,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isPlaying
                          ? Colors.black12
                          : Color(0xffD9D9D9).withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: _isPlaying ? Colors.white : Colors.black,
                        size: 25,
                      ),
                      onPressed: _toggleMute,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),

              // Bottom Right Controls (Remaining Time)
              if (_isInitialized)
                Positioned(
                  bottom: _isPlaying || _isDragging ? 18 : 10, // ← عدلنا الشرط
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: _controller,
                      builder: (context, value, child) {
                        if (!_isPlaying && !_isDragging) {
                          // ← عدلنا الشرط
                          // عرض الزمن الكلي للفيديو لو مش شغال
                          return Text(
                            _formatDuration(value.duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else {
                          // عرض الوقت المتبقي لو شغال أو بيتسحب
                          final remainingTime = value.duration - value.position;
                          return Text(
                            _formatDuration(remainingTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

              // Progress Bar - يظهر لو الفيديو شغال أو بيتسحب
              if (_isInitialized &&
                  (_isPlaying || _isDragging)) // ← عدلنا الشرط
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTapDown: (details) {
                      _seekToPosition(details.localPosition.dx);
                    },
                    onPanUpdate: (details) {
                      _seekToPosition(details.localPosition.dx);
                    },
                    onPanStart: (details) {
                      setState(() {
                        _isDragging = true; // ← بدأ السحب
                      });
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      }
                    },
                    onPanEnd: (details) {
                      setState(() {
                        _isDragging = false; // ← انتهى السحب
                      });
                      if (_isPlaying) {
                        _controller.play();
                      }
                    },
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Progress Bar Background
                          Container(
                            height: 4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Progress Bar Fill
                          ValueListenableBuilder<VideoPlayerValue>(
                            valueListenable: _controller,
                            builder: (context, value, child) {
                              final progress = value.duration.inMilliseconds > 0
                                  ? value.position.inMilliseconds /
                                      value.duration.inMilliseconds
                                  : 0.0;
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 4,
                                  width: MediaQuery.of(context).size.width *
                                      progress.clamp(0.0, 1.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Progress Indicator Circle
                          ValueListenableBuilder<VideoPlayerValue>(
                            valueListenable: _controller,
                            builder: (context, value, child) {
                              final progress = value.duration.inMilliseconds > 0
                                  ? value.position.inMilliseconds /
                                      value.duration.inMilliseconds
                                  : 0.0;
                              final clampedProgress = progress.clamp(0.0, 1.0);
                              return Positioned(
                                left: (MediaQuery.of(context).size.width *
                                        clampedProgress) -
                                    5,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
