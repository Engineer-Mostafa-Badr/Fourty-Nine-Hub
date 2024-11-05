import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/profile_buttom_sheet.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_actions.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/custom_progress_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../../service_locator/service_locator.dart';
import '../../../data/models/new_reels_model.dart';
import 'animated_heart_wiidget.dart';

class UnifiedReelItem extends StatefulWidget {
  final Reel reel;
  final bool isVisible;
  final int index;

  final ReelItemType itemType;

  const UnifiedReelItem({
    super.key,
    required this.reel,
    required this.isVisible,
    required this.index,
    this.itemType = ReelItemType.main,
  });

  @override
  State<UnifiedReelItem> createState() => _UnifiedReelItemState();
}

enum ReelItemType { main, instagram, spotlight }

class _UnifiedReelItemState extends State<UnifiedReelItem>
    with
        WidgetsBindingObserver,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = false; // Track visibility state
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;

  late final AnimationController _rotationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Start observing lifecycle changes

    _initializeRotationController();
    _initializePlayer();
  }

  /// Initializes the rotation controller for any rotating UI elements.
  void _initializeRotationController() {
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant UnifiedReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _playVideo() : _pauseVideo();
    }
  }

  // Implement didChangeAppLifecycleState for handling lifecycle events
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseVideo();
      // } else if (state == AppLifecycleState.resumed && widget.isVisible) {
      //   _playVideo();
      // }
    }
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
    try {
      _initializeVideoPlayerFuture =
          _videoPlayerController.initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after initialization
      });
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = widget.isVisible;
        });
      }
      // Add listener for video progress
      _videoPlayerController.addListener(_onVideoProgress);
    } catch (error) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
        _showError('Failed to load video');
      }
    }
  }

  /// Displays an error message using a SnackBar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Starts video playback.
  void _playVideo() {
    if (_isInitialized && !_isPlaying) {
      _videoPlayerController.play();
      // _chewieController?.play();
      setState(() {
        _isPlaying = true;
        _showPlayPauseIcon = true;
      });
      _hidePlayPauseIconAfterDelay();
    }
  }

  /// Pauses video playback.
  void _pauseVideo() {
    if (_isInitialized && _isPlaying) {
      _videoPlayerController.pause();

      // _chewieController?.pause();
      setState(() {
        _isPlaying = false;
        _showPlayPauseIcon = true;
      });
      _hidePlayPauseIconAfterDelay();
    }
  }

  /// Toggles between play and pause states.
  void _togglePlayPause() {
    _isPlaying ? _pauseVideo() : _playVideo();
  }

  /// Hides the play/pause icon after a short delay.
  void _hidePlayPauseIconAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIcon = false;
        });
      }
    });
  }

  /// Handles vertical drag events for the spotlight item type.
  void _handleVerticalDrag(DragEndDetails details) async {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      _pauseVideo();
      await ProfileBottomSheet.show(context, widget.reel);
      _playVideo();
    }
  }

  /// Builds the video content or displays a placeholder if not initialized.
  Widget buildVideoContent() {
    return VisibilityDetector(
      key: Key(widget.reel.videoMedia), // Unique key for each video widget

      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;

        // Play video when more than 50% is visible
        if (visiblePercentage > 50 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
          _videoPlayerController.play();
        } else if (visiblePercentage <= 50 && _isVisible) {
          setState(() {
            _isVisible = false;
          });
          _videoPlayerController.pause();
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: _togglePlayPause,
              onVerticalDragEnd: widget.itemType == ReelItemType.spotlight
                  ? _handleVerticalDrag
                  : null,
              child: DoubleTapHeart(
                onDoubleTap: () async {
                  await serviceLocator<ReelsCubit>()
                      .likeReel(widget.reel.id)
                      .then((val) async {
                    if (val == "Reel liked successfully") {
                      setState(() {
                        widget.reel.likeCount++;
                      });
                    } else if (val == "Reel unlike successfully") {
                      if (widget.reel.likeCount > 0) {
                        setState(() {
                          widget.reel.likeCount--;
                        });
                      }
                    }
                    if (val == "Reel unlike successfully") {
                      await serviceLocator<ReelsCubit>()
                          .likeReel(widget.reel.id)
                          .then((value) {
                        if (value == "Reel liked successfully") {
                          setState(() {
                            widget.reel.likeCount++;
                          });
                        } else if (value == "Reel unlike successfully") {
                          if (widget.reel.likeCount > 0) {
                            setState(() {
                              widget.reel.likeCount--;
                            });
                          }
                        }
                      });
                    }
                  });
                },
                iconSize: 200,
                animationDuration: const Duration(seconds: 1),
                heartIcon: Icons.favorite,
                iconColor: Colors.pink,
                child: Container(
                  height: double.infinity,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Chewie(
                        key: PageStorageKey(widget.reel.videoMedia),
                        controller: ChewieController(
                          videoPlayerController: _videoPlayerController,
                          autoInitialize: true,
                          looping: true,
                          showOptions: false,
                          allowFullScreen: false,
                          showControls: false,
                          aspectRatio: 2 / 4,
                          errorBuilder: (context, errorMessage) {
                            return Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        left: 10,
                        right: 10,
                        child: CustomProgressBar(
                          videoPlayerController: _videoPlayerController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds the play/pause icon with an animation.
  Widget buildPlayPauseIcon() {
    return AnimatedOpacity(
      opacity: _showPlayPauseIcon ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  /// Builds the overlay that contains additional UI elements like reel info.
  Widget buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.itemType != ReelItemType.instagram)
          Expanded(
            child: GestureDetector(
              onTap: _togglePlayPause,
              behavior: HitTestBehavior.opaque,
            ),
          ),
        ReelActions(
          reel: widget.reel,
          itemType: widget.itemType,
          rotationController: _rotationController,
        ),
      ],
    );
  }

  void _onVideoProgress() {
    if (_videoPlayerController.value.isInitialized) {
      final position = _videoPlayerController.value.position;
      final duration = _videoPlayerController.value.duration;

      // Check if the video has reached 60% of its duration
      if (position.inSeconds > 0.6 * duration.inSeconds) {
        // Dispatch the createReelView event once
        serviceLocator<ReelsCubit>()
            .createReelView(widget.reel.id, duration.inSeconds);

        // Remove the listener after the event is dispatched to prevent repeated calls
        _videoPlayerController.removeListener(_onVideoProgress);
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_onVideoProgress);
    _videoPlayerController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        buildVideoContent(),
        if (_showPlayPauseIcon) buildPlayPauseIcon(),
        buildOverlay(),
        if (!_isInitialized)
          const Center(
            child: CupertinoActivityIndicator(
              radius: 25,
              color: Colors.blue,
            ),
          ),
      ],
    );
  }
}
