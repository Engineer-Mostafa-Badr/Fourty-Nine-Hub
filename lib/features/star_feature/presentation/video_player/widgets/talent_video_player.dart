import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
<<<<<<<< HEAD:lib/features/star_feature/presentation/video_player/widgets/talent_video_player.dart
========
import 'package:fourtyninehub/main.dart';
>>>>>>>> 086ad4a5d (feat: Add video player feature with controls and state management):lib/features/star_feature/presentation/shared/helpers/youtube_style_video_player.dart
import 'package:video_player/video_player.dart';

import '../../../../../service_locator/service_locator.dart';
import '../../../data/model/comment_model.dart';
import '../../../data/model/tube_video_models.dart';
import '../../../domain/use_case/comment_use_cases.dart';
import '../../presentation_exports.dart';
<<<<<<<< HEAD:lib/features/star_feature/presentation/video_player/widgets/talent_video_player.dart
import 'comments_modal.dart';
import 'floating_video_player.dart';
========
import '../../presentation_exports.dart';

>>>>>>>> 086ad4a5d (feat: Add video player feature with controls and state management):lib/features/star_feature/presentation/shared/helpers/youtube_style_video_player.dart

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
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = true;
  bool _showControls = false;
  bool _showFullDescription = false;
  // Remove local state variables - will use API data instead
  bool _isSubscribed = false;
  List<TubeVideoModel> _recommendedVideos = [];
  bool _loadingRecommended = false;

  Future<void> _loadRecommendedVideos() async {
    setState(() => _loadingRecommended = true);

    try {
      final cubit = context.read<StarCubit>();
      final videos = await cubit.getRecommendedVideos(widget.talent.id);

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

  // Helper methods to get like/dislike states from updated video data
  bool _isLiked(StarCubit starCubit) {
    // Always ensure the video is in state before checking
    starCubit.ensureVideoInState(widget.talent);

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
    // Always ensure the video is in state before checking
    starCubit.ensureVideoInState(widget.talent);

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
    _loadRecommendedVideos();
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
    _starCubit.ensureVideoInState(widget.talent);

    // Initialize video controller in all cases, but only start playback if approved
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

    // If video is not approved, create a basic controller to avoid null issues but don't initialize
    if (!widget.talent.isApproved) {
      _controller = VideoPlayerController.network('about:blank');
      print(
          '⚠️ TalentVideoPlayer: Video not approved, skipping initialization');
      return;
    }

    try {
      // First attempt - standard initialization with timeout
      _controller = VideoPlayerController.network(
        widget.videoUrl,
        formatHint:
            VideoFormat.hls, // Try HLS format first for better compatibility
      );

      await _controller!.initialize().timeout(
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
        widget.onDurationLoaded?.call(_controller!.value.duration);
        _controller!.play();
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

      _controller!.initialize().then((_) {
        if (mounted) {
          print('✅ TalentVideoPlayer: Video loaded with retry method');
          setState(() {
            _isInitialized = true;
          });
          widget.onDurationLoaded?.call(_controller!.value.duration);
          _controller!.play();
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
          widget.onDurationLoaded?.call(_controller!.value.duration);
          _controller!.play();
          return;
        }
      } catch (error) {
        print('❌ TalentVideoPlayer: Strategy $strategy failed: $error');

        // Dispose failed controller before trying next strategy
        try {
          _controller!.dispose();
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

    // Always dispose controller if it exists, but avoid floating video issues
    try {
      if (_controller != null && !FloatingVideoManager.isPlayerVisible) {
        _controller!.dispose();
      }
    } catch (e) {
      print('⚠️ TalentVideoPlayer: Error disposing controller: $e');
    }

    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!widget.talent.isApproved || !_isInitialized || _controller == null)
      return;

    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
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
    if (!widget.talent.isApproved || !_isInitialized || _controller == null)
      return;

    if (_controller!.value.duration.inMilliseconds > 0) {
      final position = (localX / maxWidth).clamp(0.0, 1.0);
      final duration = _controller!.value.duration;
      final newPosition = Duration(
        milliseconds: (position * duration.inMilliseconds).round(),
      );
      _controller!.seekTo(newPosition);
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

    // Check if video is not approved (not available yet)
    final bool isVideoAvailable = widget.talent.isApproved;

    return GestureDetector(
      onTap: () {
        if (!isVideoAvailable)
          return; // Prevent interaction if video is not available
        setState(() => _showControls = !_showControls);
        if (_showControls) {
          _startHideControlsTimer();
        }
      },
      onPanUpdate: _isFullscreen
          ? (details) {
              if (!_showControls && isVideoAvailable) {
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
            // Video Unavailable Cover
            if (!isVideoAvailable)
              Container(
                height: videoHeight,
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          size: 64,
                          color: Colors.orange[700],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.isArabic
                              ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. البث المباشر أو ملف الفيديو غير جاهز بعد. يحتاج وقت ليصبح متاحاً للمستخدمين.'
                              : 'Video uploaded successfully!\n\nNote: Video is not currently available. The live stream or video file are not yet ready. It takes time before it becomes available to users.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 20,
                                color: Colors.orange[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.isArabic
                                    ? 'يتم المعالجة...'
                                    : 'Processing...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_isInitialized && _controller != null)
              Center(
                child: _isFullscreen
                    ? VideoPlayer(_controller!)
                    : AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            if (_showControls && isVideoAvailable) ...[
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
                              controller: _controller!,
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
                            _controller != null
                                ? ValueListenableBuilder<VideoPlayerValue>(
                                    valueListenable: _controller!,
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
                                  )
                                : SizedBox.shrink(),
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
                        _controller != null
                            ? ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: _controller!,
                                builder: (context, value, child) {
                                  final progress =
                                      value.duration.inMilliseconds > 0
                                          ? value.position.inMilliseconds /
                                              value.duration.inMilliseconds
                                          : 0.0;

                                  return LayoutBuilder(
                                    builder: (context, constraints) {
                                      return GestureDetector(
                                        onTapDown: (details) {
                                          _performHapticFeedback();
                                          _seekToPosition(
                                              details.localPosition.dx,
                                              constraints.maxWidth);
                                        },
                                        onHorizontalDragStart: (details) {
                                          setState(() => _isDragging = true);
                                          _hideControlsTimer?.cancel();
                                        },
                                        onHorizontalDragUpdate: (details) {
                                          _seekToPosition(
                                              details.localPosition.dx,
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
                                                  color: Colors.white
                                                      .withOpacity(0.3),
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
                                                            progress.clamp(
                                                                0.0, 1.0) -
                                                        8)
                                                    .clamp(
                                                        0.0,
                                                        constraints.maxWidth -
                                                            16),
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
                                                        offset:
                                                            const Offset(0, 2),
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
                              )
                            : SizedBox.shrink(),
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
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(
                                  //       _isSubscribed
                                  //           ? (context.isArabic
                                  //               ? 'تم الاشتراك'
                                  //               : 'Subscribed')
                                  //           : (context.isArabic
                                  //               ? 'تم إلغاء الاشتراك'
                                  //               : 'Unsubscribed'),
                                  //     ),
                                  //     duration: Duration(seconds: 2),
                                  //   ),
                                  // );
                                  showSuccessMessage(
                                      context,
                                      _isSubscribed
                                          ? (context.isArabic
                                              ? 'تم الاشتراك'
                                              : 'Subscribed')
                                          : (context.isArabic
                                              ? 'تم إلغاء الاشتراك'
                                              : 'Unsubscribed'));
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
                                // IconButton(
                                //   icon: const Icon(
                                //     Icons.notifications_none,
                                //     color: Colors.white,
                                //     size: 18,
                                //   ),
                                //   onPressed: () {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(
                                //         content: Text(
                                //           context.isArabic
                                //               ? 'اشترك أولاً لتفعيل الإشعارات'
                                //               : 'Subscribe first to enable notifications',
                                //         ),
                                //       ),
                                //     );
                                //   },
                                //   padding:
                                //       const EdgeInsets.symmetric(horizontal: 8),
                                //   constraints: const BoxConstraints(),
                                // ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        // Like/Dislike button container
                        StreamBuilder<String>(
                          stream: starCubit.videoUpdates,
                          builder: (context, snapshot) {
                            // Ensure video is in state first
                            starCubit.ensureVideoInState(widget.talent);

                            // Get fresh data on stream update
                            final video =
                                starCubit.getVideoById(widget.talent.id);
                            final isLiked =
                                video?.isLike ?? _isLiked(starCubit);
                            final isDisliked =
                                video?.isDislike ?? _isDisliked(starCubit);
                            final likes = video?.likes ?? widget.talent.likes;
                            final dislikes =
                                video?.dislikes ?? widget.talent.dislikes;

                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Like button
                                  IconButton(
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
                                      starCubit
                                          .ensureVideoInState(widget.talent);
                                      starCubit.likeTubeVideo(widget.talent.id);
                                    },
                                  ),

                                  // Likes count
                                  Text(
                                    likes.toString().toArabicNumbers(context),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),

                                  // Divider
                                  Container(
                                    width: 1,
                                    height: 24,
                                    color: Colors.grey[400],
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                  ),

                                  // Dislike button
                                  IconButton(
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
                                      starCubit
                                          .ensureVideoInState(widget.talent);
                                      starCubit
                                          .dislikeTubeVideo(widget.talent.id);
                                    },
                                  ),

                                  // Dislikes count
                                  Text(
                                    dislikes
                                        .toString()
                                        .toArabicNumbers(context),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
          if (_loadingRecommended)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_recommendedVideos.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  context.isArabic
                      ? 'لا توجد فيديوهات مرتبطة'
                      : 'No related videos',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ..._recommendedVideos.map((video) => _buildTalentCard(video)),
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
                      BlocProvider.value(
                        value: context.read<StarCubit>(),
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
        title: context.isArabic ? 'إضافة لقائمة التشغيل' : 'Add to playlist',
        onTap: () {
          Navigator.pop(context);
          _showAddToPlaylistDialog(talent);
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

  void _showAddToPlaylistDialog(StarEntity talent) {
    final playlistCubit = serviceLocator<PlaylistCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider<PlaylistCubit>(
        create: (context) => playlistCubit..getMyPlaylists(refresh: true),
        child: AddToPlaylistDialog(videoId: talent.id),
      ),
    );
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
