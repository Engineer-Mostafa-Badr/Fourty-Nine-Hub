import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../domain/entity/star_entity.dart';
import '../../../domain/use_case/comment_use_cases.dart';
import '../../controller/comment_cubit/comment_cubit.dart';
import '../../controller/star_cubit/star_cubit.dart';

// Import new components
import 'video_player_controls.dart';
import 'video_info_section.dart';
import 'comments_modal.dart';
import 'video_player_utils.dart';

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
  late CommentCubit _commentCubit;
  late StarCubit _starCubit;

  bool _isInitialized = false;
  bool _isPlaying = true;
  bool _showControls = false;
  bool _showFullDescription = false;
  bool _isFullscreen = false;
  bool _isDragging = false;

  Timer? _hideControlsTimer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeCubits();
    _initializeVideo();
    _setupSystemUI();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeCubits() {
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

    // Load comments for this video
    _commentCubit.getVideoComments(widget.talent.id, refresh: true);
  }

  void _setupSystemUI() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = await VideoInitializer.initializeWithFallbacks(
        widget.videoUrl,
        timeout: const Duration(seconds: 15),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        _controller.addListener(_videoListener);
        widget.onDurationLoaded?.call(_controller.value.duration);

        if (_isPlaying) {
          _controller.play();
        }
      }
    } catch (error) {
      if (mounted) {
        VideoPlayerUtils.showVideoError(
          context: context,
          message: 'Failed to load video: ${error.toString()}',
          onRetry: _initializeVideo,
        );
      }
    }
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
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
    final isMuted = _controller.value.volume == 0;
    _controller.setVolume(isMuted ? 1.0 : 0.0);
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
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _onSeek(double milliseconds) {
    final position = Duration(milliseconds: milliseconds.toInt());
    _controller.seekTo(position);
  }

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: _commentCubit,
        child: CommentsModal(
          videoId: widget.talent.id,
          onAddComment: (content) {
            _commentCubit.createComment(
              videoId: widget.talent.id,
              content: content,
              parentCommentId: widget.talent.id,
            );
          },
        ),
      ),
    );
  }

  void _toggleDescription() {
    setState(() {
      _showFullDescription = !_showFullDescription;
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _resetHideTimer();
  }

  void _resetHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying && !_isDragging) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _starCubit),
        BlocProvider.value(value: _commentCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isFullscreen) {
      return _buildFullscreenPlayer();
    }

    return Column(
      children: [
        // Video player section
        _buildVideoSection(),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: VideoInfoSection(
              talent: widget.talent,
              starCubit: _starCubit,
              showFullDescription: _showFullDescription,
              onToggleDescription: _toggleDescription,
              onOpenComments: _showCommentsModal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      color: Colors.black,
      child: GestureDetector(
        onTap: () {
          _showControlsTemporarily();
        },
        child: Stack(
          children: [
            // Video player
            if (_isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),

            // Loading indicator
            if (!_isInitialized)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),

            // Video controls overlay
            VideoPlayerControls(
              controller: _controller,
              showControls: _showControls,
              onTogglePlayPause: _togglePlayPause,
              onToggleMute: _toggleMute,
              onToggleFullscreen: _toggleFullscreen,
              onSeek: _onSeek,
              isPlaying: _isPlaying,
              isMuted: _controller.value.volume == 0,
              isFullscreen: _isFullscreen,
              isDragging: _isDragging,
              onDraggingChanged: (dragging) {
                setState(() {
                  _isDragging = dragging;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenPlayer() {
    return GestureDetector(
      onTap: _showControlsTemporarily,
      child: Stack(
        children: [
          // Fullscreen video
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),

          // Loading indicator
          if (!_isInitialized)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // Fullscreen controls
          VideoPlayerControls(
            controller: _controller,
            showControls: _showControls,
            onTogglePlayPause: _togglePlayPause,
            onToggleMute: _toggleMute,
            onToggleFullscreen: _toggleFullscreen,
            onSeek: _onSeek,
            isPlaying: _isPlaying,
            isMuted: _controller.value.volume == 0,
            isFullscreen: _isFullscreen,
            isDragging: _isDragging,
            onDraggingChanged: (dragging) {
              setState(() {
                _isDragging = dragging;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    // Reset system UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}
