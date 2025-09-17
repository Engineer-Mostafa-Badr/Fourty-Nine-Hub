import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/profile_page.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/main.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../service_locator/service_locator.dart';
import '../../data/model/comment_model.dart';
import '../../data/model/tube_video_models.dart';
import '../../domain/use_case/comment_use_cases.dart';
import '../controller/comment_cubit/comment_cubit.dart';
import '../controller/profile_cubit/profile_cubit.dart';
import '../utils/video_utils.dart';
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
  final StarCubit? starCubit;
  final CommentCubit? commentCubit;

  const TalentVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onDurationLoaded,
    required this.talent,
    this.starCubit,
    this.commentCubit,
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
  bool _showFullDescription = false;
  // Remove local state variables - will use API data instead
  bool _isSubscribed = false;

  // Helper methods to get like/dislike states from updated video data
  bool _isLiked(StarCubit starCubit) {
    final updatedVideo = starCubit.getVideoById(widget.talent.id);
    if (updatedVideo != null) {
      return updatedVideo.isLike;
    }
    // Fallback to original data
    if (widget.talent is TubeVideoModel) {
      return (widget.talent as TubeVideoModel).isLike;
    }
    return false;
  }

  bool _isDisliked(StarCubit starCubit) {
    final updatedVideo = starCubit.getVideoById(widget.talent.id);
    if (updatedVideo != null) {
      return updatedVideo.isDislike;
    }
    // Fallback to original data
    if (widget.talent is TubeVideoModel) {
      return (widget.talent as TubeVideoModel).isDislike;
    }
    return false;
  }

  bool _isFullscreen = false;
  Timer? _hideControlsTimer;
  bool _isDragging = false;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late CommentCubit _commentCubit;
  late StarCubit _starCubit;

  @override
  void initState() {
    super.initState();
    // _commentCubit = context.read<CommentCubit>();
    _commentCubit = widget.commentCubit ??
        CommentCubit(
          serviceLocator<CreateCommentUseCase>(),
          serviceLocator<GetCommentsUseCase>(),
          serviceLocator<UpdateCommentUseCase>(),
          serviceLocator<DeleteCommentUseCase>(),
          serviceLocator<LikeCommentUseCase>(),
          serviceLocator<DislikeCommentUseCase>(),
        );
    _starCubit = widget.starCubit ?? serviceLocator<StarCubit>();
    _initializeVideo();
    // Load comments for this video
    _commentCubit.getVideoComments(widget.talent.id, refresh: true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeVideo() async {
    print('🎥 TalentVideoPlayer: Initializing video: ${widget.videoUrl}');

    try {
      // First attempt - standard initialization with timeout
      _controller = VideoPlayerController.network(
        widget.videoUrl,
        formatHint:
            VideoFormat.hls, // Try HLS format first for better compatibility
      );

      await _controller.initialize().timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException(
              'Video initialization timeout', Duration(seconds: 15));
        },
      );

      if (mounted) {
        print('✅ TalentVideoPlayer: Video initialized successfully');
        setState(() {
          _isInitialized = true;
        });
        widget.onDurationLoaded?.call(_controller.value.duration);
        _controller.play();
      }
    } catch (error) {
      print('❌ TalentVideoPlayer: Video initialization error: $error');

      // Check if it's a codec error
      if (error.toString().contains('MediaCodec') ||
          error.toString().contains('ExoPlaybackException') ||
          error.toString().contains('codec')) {
        print(
            '🔧 TalentVideoPlayer: Detected codec error, trying fallback strategies...');
        await _handleCodecError();
      } else {
        // Try standard retry for other errors
        if (mounted) {
          _retryVideoInitialization();
        }
      }
    }
  }

  void _retryVideoInitialization() {
    print('🔄 TalentVideoPlayer: Retrying video initialization...');

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
          print('✅ TalentVideoPlayer: Video loaded with retry method');
          setState(() {
            _isInitialized = true;
          });
          widget.onDurationLoaded?.call(_controller.value.duration);
          _controller.play();
        }
      }).catchError((secondError) {
        print('❌ TalentVideoPlayer: Retry failed: $secondError');

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
      print('💥 TalentVideoPlayer: Exception during retry: $e');
    }
  }

  Future<void> _handleCodecError() async {
    print(
        '🔧 TalentVideoPlayer: Handling codec error with intelligent fallback strategies...');
    print('📱 Device info: ${VideoUtils.getDeviceInfo()}');

    final strategies = [
      VideoInitializationStrategy.noFormatHint,
      VideoInitializationStrategy.dashFormat,
      VideoInitializationStrategy.otherFormat,
      VideoInitializationStrategy.alternativeOptions,
    ];

    for (int i = 0; i < strategies.length; i++) {
      final strategy = strategies[i];
      print('🔄 TalentVideoPlayer: Trying strategy ${i + 1}: $strategy...');

      try {
        _controller = await VideoInitializer.initializeWithStrategy(
          widget.videoUrl,
          strategy,
        );

        if (mounted) {
          print('✅ TalentVideoPlayer: Video loaded with strategy $strategy');
          setState(() {
            _isInitialized = true;
          });
          widget.onDurationLoaded?.call(_controller.value.duration);
          _controller.play();
          return;
        }
      } catch (error) {
        print('❌ TalentVideoPlayer: Strategy $strategy failed: $error');

        // Dispose failed controller before trying next strategy
        try {
          _controller.dispose();
        } catch (e) {
          // Ignore disposal errors
        }

        continue;
      }
    }

    // All strategies failed - show error to user
    if (mounted) {
      print('💥 TalentVideoPlayer: All codec fallback strategies failed');
      final deviceInfo = VideoUtils.getDeviceInfo();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Video format not supported on ${deviceInfo['platform']}. Please try another video.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _initializeVideo(),
          ),
        ),
      );
    }
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

  void _showCommentsModal(List<CommentModel> comments) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: _commentCubit,
        child: CommentsModal(
          videoId: widget.talent.id,
          onAddComment: (comment) {
            _commentCubit.createComment(
              videoId: widget.talent.id,
              content: comment,
            );
          },
        ),
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

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<StarCubit>(),
          child: BlocProvider<ProfileCubit>(
            create: (context) => serviceLocator<ProfileCubit>()
              ..getProfileById(widget.talent.user.id),
            child: ProfilePageView(
              user: widget.talent.user,
              userVideos: [],
              isCurrentUser: false,
              profileId: widget.talent.user.id,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return BlocProvider.value(
      value: _commentCubit,
      child: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, commentState) {
          return BlocBuilder<StarCubit, StarState>(
            builder: (context, starState) {
              final starCubit = _starCubit;
              final isFavorite = starCubit.isFavorite(widget.talent.id);

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
                    // Title - استخدم الداتا الحقيقية
                    Text(
                      widget.talent.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Views and time - استخدم الداتا الحقيقية
                    Row(
                      children: [
                        Text(
                          '${_formatViewCount(widget.talent.totalViews).toArabicNumbers(context)} ${context.isArabic ? 'مشاهدة' : 'views'}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        Text(
                          ' · ',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        Text(
                          _formatTimeAgo(
                                  widget.talent.createdAt ?? DateTime.now())
                              .toArabicNumbers(context),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const Spacer(),
                        // Star rating - استخدم الداتا الحقيقية
                        Row(
                          children: List.generate(
                            5,
                            (index) => GestureDetector(
                              onTap: () {
                                starCubit.updateRating(
                                    widget.talent.id, index + 1);
                              },
                              child: Icon(
                                index < widget.talent.averageRating
                                    ? Icons.star
                                    : Icons.star_outline,
                                size: 20,
                                color: index < widget.talent.averageRating
                                    ? Colors.amber[600]
                                    : Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    // Description (إذا كان موجود)
                    if (widget.talent.description.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.talent.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: _showFullDescription ? null : 2,
                              overflow: _showFullDescription
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            if (widget.talent.description.length > 100)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showFullDescription =
                                        !_showFullDescription;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _showFullDescription
                                        ? (context.isArabic
                                            ? 'إظهار أقل'
                                            : 'Show less')
                                        : (context.isArabic
                                            ? 'إظهار المزيد'
                                            : 'Show more'),
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Channel info and subscribe - استخدم الداتا الحقيقية
                    Row(
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: () => _navigateToProfile(),
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
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.person,
                                              color: Colors.grey),
                                    )
                                  : const Icon(Icons.person,
                                      color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Channel name and subscribers - استخدم الداتا الحقيقية
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _navigateToProfile(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.talent.user.firstName} ${widget.talent.user.lastName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '${_formatViewCount(widget.talent.user.viewNumber).toArabicNumbers(context)} ${context.isArabic ? 'مشترك' : 'subscribers'}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Subscribe button with bell
                        Container(
                          decoration: BoxDecoration(
                            color: _isSubscribed ? Colors.grey : Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isSubscribed = !_isSubscribed;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _isSubscribed
                                            ? (context.isArabic
                                                ? 'تم الاشتراك'
                                                : 'Subscribed')
                                            : (context.isArabic
                                                ? 'تم إلغاء الاشتراك'
                                                : 'Unsubscribed'),
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Text(
                                  _isSubscribed
                                      ? (context.isArabic
                                          ? 'مشترك'
                                          : 'Subscribed')
                                      : (context.isArabic
                                          ? 'اشتراك'
                                          : 'Subscribe'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (!_isSubscribed) ...[
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.grey[600],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_none,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.isArabic
                                              ? 'اشترك أولاً لتفعيل الإشعارات'
                                              : 'Subscribe first to enable notifications',
                                        ),
                                      ),
                                    );
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action buttons - اربطها بالـ APIs الحقيقية
                    Row(
                      children: [
                        // Like button
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              // Like button
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    BlocBuilder<StarCubit, StarState>(
                                      builder: (context, starState) {
                                        final isLiked = _isLiked(starCubit);
                                        return IconButton(
                                          icon: Icon(
                                            isLiked
                                                ? Icons.thumb_up
                                                : Icons.thumb_up_outlined,
                                            size: 20,
                                            color: isLiked
                                                ? Colors.blue
                                                : Colors.grey[700],
                                          ),
                                          onPressed: () {
                                            ManageVibration.vibrate();
                                            // اعمل API call - الـ cubit هيتولى تحديث الحالة
                                            starCubit.likeTubeVideo(
                                                widget.talent.id);
                                          },
                                        );
                                      },
                                    ),

                                    // عرض عدد الـ likes
                                    BlocBuilder<StarCubit, StarState>(
                                      builder: (context, starState) {
                                        // استخدم العدد المحدث من الـ cubit
                                        final updatedVideo = starCubit
                                            .getVideoById(widget.talent.id);
                                        int likes = updatedVideo?.likes ??
                                            widget.talent.likes;

                                        // make it arabic numbers
                                        return Text(
                                          likes
                                              .toString()
                                              .toArabicNumbers(context),
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        );
                                      },
                                    ),

                                    Container(
                                      width: 1,
                                      height: 24,
                                      color: Colors.grey[400],
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    ),

                                    BlocBuilder<StarCubit, StarState>(
                                      builder: (context, starState) {
                                        final isDisliked =
                                            _isDisliked(starCubit);
                                        return IconButton(
                                          icon: Icon(
                                            isDisliked
                                                ? Icons.thumb_down
                                                : Icons.thumb_down_outlined,
                                            size: 20,
                                            color: isDisliked
                                                ? Colors.red
                                                : Colors.grey[700],
                                          ),
                                          onPressed: () {
                                            ManageVibration.vibrate();
                                            // اعمل API call - الـ cubit هيتولى تحديث الحالة
                                            starCubit.dislikeTubeVideo(
                                                widget.talent.id);
                                          },
                                        );
                                      },
                                    ),

                                    // عرض عدد الـ dislikes
                                    BlocBuilder<StarCubit, StarState>(
                                      builder: (context, starState) {
                                        // استخدم العدد المحدث من الـ cubit
                                        final updatedVideo = starCubit
                                            .getVideoById(widget.talent.id);
                                        int dislikes = updatedVideo?.dislikes ??
                                            widget.talent.dislikes;

                                        return Text(
                                          dislikes
                                              .toString()
                                              .toArabicNumbers(context),
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // const SizedBox(width: 12),

                        // // Favorite button
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[200],
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: IconButton(
                        //     icon: Icon(
                        //       isFavorite ? Icons.favorite : Icons.favorite_border,
                        //       size: 20,
                        //       color: isFavorite ? Colors.red : Colors.grey[700],
                        //     ),
                        //     onPressed: () {
                        //       starCubit.toggleFavorite(widget.talent.id);
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Comments section header
                    GestureDetector(
                      onTap: () => _showCommentsModal(commentState.comments),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  context.isArabic ? 'التعليقات' : 'Comments',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Label(
                                  text: commentState.totalComments
                                      .toString()
                                      .toArabicNumbers(context),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                              ],
                            ),
                            // Show loading or first comment preview
                            if (commentState.isLoading)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            else if (commentState.comments.isNotEmpty)
                              _buildCommentPreview(commentState.comments.first),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCommentPreview(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: comment.owner.channelPicture?.mediaKey.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: comment.owner.channelPicture!.mediaKey,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, color: Colors.grey, size: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              comment.content,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
              context.isArabic ? 'مقاطع مرتبطة' : 'Related Videos',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider<StarCubit>(
                        create: (context) => serviceLocator<StarCubit>(),
                      ),
                      BlocProvider<CommentCubit>(
                        create: (context) => serviceLocator<CommentCubit>(),
                      ),
                    ],
                    child: TalentVideoPlayer(
                      videoUrl: mediaUrl,
                      talent: talent,
                    ),
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
    final viewCount = views.toInt();
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return context.isArabic
          ? '$years ${years == 1 ? 'سنة' : 'سنوات'}'
          : '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return context.isArabic
          ? '$months ${months == 1 ? 'شهر' : 'أشهر'}'
          : '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return context.isArabic
          ? '${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}'
          : '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return context.isArabic
          ? '${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}'
          : '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }
    return context.isArabic ? 'منذ قليل' : 'Just now';
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
  final String videoId;
  final Function(String) onAddComment;

  const CommentsModal({
    super.key,
    required this.videoId,
    required this.onAddComment,
  });

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more comments when reached bottom
      context.read<CommentCubit>().loadMoreComments(widget.videoId);
    }
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
      child: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          return Column(
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
                    Label(
                      text:
                          '${context.isArabic ? 'التعليقات' : 'Comments'} (${state.totalComments.toString().toArabicNumbers(context)})', // تأكد إن العدد يظهر هنا
                      style: const TextStyle(
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
                child: state.comments.isEmpty && !state.isLoading
                    ? _buildEmptyCommentsState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            state.comments.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.comments.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final comment = state.comments[index];
                          return _buildCommentItem(comment, context);
                        },
                      ),
              ),

              // Add comment section
              _buildAddCommentSection(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCommentsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to comment!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment, BuildContext context) {
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
            child: ClipOval(
              child: comment.owner.channelPicture?.mediaKey.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: comment.owner.channelPicture!.mediaKey,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 20, color: Colors.grey),
            ),
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
                      comment.owner.channelName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.timeAgo.toArabicNumbers(context),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<CommentCubit>().likeComment(comment.id);
                      },
                      child: Row(
                        children: [
                          Icon(
                            comment.isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            size: 16,
                            color: comment.isLiked
                                ? Colors.blue
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Label(
                            text: comment.likes
                                .toString()
                                .toArabicNumbers(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        context.read<CommentCubit>().dislikeComment(comment.id);
                      },
                      child: Row(
                        children: [
                          Icon(
                            comment.isDisliked
                                ? Icons.thumb_down
                                : Icons.thumb_down_outlined,
                            size: 16,
                            color: comment.isDisliked
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Label(
                            text: comment.dislikes
                                .toString()
                                .toArabicNumbers(context),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More options
          IconButton(
            icon: Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
            onPressed: () => _showCommentOptions(comment),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentSection(CommentState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 +
            MediaQuery.of(context).viewInsets.bottom, // إضافة مهمة للكيبورد
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.only(
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
              child: const Icon(Icons.person, size: 18, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onSubmitted: (value) => _submitComment(state),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: _commentController.text.isNotEmpty
                    ? Colors.blue
                    : Colors.grey[400],
              ),
              onPressed:
                  state.isCreatingComment ? null : () => _submitComment(state),
            ),
          ],
        ),
      ),
    );
  }

  void _submitComment(CommentState state) {
    if (_commentController.text.isNotEmpty && !state.isCreatingComment) {
      widget.onAddComment(_commentController.text);
      _commentController.clear();
    }
  }

  void _showCommentOptions(CommentModel comment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Comment info header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: comment
                                  .owner.channelPicture?.mediaKey.isNotEmpty ==
                              true
                          ? CachedNetworkImage(
                              imageUrl: comment.owner.channelPicture!.mediaKey,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.person, color: Colors.grey, size: 16),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.owner.channelName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          comment.content,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // Options list
            Column(
              children: [
                // Edit option (only for user's own comments)
                if (_isUserComment(comment))
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic ? 'تعديل التعليق' : 'Edit Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showEditCommentDialog(comment);
                    },
                  ),

                // Delete option (only for user's own comments)
                if (_isUserComment(comment))
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic ? 'حذف التعليق' : 'Delete Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteCommentDialog(comment);
                    },
                  ),

                // Reply option (for all comments)
                if (!comment.isReply)
                  ListTile(
                    leading: Icon(
                      Icons.reply,
                      color: Colors.green,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic ? 'رد على التعليق' : 'Reply to Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showReplyDialog(comment);
                    },
                  ),

                // Report option (for other users' comments)
                if (!_isUserComment(comment))
                  ListTile(
                    leading: Icon(
                      Icons.flag,
                      color: Colors.orange,
                      size: 22,
                    ),
                    title: Text(
                      context.isArabic
                          ? 'الإبلاغ عن التعليق'
                          : 'Report Comment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showReportDialog(comment);
                    },
                  ),

                // Cancel option
                ListTile(
                  leading: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  title: Text(
                    context.isArabic ? 'إلغاء' : 'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

// Check if comment belongs to current user
  bool _isUserComment(CommentModel comment) {
    // هنا تحط الـ logic بتاع التحقق من إن التعليق للمستخدم الحالي
    // ممكن تقارن الـ user ID أو channel name
    return comment.owner.channelName == '@Me'; // مؤقت للتجربة
  }

// Edit comment dialog
  void _showEditCommentDialog(CommentModel comment) {
    final TextEditingController editController =
        TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'تعديل التعليق' : 'Edit Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            hintText:
                context.isArabic ? 'اكتب تعليقك...' : 'Write your comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.all(12),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                // Call update comment API
                context.read<CommentCubit>().updateComment(
                      comment.id,
                      editController.text.trim(),
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic ? 'تم تحديث التعليق' : 'Comment updated',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'حفظ' : 'Save'),
          ),
        ],
      ),
    );
  }

// Delete comment dialog
  void _showDeleteCommentDialog(CommentModel comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'حذف التعليق' : 'Delete Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          context.isArabic
              ? 'هل أنت متأكد من حذف هذا التعليق؟ لا يمكن التراجع عن هذا الإجراء.'
              : 'Are you sure you want to delete this comment? This action cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Call delete comment API
              context.read<CommentCubit>().deleteComment(comment.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic ? 'تم حذف التعليق' : 'Comment deleted',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

// Reply dialog
  void _showReplyDialog(CommentModel comment) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'رد على التعليق' : 'Reply to Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original comment
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${comment.content}"',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Reply field
            TextField(
              controller: replyController,
              decoration: InputDecoration(
                hintText:
                    context.isArabic ? 'اكتب ردك...' : 'Write your reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                // Call reply API
                // context.read<CommentCubit>().replyToComment(
                //       comment.id,
                //       replyController.text.trim(),
                //     );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      context.isArabic ? 'تم إضافة الرد' : 'Reply added',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'رد' : 'Reply'),
          ),
        ],
      ),
    );
  }

// Report dialog
  void _showReportDialog(CommentModel comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'الإبلاغ عن التعليق' : 'Report Comment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          context.isArabic
              ? 'هل تريد الإبلاغ عن هذا التعليق لانتهاكه قواعد المجتمع؟'
              : 'Do you want to report this comment for violating community guidelines?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Call report API here

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic
                        ? 'تم الإبلاغ عن التعليق'
                        : 'Comment reported',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'إبلاغ' : 'Report'),
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
