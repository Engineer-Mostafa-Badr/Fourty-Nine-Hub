import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../data/model/tube_video_models.dart';
import '../../presentation_exports.dart';
import 'talent_video_player.dart';

// YouTube Style Video Player
class YouTubeStyleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final bool autoPlay;
  final bool startMuted;
  final VoidCallback? onTap;
  final bool showLiveIndicator;
  final String? thumbnailUrl;
  final StarEntity? talent;

  const YouTubeStyleVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
    this.autoPlay = false,
    this.startMuted = true,
    this.onTap,
    this.showLiveIndicator = false,
    this.thumbnailUrl,
    this.talent,
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
  bool _isDragging = false;
  double _visibilityFraction = 0;
  List<TubeVideoModel> _recommendedVideos = [];
  bool _loadingRecommended = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _loadRecommendedVideos();
  }

  Future<void> _loadRecommendedVideos() async {
    if (widget.talent == null) return;

    setState(() => _loadingRecommended = true);

    try {
      final cubit = context.read<StarCubit>();
      final videos = await cubit.getRecommendedVideos(widget.talent!.id);

      if (mounted) {
        setState(() {
          _recommendedVideos = videos;
          _loadingRecommended = false;
        });
      }
    } catch (e) {
      print('Error loading recommended videos: $e');
      if (mounted) {
        setState(() => _loadingRecommended = false);
      }
    }
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

  void _retryVideoInitialization() {
    print('🔄 YouTubeStyleVideoPlayer: Retrying video initialization...');

    try {
      _controller = VideoPlayerController.network(
        widget.videoUrl,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      _controller.initialize().then((_) {
        if (mounted) {
          print('✅ YouTubeStyleVideoPlayer: Video loaded with retry method');
          setState(() {
            _isInitialized = true;
            _isMuted = widget.startMuted;
            _controller.setVolume(_isMuted ? 0 : 1);
          });
          _controller.addListener(_videoListener);

          if (widget.autoPlay && _visibilityFraction > 0.5) {
            _controller.play();
            setState(() => _isPlaying = true);
          }
        }
      }).catchError((secondError) {
        print('❌ YouTubeStyleVideoPlayer: Retry failed: $secondError');

        if (mounted) {
          // Show error state in UI
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load video. Please try again.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => _initializeVideo(),
              ),
            ),
          );
        }
      });
    } catch (e) {
      print('💥 YouTubeStyleVideoPlayer: Exception during retry: $e');
    }
  }

  Future<void> _handleCodecError() async {
    print(
        '🔧 YouTubeStyleVideoPlayer: Handling codec error with intelligent fallback strategies...');
    print('📱 Device info: ${VideoUtils.getDeviceInfo()}');

    final strategies = VideoUtils.getFallbackStrategies('codec error');

    for (int i = 0; i < strategies.length; i++) {
      final strategy = strategies[i];
      print(
          '🔄 YouTubeStyleVideoPlayer: Trying strategy ${i + 1}: $strategy...');

      try {
        _controller = await VideoInitializer.initializeWithStrategy(
          widget.videoUrl,
          strategy,
        );

        if (mounted) {
          print(
              '✅ YouTubeStyleVideoPlayer: Video loaded with strategy $strategy');
          setState(() {
            _isInitialized = true;
            _isMuted = widget.startMuted;
            _controller.setVolume(_isMuted ? 0 : 1);
          });
          _controller.addListener(_videoListener);

          if (widget.autoPlay && _visibilityFraction > 0.5) {
            _controller.play();
            setState(() => _isPlaying = true);
          }
          return;
        }
      } catch (error) {
        print('❌ YouTubeStyleVideoPlayer: Strategy $strategy failed: $error');

        // Dispose failed controller before trying next strategy
        try {
          await _controller.dispose();
        } catch (e) {
          print('⚠️ YouTubeStyleVideoPlayer: Error disposing controller: $e');
        }

        // If this is the last strategy and it failed, show error to user
        if (i == strategies.length - 1) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Video format not supported on this device'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () => _initializeVideo(),
                ),
              ),
            );
          }
        }
      }
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
    if (widget.talent != null) {
      context.read<StarCubit>().toggleFavorite(widget.talent!.id);
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    _visibilityFraction = info.visibleFraction;

    if (!_isInitialized) return;

    if (info.visibleFraction > 0.5) {
      if (!_controller.value.isPlaying && widget.autoPlay) {
        _controller.play();
        setState(() => _isPlaying = true);
      }
    } else {
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

  void _openFullVideoPlayer() {
    if (widget.talent != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TalentVideoPlayer(
            videoUrl: widget.videoUrl,
            talent: widget.talent!,
          ),
        ),
      );
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
      child: BlocBuilder<StarCubit, StarState>(
        builder: (context, state) {
          final cubit = context.read<StarCubit>();
          final isFavorite = widget.talent != null
              ? cubit.isFavorite(widget.talent!.id)
              : false;

          return GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              setState(() => _showControls = !_showControls);
              widget.onTap?.call();
              _openFullVideoPlayer();
            },
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background Thumbnail
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

                  // Video Player
                  if (_isInitialized)
                    AnimatedOpacity(
                      opacity: _isPlaying ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),

                  // Loading Indicator
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
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isPlaying
                              ? Colors.black12
                              : Color(0xffD9D9D9).withValues(alpha: .5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: Color(0xffFF0000),
                            size: 25,
                          ),
                          onPressed: _toggleFavorite,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
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
                      bottom: _isPlaying || _isDragging ? 18 : 10,
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
                        child: _controller != null
                            ? ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: _controller,
                                builder: (context, value, child) {
                                  if (!_isPlaying && !_isDragging) {
                                    return Text(
                                      _formatDuration(value.duration),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  } else {
                                    final remainingTime =
                                        value.duration - value.position;
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
                              )
                            : SizedBox.shrink(),
                      ),
                    ),

                  // Progress Bar
                  if (_isInitialized && (_isPlaying || _isDragging))
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
                            _isDragging = true;
                          });
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          }
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _isDragging = false;
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
                              _controller != null
                                  ? ValueListenableBuilder<VideoPlayerValue>(
                                      valueListenable: _controller,
                                      builder: (context, value, child) {
                                        final progress = value
                                                    .duration.inMilliseconds >
                                                0
                                            ? value.position.inMilliseconds /
                                                value.duration.inMilliseconds
                                            : 0.0;
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            height: 4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                progress.clamp(0.0, 1.0),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox.shrink(),
                              // Progress Indicator Circle
                              _controller != null
                                  ? ValueListenableBuilder<VideoPlayerValue>(
                                      valueListenable: _controller,
                                      builder: (context, value, child) {
                                        final progress = value
                                                    .duration.inMilliseconds >
                                                0
                                            ? value.position.inMilliseconds /
                                                value.duration.inMilliseconds
                                            : 0.0;
                                        final clampedProgress =
                                            progress.clamp(0.0, 1.0);
                                        return Positioned(
                                          left: (MediaQuery.of(context)
                                                      .size
                                                      .width *
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
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
