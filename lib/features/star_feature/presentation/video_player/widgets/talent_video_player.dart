import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:video_player/video_player.dart';

import '../../../../../service_locator/service_locator.dart';
import '../../../data/model/comment_model.dart';
import '../../../data/model/tube_video_models.dart';
import '../../../domain/use_case/comment_use_cases.dart';
import '../../presentation_exports.dart';
import 'comments_modal.dart';
import 'floating_video_player.dart';
import 'related_videos_section.dart';
import 'video_info_section.dart' as video_info;

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

  bool _isFullscreen = false;
  Timer? _hideControlsTimer;
  bool _isDragging = false;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late CommentCubit _commentCubit;
  late StarCubit _starCubit;
  late ProfileCubit _profileCubit;

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

    // Initialize ProfileCubit for subscription functionality
    _profileCubit = serviceLocator<ProfileCubit>();

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

        // Add listener for video end and play state changes
        _controller!.addListener(_videoListener);

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
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Failed to load video. Please try again.'),
          //     backgroundColor: Colors.red,
          //     action: SnackBarAction(
          //       label: 'Retry',
          //       textColor: Colors.white,
          //       onPressed: () => _initializeVideo(),
          //     ),
          //   ),
          // );
          showErrorMessage(context, secondError.toString());
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

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //         'Video format not supported on ${deviceInfo['platform']}. Please try another video.'),
      //     backgroundColor: Colors.orange,
      //     duration: Duration(seconds: 5),
      //     action: SnackBarAction(
      //       label: 'Retry',
      //       textColor: Colors.white,
      //       onPressed: () => _initializeVideo(),
      //     ),
      //   ),
      // );

      showErrorMessage(context,
          'Video format not supported on ${deviceInfo['platform']}. Please try another video.');
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

  // Video listener to sync play state and handle video end
  void _videoListener() {
    if (_controller == null || !mounted) return;

    final isPlaying = _controller!.value.isPlaying;
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    // Update play/pause icon when state changes
    if (_isPlaying != isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }

    // Check if video ended (within 1 second of duration)
    if (duration.inSeconds > 0 &&
        position.inSeconds >= duration.inSeconds - 1 &&
        _isPlaying) {
      // Video ended, pause and reset icon
      setState(() {
        _isPlaying = false;
      });
    }
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

  // Play next video from recommended list
  void _playNextVideo() {
    if (_recommendedVideos.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text(
      //           context.isArabic ? 'لا توجد فيديوهات أخرى' : 'No more videos')),
      // );
      showSuccessMessage(context,
          context.isArabic ? 'لا توجد فيديوهات أخرى' : 'No more videos');
      return;
    }

    final nextVideo = _recommendedVideos.first;
    _navigateToVideo(nextVideo);
  }

  // Play previous video (navigate back)
  void _playPreviousVideo() {
    Navigator.pop(context);
  }

  // Navigate to another video
  void _navigateToVideo(StarEntity video) {
    final videoUrl = video is TubeVideoModel
        ? (video.videoUrl ?? video.mediaUrl.first.mediaKey)
        : video.mediaUrl.first.mediaKey;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _starCubit),
            BlocProvider<CommentCubit>(
              create: (context) => serviceLocator<CommentCubit>(),
            ),
          ],
          child: TalentVideoPlayer(
            videoUrl: videoUrl,
            talent: video,
            starCubit: _starCubit,
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    if (duration == Duration.zero) {
      return context.isArabic ? '٠:٠٠' : '0:00';
    }

    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    String timeString;
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      timeString = '$hours:${minutes.padLeft(2, '0')}:$seconds';
    } else {
      timeString = '$minutes:$seconds';
    }

    // Convert to Arabic numbers if Arabic locale
    if (context.isArabic) {
      return _convertToArabicNumbers(timeString);
    }
    return timeString;
  }

  String _convertToArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = input;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
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
      // Determine orientation based on video aspect ratio
      if (_controller != null && _controller!.value.isInitialized) {
        final aspectRatio = _controller!.value.aspectRatio;

        if (aspectRatio > 1.0) {
          // Landscape video (wider than tall)
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          // Portrait video (taller than wide)
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      } else {
        // Fallback to landscape if ratio unavailable
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Exit fullscreen - back to portrait
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
                        // GestureDetector(
                        //   onTap: () {
                        //     _performHapticFeedback();
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text('Cast feature coming soon')),
                        //     );
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(8),
                        //     decoration: BoxDecoration(
                        //       color: Colors.black.withOpacity(0.5),
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: const Icon(
                        //       Icons.cast,
                        //       color: Colors.white,
                        //       size: 20,
                        //     ),
                        //   ),
                        // ),
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
                          _playPreviousVideo();
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
                          _playNextVideo();
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
                                                      BorderRadius.circular(
                                                          2.r),
                                                ),
                                              ),
                                              Container(
                                                height: 4.h,
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
                                                            16.w),
                                                child: Container(
                                                  width: 25.w,
                                                  height: 25.h,
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
    return video_info.VideoInfoSection(
      talent: widget.talent,
      starCubit: _starCubit,
      commentCubit: _commentCubit,
      onProfileTap: _navigateToProfile,
      onCommentsTap: () => _showCommentsModal(_commentCubit.state.comments),
    );
  }

  Widget _buildRelatedVideos() {
    return RelatedVideosSection(
      recommendedVideos: _recommendedVideos,
      isLoading: _loadingRecommended,
      starCubit: _starCubit,
      onVideoTap: (video) => _navigateToVideo(video),
    );
  }

  void _showVideoOptions(StarEntity talent) {
    OptionsBottomSheet.showOptions(context: context, options: [
      OptionItem(
        icon: Icons.person_outline,
        title: context.isArabic ? 'زيارة القناة' : 'Visit Channel',
        onTap: () {
          Navigator.pop(context);
          _navigateToProfile();
        },
      ),
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

    return BlocProvider.value(
      value: _profileCubit,
      child: Scaffold(
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
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
      ),
    );
  }
}
