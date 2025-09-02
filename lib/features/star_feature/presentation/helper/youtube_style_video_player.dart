import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/profile_page.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/main.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/common/options_bottom_sheet.dart';

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
                        child: ValueListenableBuilder<VideoPlayerValue>(
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
                        ),
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
                              ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: _controller,
                                builder: (context, value, child) {
                                  final progress =
                                      value.duration.inMilliseconds > 0
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
                                  final progress =
                                      value.duration.inMilliseconds > 0
                                          ? value.position.inMilliseconds /
                                              value.duration.inMilliseconds
                                          : 0.0;
                                  final clampedProgress =
                                      progress.clamp(0.0, 1.0);
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
          );
        },
      ),
    );
  }
}

// Full Video Player
class TalentVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final StarEntity talent;
  final Function(Duration)? onDurationLoaded;

  const TalentVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onDurationLoaded,
    required this.talent,
  });

  @override
  State<TalentVideoPlayer> createState() => _TalentVideoPlayerState();
}

class _TalentVideoPlayerState extends State<TalentVideoPlayer>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = true;
  bool _showControls = false;
  final bool _showFullDescription = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isSubscribed = false;
  bool _isFullscreen = false;
  Timer? _hideControlsTimer;
  bool _isDragging = false;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock comments data
  List<Map<String, dynamic>> comments = [
    {
      'username': '@Ahmed',
      'profileImage': '',
      'comment': 'Heart Touching Nasheed',
      'timeAgo': '1 Months Ago',
      'likes': 4,
      'isLiked': false,
    },
    {
      'username': '@Ahmed',
      'profileImage': '',
      'comment': 'Heart Touching Nasheed',
      'timeAgo': '1 Months Ago',
      'likes': 4,
      'isLiked': false,
    },
    {
      'username': '@Ahmed',
      'profileImage': '',
      'comment': 'Heart Touching Nasheed',
      'timeAgo': '1 Months Ago',
      'likes': 4,
      'isLiked': false,
    },
    {
      'username': '@Ahmed',
      'profileImage': '',
      'comment': 'Heart Touching Nasheed',
      'timeAgo': '1 Months Ago',
      'likes': 4,
      'isLiked': false,
    },
    {
      'username': '@Ahmed',
      'profileImage': '',
      'comment': 'Heart Touching Nasheed',
      'timeAgo': '1 Months Ago',
      'likes': 4,
      'isLiked': false,
    },
    {
      'username': '@Ahmed',
      'profileImage': '',
      'comment': 'Reminds me of...',
      'timeAgo': '1 Months Ago',
      'likes': 4,
      'isLiked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        widget.onDurationLoaded?.call(_controller.value.duration);
        _controller.play();
      });
  }

  @override
  void didChangeMetrics() {
    final orientation = MediaQuery.of(context).orientation;
    setState(() {
      _isFullscreen = orientation == Orientation.landscape;
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    if (!FloatingVideoManager.isPlayerVisible) {
      _controller.dispose();
    }
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  String formatDuration(Duration duration) {
    if (duration == Duration.zero) return '0:00';
    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:${minutes.padLeft(2, '0')}:$seconds';
    }
    return '$minutes:$seconds';
  }

  void _seekToPosition(double localX, double maxWidth) {
    if (_controller.value.duration.inMilliseconds > 0) {
      final position = (localX / maxWidth).clamp(0.0, 1.0);
      final duration = _controller.value.duration;
      final newPosition = Duration(
        milliseconds: (position * duration.inMilliseconds).round(),
      );
      _controller.seekTo(newPosition);
      _performHapticFeedback();
    }
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _showControls && !_isDragging) {
        setState(() => _showControls = false);
      }
    });
  }

  void _performHapticFeedback() {
    HapticFeedback.selectionClick();
  }

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsModal(
        comments: comments,
        onAddComment: (comment) {
          setState(() {
            comments.insert(0, {
              'username': '@User',
              'profileImage': '',
              'comment': comment,
              'timeAgo': 'now',
              'likes': 0,
              'isLiked': false,
            });
          });
        },
      ),
    );
  }

  Widget _buildVideoPlayer() {
    final screenSize = MediaQuery.of(context).size;
    final videoHeight = _isFullscreen ? screenSize.height : 250.0;

    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_showControls) {
          _startHideControlsTimer();
        }
      },
      onPanUpdate: _isFullscreen
          ? (details) {
              if (!_showControls) {
                setState(() => _showControls = true);
                _startHideControlsTimer();
              }
            }
          : null,
      child: Container(
        height: videoHeight,
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            if (_isInitialized)
              Center(
                child: _isFullscreen
                    ? VideoPlayer(_controller)
                    : AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            if (_showControls) ...[
              Positioned(
                top: _isFullscreen ? 24 : 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _performHapticFeedback();
                        if (_isFullscreen) {
                          _toggleFullscreen();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFullscreen
                              ? Icons.fullscreen_exit
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _performHapticFeedback();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Cast feature coming soon')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cast,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _performHapticFeedback();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.flag),
                                      title: const Text('Report'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.info),
                                      title: const Text('Video info'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _performHapticFeedback();
                            FloatingVideoManager.showFloatingPlayer(
                              context: context,
                              videoUrl: widget.videoUrl,
                              title: widget.talent.title,
                              controller: _controller,
                              isPlaying: _isPlaying,
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.picture_in_picture,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isInitialized)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _performHapticFeedback();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Previous video')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          _performHapticFeedback();
                          _togglePlayPause();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          _performHapticFeedback();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Next video')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 20,
                    bottom: _isFullscreen ? 20 : 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_isInitialized)
                            ValueListenableBuilder<VideoPlayerValue>(
                              valueListenable: _controller,
                              builder: (context, value, child) {
                                return Text(
                                  '${formatDuration(value.position)} / ${formatDuration(value.duration)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          GestureDetector(
                            onTap: () {
                              _performHapticFeedback();
                              _toggleFullscreen();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                _isFullscreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isInitialized)
                        ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: _controller,
                          builder: (context, value, child) {
                            final progress = value.duration.inMilliseconds > 0
                                ? value.position.inMilliseconds /
                                    value.duration.inMilliseconds
                                : 0.0;

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return GestureDetector(
                                  onTapDown: (details) {
                                    _performHapticFeedback();
                                    _seekToPosition(details.localPosition.dx,
                                        constraints.maxWidth);
                                  },
                                  onHorizontalDragStart: (details) {
                                    setState(() => _isDragging = true);
                                    _hideControlsTimer?.cancel();
                                  },
                                  onHorizontalDragUpdate: (details) {
                                    _seekToPosition(details.localPosition.dx,
                                        constraints.maxWidth);
                                  },
                                  onHorizontalDragEnd: (details) {
                                    setState(() => _isDragging = false);
                                    _startHideControlsTimer();
                                  },
                                  child: Container(
                                    height: 24,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Container(
                                          height: 4,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        Container(
                                          height: 4,
                                          width: constraints.maxWidth *
                                              progress.clamp(0.0, 1.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        Positioned(
                                          left: (constraints.maxWidth *
                                                      progress.clamp(0.0, 1.0) -
                                                  8)
                                              .clamp(0.0,
                                                  constraints.maxWidth - 16),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Heart Touching Nasheed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // Views and time
          Row(
            children: [
              Text(
                context.isArabic ? '437K المشاهدات' : '437K views',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              Text(
                ' · ',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              Text(
                context.isArabic ? '7 أيام' : '7 days ago',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Spacer(),
              // Star rating
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_outline,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Channel info and subscribe
          Row(
            children: [
              // Avatar
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePageView(
                        user: widget.talent.user,
                        userVideos: [
                          StarEntity(
                            id: '1',
                            title: 'Heart Touching Nasheed - Part 2',
                            description:
                                'A beautiful continuation of heart touching nasheeds',
                            user: UserStarEntity(
                              id: '1',
                              firstName: 'Islamic',
                              lastName: 'Channel',
                              email: 'islamic@example.com',
                              image: '',
                              viewNumber: 507000,
                              averageRating: 4.5,
                            ),
                            mediaUrl: [
                              MediaUrlEntity(
                                id: '1',
                                mediaKey: 'video1.mp4',
                                duration:
                                    const Duration(minutes: 7, seconds: 54),
                                mediaType: 'video/mp4',
                              )
                            ],
                            totalViews: 507000,
                            averageRating: 4,
                            isApproved: true,
                            haveStories: false,
                            storyCount: 0,
                            createdAt: DateTime.now()
                                .subtract(const Duration(days: 300)),
                          ),
                          StarEntity(
                            id: '2',
                            title: 'Beautiful Nasheed Collection 2024',
                            description:
                                'A collection of the most beautiful nasheeds from 2024',
                            user: UserStarEntity(
                              id: '2',
                              firstName: 'Peaceful',
                              lastName: 'Sounds',
                              email: 'peaceful@example.com',
                              image: '',
                              viewNumber: 320000,
                              averageRating: 5.0,
                            ),
                            mediaUrl: [
                              MediaUrlEntity(
                                id: '2',
                                mediaKey: 'video2.mp4',
                                duration:
                                    const Duration(minutes: 12, seconds: 30),
                                mediaType: 'video/mp4',
                              )
                            ],
                            totalViews: 320000,
                            averageRating: 5,
                            isApproved: true,
                            haveStories: true,
                            storyCount: 3,
                            createdAt: DateTime.now()
                                .subtract(const Duration(days: 240)),
                          ),
                          StarEntity(
                            id: '3',
                            title: 'Islamic Nasheed Compilation',
                            description:
                                'Compilation of inspiring Islamic nasheeds',
                            user: UserStarEntity(
                              id: '3',
                              firstName: 'Spiritual',
                              lastName: 'Music',
                              email: 'spiritual@example.com',
                              image: '',
                              viewNumber: 245000,
                              averageRating: 4.2,
                            ),
                            mediaUrl: [
                              MediaUrlEntity(
                                id: '3',
                                mediaKey: 'video3.mp4',
                                duration:
                                    const Duration(minutes: 15, seconds: 45),
                                mediaType: 'video/mp4',
                              )
                            ],
                            totalViews: 245000,
                            averageRating: 3,
                            isApproved: true,
                            haveStories: false,
                            storyCount: 0,
                            createdAt: DateTime.now()
                                .subtract(const Duration(days: 180)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: widget.talent.user.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.talent.user.image,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Channel name and subscribers
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heart Touching',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '437K',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Subscribe button with bell
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSubscribed = !_isSubscribed;
                        });
                      },
                      child: const Text(
                        'Subscribe',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey[600],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Colors.white, size: 18),
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      if (_isLiked) _isDisliked = false;
                    });
                  },
                ),
                const Text('440'),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey[400],
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                IconButton(
                  icon: Icon(
                    _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isDisliked = !_isDisliked;
                      if (_isDisliked) _isLiked = false;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Comments section header
          GestureDetector(
            onTap: _showCommentsModal,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                       Text(
                        context.isArabic
                            ? 'التعليقات'
                            : 'Comments',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '17',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      // const Spacer(),
                      // Icon(Icons.expand_more, color: Colors.grey[600]),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Channel info
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: widget.talent.user.image.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.talent.user.image,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Channel name
                      const Text(
                        'Heart Touching',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRelatedVideos() {
    // Mock related videos data
    final mockRelatedTalents = [
      StarEntity(
        id: '1',
        title: 'Heart Touching Nasheed - Part 2',
        description: 'A beautiful continuation of heart touching nasheeds',
        user: UserStarEntity(
          id: '1',
          firstName: 'Islamic',
          lastName: 'Channel',
          email: 'islamic@example.com',
          image: '',
          viewNumber: 507000,
          averageRating: 4.5,
        ),
        mediaUrl: [
          MediaUrlEntity(
            id: '1',
            mediaKey: 'video1.mp4',
            duration: const Duration(minutes: 7, seconds: 54),
            mediaType: 'video/mp4',
          )
        ],
        totalViews: 507000,
        averageRating: 4,
        isApproved: true,
        haveStories: false,
        storyCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      ),
      StarEntity(
        id: '2',
        title: 'Beautiful Nasheed Collection 2024',
        description: 'A collection of the most beautiful nasheeds from 2024',
        user: UserStarEntity(
          id: '2',
          firstName: 'Peaceful',
          lastName: 'Sounds',
          email: 'peaceful@example.com',
          image: '',
          viewNumber: 320000,
          averageRating: 5.0,
        ),
        mediaUrl: [
          MediaUrlEntity(
            id: '2',
            mediaKey: 'video2.mp4',
            duration: const Duration(minutes: 12, seconds: 30),
            mediaType: 'video/mp4',
          )
        ],
        totalViews: 320000,
        averageRating: 5,
        isApproved: true,
        haveStories: true,
        storyCount: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 240)),
      ),
      StarEntity(
        id: '3',
        title: 'Islamic Nasheed Compilation',
        description: 'Compilation of inspiring Islamic nasheeds',
        user: UserStarEntity(
          id: '3',
          firstName: 'Spiritual',
          lastName: 'Music',
          email: 'spiritual@example.com',
          image: '',
          viewNumber: 245000,
          averageRating: 4.2,
        ),
        mediaUrl: [
          MediaUrlEntity(
            id: '3',
            mediaKey: 'video3.mp4',
            duration: const Duration(minutes: 15, seconds: 45),
            mediaType: 'video/mp4',
          )
        ],
        totalViews: 245000,
        averageRating: 3,
        isApproved: true,
        haveStories: false,
        storyCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
      ),
    ];

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
               context.isArabic
                    ? 'مقاطع مرتبطة'
                    : 'Related Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          ...mockRelatedTalents.map((talent) => _buildTalentCard(talent)),
        ],
      ),
    );
  }

  Widget _buildTalentCard(StarEntity talent) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
    final createdAt = talent.createdAt ?? DateTime.now();

    Map<String, num> talentRatings = {};

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail with YouTube-style player
          GestureDetector(
            onTap: () {
              // Navigate to new video player with the selected talent
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TalentVideoPlayer(
                    videoUrl: mediaUrl,
                    talent: talent,
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/testforvideo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Heart button
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
                // Mute button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volume_off,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                // Duration
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '7:54',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Play button overlay
                const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Video Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: talent.user.image.isNotEmpty
                      ? NetworkImage(talent.user.image)
                      : null,
                  child: talent.user.image.isEmpty
                      ? Icon(Icons.person, size: 18, color: Colors.grey[600])
                      : null,
                ),
                const SizedBox(width: 12),

                // Title and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        talent.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${talent.user.firstName} ${talent.user.lastName}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${_formatViewCount(talent.totalViews)} views • ${_formatTimeAgo(createdAt)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // More Options and Stars
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => _showVideoOptions(talent),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    // Interactive Star Rating
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (starIndex) => GestureDetector(
                          onTap: () {
                            setState(() {
                              // Update rating locally using talent id
                              talentRatings[talent.id] = starIndex + 1;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Rated ${starIndex + 1} stars'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Icon(
                              starIndex <
                                      (talentRatings[talent.id] ??
                                          talent.averageRating)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: starIndex <
                                      (talentRatings[talent.id] ??
                                          talent.averageRating)
                                  ? Colors.amber
                                  : Colors.grey[400],
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatViewCount(num views) {
    // Changed from int to num
    final viewCount = views.toInt(); // Convert to int for calculations
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(0)}K';
    }
    return viewCount.toString();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    }
    return 'Today';
  }

  void _showVideoOptions(StarEntity talent) {
    OptionsBottomSheet.showOptions(context: context, options: [
      OptionItem(
        icon: Icons.playlist_add,
        title: 'Add to playlist',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      OptionItem(
        icon: Icons.watch_later_outlined,
        title: 'Save to Watch Later',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      OptionItem(
        icon: Icons.download_outlined,
        title: 'Download',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      OptionItem(
        icon: Icons.share_outlined,
        title: 'Share',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      OptionItem(
        icon: Icons.block,
        title: 'Not interested',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      OptionItem(
        icon: Icons.report_outlined,
        title: 'Report',
        iconColor: Colors.red,
        textColor: Colors.red,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: _buildVideoPlayer(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          // spacing: -10,
          children: [
            _buildVideoPlayer(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildVideoInfo(),
                    const Divider(height: 1),
                    _buildRelatedVideos(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated Comments Modal
class CommentsModal extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(String) onAddComment;

  const CommentsModal({
    super.key,
    required this.comments,
    required this.onAddComment,
  });

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showCommentOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Save option
            ListTile(
              leading: const Icon(Icons.bookmark_outline, size: 24),
              title: const Text('Save', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment saved')),
                );
              },
            ),
            // Report option
            ListTile(
              leading:
                  const Icon(Icons.flag_outlined, size: 24, color: Colors.red),
              title: const Text('Report',
                  style: TextStyle(fontSize: 16, color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment reported')),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(),

          // Comments list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile picture
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person,
                            size: 20, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),

                      // Comment content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment['username'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '· ${comment['timeAgo']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['comment'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      comment['isLiked'] = !comment['isLiked'];
                                      if (comment['isLiked']) {
                                        comment['likes']++;
                                      } else {
                                        comment['likes']--;
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        comment['isLiked']
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_outlined,
                                        size: 16,
                                        color: comment['isLiked']
                                            ? Colors.blue
                                            : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${comment['likes']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.thumb_down_outlined,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.comment_outlined,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // More options
                      IconButton(
                        icon: Icon(Icons.more_vert,
                            size: 18, color: Colors.grey[600]),
                        onPressed: () => _showCommentOptions(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Add comment section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xff000000)),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.person, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Reminds me of...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: AppColors.LIGHT_GRAY_COLOR),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: AppColors.LIGHT_GRAY_COLOR),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: AppColors.LIGHT_GRAY_COLOR),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: AppColors.LIGHT_GRAY_COLOR),
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          widget.onAddComment(value);
                          _commentController.clear();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: _commentController.text.isNotEmpty
                          ? Colors.blue
                          : Colors.grey[400],
                    ),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        widget.onAddComment(_commentController.text);
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Keep the existing FloatingVideoManager classes as they are
class FloatingVideoManager {
  static OverlayEntry? _overlayEntry;

  static void showFloatingPlayer({
    required BuildContext context,
    required String videoUrl,
    required String title,
    required VideoPlayerController controller,
    required bool isPlaying,
  }) {
    closeFloatingPlayer();

    _overlayEntry = OverlayEntry(
      builder: (context) => FloatingVideoPlayer(
        controller: controller,
        title: title,
        videoUrl: videoUrl,
        isPlaying: isPlaying,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void closeFloatingPlayer() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static bool get isPlayerVisible => _overlayEntry != null;
}

class FloatingVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;
  final String videoUrl;
  final bool isPlaying;

  const FloatingVideoPlayer({
    super.key,
    required this.controller,
    required this.title,
    required this.videoUrl,
    required this.isPlaying,
  });

  @override
  State<FloatingVideoPlayer> createState() => _FloatingVideoPlayerState();
}

class _FloatingVideoPlayerState extends State<FloatingVideoPlayer> {
  late bool _isPlaying;
  late VideoPlayerController _controller;
  late Offset _position;

  bool _showControls = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _isPlaying = widget.isPlaying;
    if (_isPlaying) {
      _controller.play();
    }
    _position = Offset(
      MediaQuery.of(navigatorKey.currentContext!).size.width -
          _floatingSize.width -
          4,
      MediaQuery.of(navigatorKey.currentContext!).size.height -
          _floatingSize.height -
          4,
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  Size get _floatingSize {
    var width = MediaQuery.of(navigatorKey.currentContext!).size.width;
    final baseWidth = _showControls ? width * .9 : width * .6;

    if (!_controller.value.isInitialized) {
      return Size(baseWidth, baseWidth * 16 / 9);
    }

    final videoWidth = _controller.value.size.width;
    final videoHeight = _controller.value.size.height;

    if (videoWidth > videoHeight) {
      return Size(baseWidth, baseWidth * videoHeight / videoWidth);
    } else {
      return Size(baseWidth * videoWidth / videoHeight, baseWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isDragging = true;
              _showControls = true;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              _position = Offset(
                _position.dx + details.delta.dx,
                _position.dy + details.delta.dy,
              );
            });
          },
          onPanEnd: (details) {
            setState(() => _isDragging = false);
            Future.delayed(const Duration(seconds: 2), () {
              if (!_isDragging && mounted) {
                setState(() => _showControls = false);
              }
            });
          },
          onTap: () => setState(() => _showControls = !_showControls),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _floatingSize.width,
            height: _floatingSize.height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  if (_controller.value.isInitialized)
                    Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                  if (_showControls)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 20),
                              onPressed:
                                  FloatingVideoManager.closeFloatingPlayer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_showControls)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                            IconButton(
                              icon: const Icon(Icons.open_in_full,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                ManageVibration.vibrate();
                                FloatingVideoManager.closeFloatingPlayer();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!_showControls)
                    Center(
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
