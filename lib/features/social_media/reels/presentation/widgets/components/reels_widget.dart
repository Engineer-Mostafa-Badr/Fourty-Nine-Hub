import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../data/models/new_reels_model.dart';
import 'animated_heart_wiidget.dart';
import 'custom_progress_bar.dart';
import 'unified_widget_view.dart';
import '../full_screen_widget.dart';
import '../../../../tinder/data/shared/shared.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/explore_reels_cubit/reel_cubit.dart';
import '../../pages/profile_buttom_sheet.dart';
import '../../pages/reel_actions.dart';
import '../../../../../../helpers/manage_vibration.dart';

class ReelsWidget extends StatefulWidget {
  const ReelsWidget({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.index,
    required this.receiverId,
  });

  final bool isLoading;
  final VideoPlayerController controller;
  final int index;
  final int receiverId;
  @override
  State<ReelsWidget> createState() => _ReelsWidgetState();
}

class _ReelsWidgetState extends State<ReelsWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final bool _isVisible = false; // Track visibility state
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;
  late final AnimationController _rotationController;

  @override
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
  void _handleVerticalDrag(DragEndDetails details, Reel reel) async {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      _pauseVideo();
      await ProfileBottomSheet.show(context, reel);
      _playVideo();
    }
  }

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
          heartIcon: Icons.favorite_outline,
          iconColor: Colors.pink,
          onDoubleTap: () async {
            log("LSdkjflskdjflskdjflsdf o");
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
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.keyboard_double_arrow_left_sharp,
                          //   color: Colors.white,
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     if (!serviceLocator<UserCubit>().isLoggedIn) {
                      //       context.read<PreloadBloc>().pauseTheVideo();
                      //       context.push(Routes.LOGIN);
                      //     } else {
                      //       _showGiftBottomSheet(context);
                      //     }
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(boxShadow: [
                      //       BoxShadow(
                      //           color: Colors.black.withOpacity(0.9),
                      //           blurRadius: 30)
                      //     ]),
                      //     child: SvgPicture.asset(Assets.giftReelsIcon),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
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
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (reel.audio.audioName.isNotEmpty)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  reel.audio.audioName.isNotEmpty
                                      ? reel.audio.audioName
                                      : "No audio",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 5),
                        CustomProgressBar(
                          videoPlayerController: widget.controller,
                        ),
                      ],
                    ),
                  )),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.5,
                left: MediaQuery.of(context).size.width * 0.115,
                child: FullScreenWidget(),
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
      duration: const Duration(milliseconds: 1000),
      child: Center(
        child: Icon(
          widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white.withOpacity(0.5),
          size: 85,
        ),
      ),
    );
  }

  Future<void> _showGiftBottomSheet(BuildContext context) async {
    await showGiftBottomSheet(context, receiverId: "widget.receiverId");
  }
}