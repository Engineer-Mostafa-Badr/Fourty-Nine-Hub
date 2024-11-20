import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_actions.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/animated_heart_wiidget.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/custom_progress_bar.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/components/unified_widget_view.dart';
import 'package:video_player/video_player.dart';

class BuildItemReelDetails extends StatefulWidget {
  const BuildItemReelDetails({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.index,
  });

  final bool isLoading;
  final VideoPlayerController controller;
  final int index;

  @override
  State<BuildItemReelDetails> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<BuildItemReelDetails>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;
  late final AnimationController _rotationController;

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Start observing lifecycle changes
    widget.controller.setLooping(true);
    _playVideo();

    _initializeRotationController();
  }

  void _initializeRotationController() {
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _rotationController.dispose();
    super.dispose();
  }

  void _pauseVideo() {
    if (_isPlaying) {
      widget.controller.pause();

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

  void _playVideo() {
    if (!_isPlaying) {
      widget.controller.play();
      // _chewieController?.play();
      setState(() {
        _isPlaying = true;
        _showPlayPauseIcon = true;
      });
      _hidePlayPauseIconAfterDelay();
    }
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

  // /// Handles vertical drag events for the spotlight item type.
  // void _handleVerticalDrag(DragEndDetails details, Reel reel) async {
  //   if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
  //     _pauseVideo();
  //     await ProfileBottomSheet.show(context, reel);
  //     _playVideo();
  //   }
  // }

  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final reel = context.read<ReelsCubit>().state.globalReels[widget.index];
    final reelCubit = context.read<ReelsCubit>();
    return SizedBox(
      height: context.screenHeight,
      child: GestureDetector(
        onTap: _togglePlayPause,
        // onVerticalDragEnd: (details) => _handleVerticalDrag(details, reel),
        child: DoubleTapHeart(
          iconSize: 40,
          animationDuration: const Duration(seconds: 1),
          heartIcon: Icons.favorite,
          iconColor: Colors.pink,
          onDoubleTap: () async {
            await reelCubit.likeReel(reel.id).then((val) async {
              if (val == "Reel liked successfully") {
                setState(() {
                  reel.likeCount++;
                });
              } else if (val == "Reel unlike successfully") {
                if (reel.likeCount > 0) {
                  setState(() {
                    reel.likeCount--;
                  });
                }
              }
              if (val == "Reel unlike successfully") {
                await reelCubit.likeReel(reel.id).then((value) {
                  if (value == "Reel liked successfully") {
                    setState(() {
                      reel.likeCount++;
                    });
                  } else if (value == "Reel unlike successfully") {
                    if (reel.likeCount > 0) {
                      setState(() {
                        reel.likeCount--;
                      });
                    }
                  }
                });
              }
            });
          },
          child: Stack(
            children: [
              VideoPlayer(widget.controller),
              buildPlayPauseIcon(),
              Positioned(
                right: 0,
                bottom: 20,
                child: ReelActions(
                  reel: reel,
                  itemType: ReelItemType.main,
                  rotationController: _rotationController,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: CustomProgressBar(
                  videoPlayerController: widget.controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}
