import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../ads_feature/create_company_ad/presentation/pages/widgets/reel_post_content.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
import '../widgets/comments.dart';
import 'audio_screen.dart';
import 'profile_buttom_sheet.dart';

/// A unified reel item widget that can function as MainReelItem, ReelItemForInstagram, or SpotlightReelItem.
class UnifiedReelItem extends StatefulWidget {
  final Reel reel;
  final bool isVisible;
  final ReelItemType itemType;

  const UnifiedReelItem({
    super.key,
    required this.reel,
    required this.isVisible,
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

  // ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = true;

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
    } else if (state == AppLifecycleState.resumed && widget.isVisible) {
      _playVideo();
    }
  }

  /// Initializes the video player and Chewie controller.
  // Future<void> _initializePlayer() async {
  //   _videoPlayerController =
  //       VideoPlayerController.network(widget.reel.videoMedia);
  //   try {
  //     await _videoPlayerController.initialize();
  //     _setupChewieController();
  //     if (mounted) {
  //       setState(() {
  //         _isInitialized = true;
  //         _isPlaying = widget.isVisible;
  //       });
  //     }
  //     if (widget.isVisible) {
  //       _playVideo();
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       setState(() {
  //         _isInitialized = false;
  //       });
  //       _showError('Failed to load video');
  //     }
  //   }
  // }

  Future<void> _initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
    try {
      await _videoPlayerController
          .initialize()
          .then((value) => _videoPlayerController.play());
      // _setupChewieController();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = widget.isVisible;
          _playVideo();
        });
      }

      if (widget.isVisible) {
        _playVideo();
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

  /// Sets up the Chewie controller after the video player is initialized.
  // void _setupChewieController() {
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController,
  //     autoPlay: true,
  //     looping: true,
  //     showControls: true,
  //     hideControlsTimer: const Duration(milliseconds: 500),
  //     aspectRatio: _videoPlayerController.value.aspectRatio,
  //   );
  // }

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
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIcon = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
// _playVideo();
    return GestureDetector(
      onTap: _togglePlayPause,
      onVerticalDragEnd: widget.itemType == ReelItemType.spotlight
          ? _handleVerticalDrag
          : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoContent(),
          if (_showPlayPauseIcon) _buildPlayPauseIcon(),
          _buildOverlay(),
          if (!_isInitialized)
            const Center(
              child: CupertinoActivityIndicator(radius: 25),
            ),
          if (widget.itemType == ReelItemType.main)
            Positioned(
              top: 4,
              child: _buildAppBar(context),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button Row
          Row(
            children: [
              _buildGradientIconButton(
                iconData: Icons.arrow_back,
                onPressed: () => context.pop(),
              ),
              const Spacer(),
            ],
          ),
          const Sizer(),
          // Buttons Row
          FittedBox(
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Live Button
                _buildGradientSvgButton(
                  assetName: 'assets/images/live_icon.svg',
                  onPressed: () {
                    _pauseVideo();
                    context.push(Routes.LIVE);
                  },
                ),
                const Sizer(),
                // Spotlight Button
                _buildGradientTextButton(
                  text: 'Spotlight',
                  onPressed: () {
                    _pauseVideo();

                    context.push(Routes.SPOTLIGHT);
                  },
                ),
                const Sizer(),
                // Snap Button
                _buildGradientTextButton(
                  text: 'Snap',
                  onPressed: () {
                    _pauseVideo();

                    context.push(Routes.SNAP);
                  },
                ),
                const Sizer(),
                // Reels Button
                _buildGradientTextButton(
                  text: 'Reels',
                  onPressed: () async {
                    _pauseVideo();

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReelsRecordingScreen(),
                      ),
                    );
                  },
                ),
                const Sizer(),
                // Search Button
                _buildGradientIconButton(
                  iconData: FontAwesomeIcons.magnifyingGlass,
                  onPressed: () {
                    _pauseVideo();

                    context.push(Routes.Tinder);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper method for gradient icon buttons
  Widget _buildGradientIconButton(
      {required IconData iconData, required VoidCallback onPressed}) {
    return Container(
      height: 70.h,
      decoration: _buttonDecoration(),
      child: IconButton(
        icon: FittedBox(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

// Helper method for gradient SVG buttons
  Widget _buildGradientSvgButton(
      {required String assetName, required VoidCallback onPressed}) {
    return Container(
      height: 70.h,
      decoration: _buttonDecoration(),
      child: IconButton(
        icon: SvgPicture.asset(
          assetName,
          fit: BoxFit.fitHeight,
        ),
        onPressed: onPressed,
      ),
    );
  }

// Helper method for gradient text buttons
  Widget _buildGradientTextButton(
      {required String text, required VoidCallback onPressed}) {
    return Container(
      height: 70.h,
      decoration: _buttonDecoration(),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Styles.mediumText(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

// Button decoration with gradient and rounded corners
  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Colors.white10,
          Colors.black12,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );
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
  Widget _buildVideoContent() {
    // if (_isInitialized && _chewieController != null) {
    if (_isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: VideoPlayer(_videoPlayerController),
        ),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: widget.reel.thumbnailSignedUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CupertinoActivityIndicator(radius: 25),
        ),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error)),
      );
    }
  }

  /// Builds the play/pause icon with an animation.
  Widget _buildPlayPauseIcon() {
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
  Widget _buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.itemType != ReelItemType.instagram)
          Expanded(
            child: GestureDetector(
              onTap: _togglePlayPause,
              behavior: HitTestBehavior.opaque,
            ),
          ),
        _ReelInfo(
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
    WidgetsBinding.instance.removeObserver(this); // Stop observing
    _pauseVideo();
    _videoPlayerController.removeListener(_onVideoProgress);
    // _chewieController?.dispose();
    _videoPlayerController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

/// Widget to display reel information such as user info, actions, and audio.
class _ReelInfo extends StatelessWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const _ReelInfo({
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height,
      width: width,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _UserSection(reel: reel),
                  const SizedBox(height: 8),
                  _AudioAndButtons(reel: reel, width: width),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: _ActionButtons(
              reel: reel,
              itemType: itemType,
              rotationController: rotationController,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget to display user avatar and information.
class _UserSection extends StatelessWidget {
  final Reel reel;

  const _UserSection({required this.reel});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _UserAvatar(reel: reel),
          const SizedBox(width: 12),
          _UserInfo(reel: reel),
        ],
      ),
    );
  }
}

/// Widget to display the user's avatar.
class _UserAvatar extends StatelessWidget {
  final Reel reel;

  const _UserAvatar({required this.reel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: reel.user.story
              ? AppColors.PRIMARY_COLOR_DARK
              : Colors.transparent,
          width: 3,
        ),
      ),
      child: InkWell(
        onTap: () {
          final state =
              context.findAncestorStateOfType<_UnifiedReelItemState>();
          state?._pauseVideo();
          if (!serviceLocator<UserCubit>().isLoggedIn) {
            context.pushReplacement(Routes.LOGIN);
          } else {
            context.push(Routes.OTHERSACCOUNT, extra: reel.user.id);
          }
        },
        child: CircleAvatar(
          radius: reel.user.profilePictureSignedUrl != null
              ? 60.h
              : 20.h, // Adjust based on item type if needed
          backgroundImage: reel.user.profilePictureSignedUrl != null
              ? CachedNetworkImageProvider(reel.user.profilePictureSignedUrl!)
              : null,
          child: reel.user.profilePictureSignedUrl == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

/// Widget to display the user's name and reel details.
class _UserInfo extends StatelessWidget {
  final Reel reel;

  const _UserInfo({required this.reel});

  String get _displayName =>
      capitalizeAndSplit('${reel.user.firstName} ${reel.user.lastName}');

  String get _displayReelName {
    final maxLength = (reel.name.length * 0.75).round();
    return "${reel.name.substring(0, maxLength)}...";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            final state =
                context.findAncestorStateOfType<_UnifiedReelItemState>();
            state?._pauseVideo();
            if (!serviceLocator<UserCubit>().isLoggedIn) {
              context.pushReplacement(Routes.LOGIN);
            } else {
              context.push(Routes.OTHERSACCOUNT, extra: reel.user.id);
            }
          },
          child: Row(
            children: [
              Text(
                _displayName,
                textScaler: TextScaler.noScaling,
                style: _nameTextStyle,
              ),
              if (reel.user.verified)
                const Icon(
                  Icons.verified,
                  color: AppColors.PRIMARY_COLOR_DARK,
                  size: 25,
                ),
            ],
          ),
        ),
        _ReelDetails(name: _displayReelName, viewCount: reel.viewCount),
      ],
    );
  }

  TextStyle get _nameTextStyle => TextStyle(
        fontSize: 50.sp,
        color: Colors.white,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// Widget to display reel name and view count.
class _ReelDetails extends StatelessWidget {
  final String name;
  final int viewCount;

  const _ReelDetails({
    required this.name,
    required this.viewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: _detailsTextStyle,
        ),
        const SizedBox(width: 16),
        FaIcon(
          FontAwesomeIcons.eye,
          size: 20,
          color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          viewCount.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          style: _detailsTextStyle,
        ),
      ],
    );
  }

  TextStyle get _detailsTextStyle => TextStyle(
        fontSize: 30.sp,
        color: Colors.white60,
        decoration: TextDecoration.none,
        shadows: const [
          Shadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// Widget to display audio information and associated buttons.
class _AudioAndButtons extends StatelessWidget {
  final Reel reel;
  final double width;

  const _AudioAndButtons({
    required this.reel,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.withOpacity(0.2),
      child: ScrollingText(text: reel.audio.audioName),
    );
  }
}

/// Widget to display action buttons like like, comment, share, etc.
class _ActionButtons extends StatelessWidget {
  final Reel reel;
  final ReelItemType itemType;
  final AnimationController rotationController;

  const _ActionButtons({
    required this.reel,
    required this.itemType,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    final ReelsCubit reelsCubit = context.read<ReelsCubit>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ActionButton(
            icon: reel.likeCount > 0
                ? FontAwesomeIcons.solidHeart
                : FontAwesomeIcons.heart,
            count: reel.likeCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.pushReplacement(Routes.LOGIN);
              } else {
                _handleLikeAction(context, reelsCubit);
              }
            },
            iconColor: reel.likeCount == 0 ? Colors.white : Colors.red,
          ),
          _ActionButton(
            icon: FontAwesomeIcons.comment,
            count: reel.commentCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.pushReplacement(Routes.LOGIN);
              } else {
                _handleCommentAction(context, reelsCubit);
              }
            },
          ),
          _ActionButton(
            icon: FontAwesomeIcons.paperPlane,
            count: reel.shareCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.pushReplacement(Routes.LOGIN);
              } else {
                _handleShareAction(context, reel.videoMedia);
              }
            },
          ),
          _ActionButton(
            icon: reel.saveCount == 0
                ? FontAwesomeIcons.bookmark
                : FontAwesomeIcons.solidBookmark,
            count: reel.saveCount,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.pushReplacement(Routes.LOGIN);
              } else {
                _handleSaveAction(context, reelsCubit);
              }
            },
            iconColor: reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
          ),
          _ActionButton(
            icon: Icons.card_giftcard,
            count: 0,
            onTap: () {
              final state =
                  context.findAncestorStateOfType<_UnifiedReelItemState>();
              state?._pauseVideo();

              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.pushReplacement(Routes.LOGIN);
              } else {
                _showGiftBottomSheet(context);
              }
            },
          ),
          _ActionButton(
            icon: Icons.report_outlined,
            count: 0,
            onTap: () {
              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.pushReplacement(Routes.LOGIN);
              } else {
                _showReportBottomSheet(context);
              }
            },
          ),
          if (itemType != ReelItemType.instagram)
            RotatingCircularButton(
              reel: reel,
              rotationController: rotationController,
            ),
        ],
      ),
    );
  }

  Future<void> _handleLikeAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.likeReel(reel.id).then((value) {
        final response = cubit.state.likeReelResponse;
        if (response?.message == "Reel liked successfully") {
          (++reel.likeCount);
        } else if (response?.message == "Reel unlike successfully") {
          if (reel.likeCount > 0) --reel.likeCount;
        }
      });

      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error liking reel: $e');
    }
  }

  Future<void> _handleCommentAction(
      BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.getComments(reel.id);
      final state = context.findAncestorStateOfType<_UnifiedReelItemState>();
      state?._pauseVideo();

      await showCommentsBottomSheet(context, reel: reel);
      state?._playVideo();
    } catch (e) {
      _showSnackBar(context, 'Error fetching comments: $e');
    }
  }

  Future<void> _handleShareAction(context, String videoUrl) async {
    final state = context.findAncestorStateOfType<_UnifiedReelItemState>();
    state?._pauseVideo();
    await Share.share(
      videoUrl,
      subject: 'Check out this reel!',
    );
  }

  Future<void> _handleSaveAction(BuildContext context, ReelsCubit cubit) async {
    try {
      await cubit.saveReel(reel.id);
      final response = cubit.state.reelSaveResponse;
      if (response?.message == "saved successfully") {
        (reel.saveCount++);
      } else if (response?.message == "unsaved successfully") {
        (reel.saveCount--);
      }
      // Force rebuild to update UI
      (context as Element).markNeedsBuild();
    } catch (e) {
      _showSnackBar(context, 'Error saving reel: $e');
    }
  }

  Future<void> _showGiftBottomSheet(BuildContext context) async {
    final state = context.findAncestorStateOfType<_UnifiedReelItemState>();
    state?._pauseVideo();
    await showGiftBottomSheet(context, receiverId: reel.user.id);
    state?._playVideo();
  }

  Future<void> _showReportBottomSheet(BuildContext context) async {
    final state = context.findAncestorStateOfType<_UnifiedReelItemState>();
    state?._pauseVideo();
    await bottomSheet(
      context: context,
      widget: ReportView(
        id: reel.user.id,
        categoryId: '66684135dbb427ee42aa0141',
      ),
    );
    state?._playVideo();
  }

  void _toggleVideoPlayback(BuildContext context) {
    final state = context.findAncestorStateOfType<_UnifiedReelItemState>();
    state?._togglePlayPause();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Widget for individual action buttons.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          FaIcon(
            icon,
            color: iconColor ?? Colors.white,
            size: 45.h,
          ),
          SizedBox(height: 4.h),
          Text(
            (count > 0) ? '$count' : '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textScaler: TextScaler.noScaling,
            style: _countTextStyle,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  TextStyle get _countTextStyle => TextStyle(
        height: 1.h,
        fontSize: 30.sp,
        color: Colors.white,
        decoration: TextDecoration.none,
        shadows: const [
          Shadow(
            offset: Offset(0, 1.0),
            color: Colors.black,
          ),
        ],
      );
}

/// A rotating circular button widget for audio interaction
class RotatingCircularButton extends StatelessWidget {
  final Reel reel;
  final AnimationController rotationController;

  const RotatingCircularButton({
    super.key,
    required this.reel,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: RotationTransition(
        turns: rotationController,
        child: Container(
          width: 55.h,
          height: 55.h,
          decoration: BoxDecoration(
            color: reel.audio.audioPicture.isEmpty
                ? Colors.black
                : Colors.transparent,
            image: reel.audio.audioPicture.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(reel.audio.audioPicture),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  )
                : null,
          ),
          child: InkWell(
            onTap: () {
              final state =
                  context.findAncestorStateOfType<_UnifiedReelItemState>();
              state?._pauseVideo();

              if (!serviceLocator<UserCubit>().isLoggedIn) {
                context.pushReplacement(Routes.LOGIN);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: serviceLocator<ReelsCubit>()
                        ..fetchReelsWithSameAudio(reel.audio.id),
                      child: InstagramAudioScreen(
                        audio: reel.audio,
                        reel: reel,
                      ),
                    ),
                  ),
                );
              }
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Icon(
                    FontAwesomeIcons.music,
                    size: 30.w,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 1.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

