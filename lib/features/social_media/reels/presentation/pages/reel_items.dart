import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/app_colors.dart';
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

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

/// A unified reel item widget that can function as MainReelItem, ReelItemForInstagram, or SpotlightReelItem.
class UnifiedReelItem extends StatefulWidget {
  final Reel reel;
  final bool isVisible;
  final ReelItemType itemType;

  const UnifiedReelItem({
    Key? key,
    required this.reel,
    required this.isVisible,
    this.itemType = ReelItemType.main,
  }) : super(key: key);

  @override
  State<UnifiedReelItem> createState() => _UnifiedReelItemState();
}

enum ReelItemType { main, instagram, spotlight }

class _UnifiedReelItemState extends State<UnifiedReelItem>
    with
        AutomaticKeepAliveClientMixin<UnifiedReelItem>,
        SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;

  late final AnimationController _rotationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
        VideoPlayerController.network(widget.reel.videoMedia);
    try {
      await _videoPlayerController.initialize();
      _setupChewieController();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = widget.isVisible;
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
  void _setupChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
    );
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
      _chewieController?.play();
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
      _chewieController?.pause();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        ],
      ),
    );
  }

  /// Handles vertical drag events for the spotlight item type.
  void _handleVerticalDrag(DragEndDetails details) async {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      _togglePlayPause();
      await ProfileBottomSheet.show(context, widget.reel);
      _togglePlayPause();
    }
  }

  /// Builds the video content or displays a placeholder if not initialized.
  Widget _buildVideoContent() {
    if (_isInitialized && _chewieController != null) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoPlayerController.value.size.width,
          height: _videoPlayerController.value.size.height,
          child: Chewie(controller: _chewieController!),
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
    _videoPlayerController.removeListener(_onVideoProgress);
    _chewieController?.dispose();
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
    Key? key,
    required this.reel,
    required this.itemType,
    required this.rotationController,
  }) : super(key: key);

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

  const _UserSection({Key? key, required this.reel}) : super(key: key);

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

  const _UserAvatar({Key? key, required this.reel}) : super(key: key);

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
        onTap: () => context.push(Routes.OTHERSACCOUNT, extra: reel.user.id),
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

  const _UserInfo({Key? key, required this.reel}) : super(key: key);

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
          onTap: () => context.push(Routes.OTHERSACCOUNT, extra: reel.user.id),
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
    Key? key,
    required this.name,
    required this.viewCount,
  }) : super(key: key);

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
    Key? key,
    required this.reel,
    required this.width,
  }) : super(key: key);

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
    Key? key,
    required this.reel,
    required this.itemType,
    required this.rotationController,
  }) : super(key: key);

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
            onTap: () => _handleLikeAction(context, reelsCubit),
            iconColor: reel.likeCount == 0 ? Colors.white : Colors.red,
          ),
          _ActionButton(
            icon: FontAwesomeIcons.comment,
            count: reel.commentCount,
            onTap: () => _handleCommentAction(context, reelsCubit),
          ),
          _ActionButton(
            icon: FontAwesomeIcons.paperPlane,
            count: reel.shareCount,
            onTap: () => _handleShareAction(reel.videoMedia),
          ),
          _ActionButton(
            icon: reel.saveCount == 0
                ? FontAwesomeIcons.bookmark
                : FontAwesomeIcons.solidBookmark,
            count: reel.saveCount,
            onTap: () => _handleSaveAction(context, reelsCubit),
            iconColor: reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
          ),
          _ActionButton(
            icon: Icons.card_giftcard,
            count: 0,
            onTap: () => _showGiftBottomSheet(context),
          ),
          _ActionButton(
            icon: Icons.report_outlined,
            count: 0,
            onTap: () => _showReportBottomSheet(context),
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
      _toggleVideoPlayback(context);
      await showCommentsBottomSheet(context, reel: reel);
      _toggleVideoPlayback(context);
    } catch (e) {
      _showSnackBar(context, 'Error fetching comments: $e');
    }
  }

  void _handleShareAction(String videoUrl) {
    Share.share(
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

  void _showGiftBottomSheet(BuildContext context) {
    showGiftBottomSheet(context, receiverId: reel.user.id);
  }

  void _showReportBottomSheet(BuildContext context) {
    bottomSheet(
      context: context,
      widget: ReportView(
        id: reel.user.id,
        categoryId: '66684135dbb427ee42aa0141',
      ),
    );
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
    Key? key,
    required this.icon,
    required this.count,
    required this.onTap,
    this.iconColor,
  }) : super(key: key);

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
    Key? key,
    required this.reel,
    required this.rotationController,
  }) : super(key: key);

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

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chewie/chewie.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
// import 'package:go_router/go_router.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../routes/routes.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../../ads_feature/create_company_ad/presentation/pages/widgets/reel_post_content.dart';
// import '../../../tinder/data/shared/shared.dart';
// import '../../../twitter/presentation/widgets/report_view.dart';
// import '../../data/models/new_reels_model.dart';
// import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import '../widgets/comments.dart';
// import 'audio_screen.dart';
// import 'profile_buttom_sheet.dart';
//
// /// A unified reel item widget that can function as MainReelItem, ReelItemForInstagram, or SpotlightReelItem
// class UnifiedReelItem extends StatefulWidget {
//   final Reel reel;
//   final bool isVisible;
//   final ReelItemType itemType;
//
//   const UnifiedReelItem({
//     Key? key,
//     required this.reel,
//     required this.isVisible,
//     this.itemType = ReelItemType.main,
//   }) : super(key: key);
//
//   @override
//   _UnifiedReelItemState createState() => _UnifiedReelItemState();
// }
//
// enum ReelItemType { main, instagram, spotlight }
//
// class _UnifiedReelItemState extends State<UnifiedReelItem>
//     with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
//   late final VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isInitialized = false;
//   bool _isPlaying = false;
//   bool _showPlayPauseIcon = false;
//
//   late AnimationController _rotationController;
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//     _initializeRotationController();
//   }
//
//   void _initializeRotationController() {
//     _rotationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat();
//   }
//
//   @override
//   void didUpdateWidget(UnifiedReelItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isVisible != oldWidget.isVisible) {
//       widget.isVisible ? _playVideo() : _pauseVideo();
//     }
//   }
//
//   Future<void> _initializePlayer() async {
//     if (!await _checkConnectivity()) return;
//
//     await _initializeVideoController();
//     _setupChewieController();
//     _setInitialVideoState();
//   }
//
//   Future<void> _initializeVideoController() async {
//     _videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
//     try {
//       await _videoPlayerController.initialize();
//     } catch (error) {
//       if (mounted) {
//         _handleVideoError('Failed to load video');
//       }
//     }
//   }
//
//   void _setupChewieController() {
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: widget.isVisible,
//       looping: true,
//       showControls: false,
//       aspectRatio: _videoPlayerController.value.aspectRatio,
//     );
//   }
//
//   void _setInitialVideoState() {
//     if (mounted) {
//       setState(() {
//         _isInitialized = true;
//         _isPlaying = widget.isVisible;
//       });
//     }
//   }
//
//   Future<bool> _checkConnectivity() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       if (mounted) {
//         _handleVideoError('No internet connection');
//       }
//       return false;
//     }
//     return true;
//   }
//
//   void _handleVideoError(String message) {
//     if (mounted) {
//       setState(() {
//         _isInitialized = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }
//
//   void _playVideo() {
//     if (_isInitialized && !_isPlaying) {
//       _chewieController?.play();
//       if (mounted) {
//         setState(() {
//           _isPlaying = true;
//           _showPlayPauseIcon = true;
//         });
//       }
//       _hidePlayPauseIconAfterDelay();
//     }
//   }
//
//   void _pauseVideo() {
//     if (_isInitialized && _isPlaying) {
//       _chewieController?.pause();
//       if (mounted) {
//         setState(() {
//           _isPlaying = false;
//           _showPlayPauseIcon = true;
//         });
//       }
//     }
//   }
//
//   void _togglePlayPause() {
//     if (_isPlaying) {
//       _pauseVideo();
//     } else {
//       _playVideo();
//     }
//   }
//
//   void _hidePlayPauseIconAfterDelay() {
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) {
//         setState(() {
//           _showPlayPauseIcon = false;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//
//     Widget content = GestureDetector(
//       onTap: _togglePlayPause,
//       onVerticalDragEnd: widget.itemType == ReelItemType.spotlight
//           ? (details) async {
//               if (details.primaryVelocity! < 0) {
//                 _togglePlayPause();
//                 await ProfileBottomSheet.show(context, widget.reel);
//                 _togglePlayPause();
//               }
//             }
//           : null,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           _buildVideoOrPlaceholder(),
//           _buildPlayPauseIcon(),
//           _buildOverlay(),
//           if (!_isInitialized)
//             const Center(
//               child: CupertinoActivityIndicator(radius: 25),
//             ),
//         ],
//       ),
//     );
//
//     if (widget.itemType == ReelItemType.instagram) {
//       content = GestureDetector(
//         onTap: _togglePlayPause,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             _buildVideoOrPlaceholder(),
//             _buildPlayPauseIcon(),
//             _buildOverlay(),
//             if (!_isInitialized)
//               const Center(
//                 child: CupertinoActivityIndicator(radius: 25),
//               ),
//           ],
//         ),
//       );
//     }
//
//     return content;
//   }
//
//   Widget _buildVideoOrPlaceholder() {
//     if (_isInitialized && _chewieController != null) {
//       return FittedBox(
//         fit: BoxFit.cover,
//         child: SizedBox(
//           width: _videoPlayerController.value.size.width,
//           height: _videoPlayerController.value.size.height,
//           child: Chewie(controller: _chewieController!),
//         ),
//       );
//     } else {
//       return CachedNetworkImage(
//         imageUrl: widget.reel.thumbnailSignedUrl,
//         fit: BoxFit.cover,
//         placeholder: (context, url) => const Center(
//           child: CupertinoActivityIndicator(radius: 25),
//         ),
//         errorWidget: (context, url, error) =>
//             const Center(child: Icon(Icons.error)),
//       );
//     }
//   }
//
//   Widget _buildPlayPauseIcon() {
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: Center(
//         child: AnimatedOpacity(
//           opacity: _showPlayPauseIcon ? 1.0 : 0.0,
//           duration: const Duration(milliseconds: 300),
//           child: Icon(
//             _isPlaying ? Icons.pause : Icons.play_arrow,
//             color: Colors.white,
//             size: 100,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOverlay() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.itemType != ReelItemType.instagram)
//           Expanded(
//             child: GestureDetector(
//               onTap: _togglePlayPause,
//             ),
//           ),
//         _buildReelInfo(),
//       ],
//     );
//   }
//
//   Widget _buildReelInfo() {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return SizedBox(
//       height: height,
//       width: width,
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           children: [
//             Expanded(
//               flex: widget.itemType == ReelItemType.instagram ? 4 : 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildUserSection(),
//                     const SizedBox(height: 8),
//                     _buildAudioAndButtons(width),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: _buildActionButtons(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserSection() {
//     return FittedBox(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _buildUserAvatar(),
//           const SizedBox(width: 12),
//           _buildUserInfo(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUserAvatar() {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: widget.reel.user.story
//               ? AppColors.PRIMARY_COLOR_DARK
//               : Colors.transparent,
//           width: 3,
//         ),
//       ),
//       child: InkWell(
//         onTap: () {
//           context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
//         },
//         child: CircleAvatar(
//           radius: widget.itemType == ReelItemType.instagram ? 20 : 60.h,
//           backgroundImage: CachedNetworkImageProvider(
//             widget.reel.user.profilePictureSignedUrl!,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InkWell(
//           onTap: () {
//             context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
//           },
//           child: _buildUserName(),
//         ),
//         _buildReelNameAndViews(),
//       ],
//     );
//   }
//
//   Widget _buildUserName() {
//     return Row(
//       children: [
//         Text(
//           capitalizeAndSplit(
//               '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
//           textScaler: TextScaler.noScaling,
//           style: TextStyle(
//             fontSize: widget.itemType == ReelItemType.instagram ? 50.sp : 50.sp,
//             color: Colors.white,
//             decoration: TextDecoration.none,
//             fontWeight: FontWeight.bold,
//             shadows: const [
//               Shadow(
//                 offset: Offset(1.0, 1.0),
//                 color: Colors.black,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 4),
//         if (widget.reel.user.verified)
//           const Icon(
//             Icons.verified,
//             color: AppColors.PRIMARY_COLOR_DARK,
//             size: 25,
//           ),
//       ],
//     );
//   }
//
//   Widget _buildReelNameAndViews() {
//     return Row(
//       children: [
//         Text(
//           "${widget.reel.name.substring(0, (widget.reel.name.length * 0.75).round())}...",
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           textScaler: TextScaler.noScaling,
//           style: TextStyle(
//             fontSize: widget.itemType == ReelItemType.instagram ? 30.sp : 30.sp,
//             color: Colors.white60,
//             decoration: TextDecoration.none,
//             shadows: const [
//               Shadow(
//                 offset: Offset(1.0, 1.0),
//                 color: Colors.black,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 16),
//         FaIcon(
//           FontAwesomeIcons.eye,
//           size: widget.itemType == ReelItemType.instagram ? 20 : 20,
//           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           widget.reel.viewCount.toString(),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           textScaler: TextScaler.noScaling,
//           style: TextStyle(
//             fontSize: widget.itemType == ReelItemType.instagram ? 30.sp : 30.sp,
//             color: Colors.white60,
//             decoration: TextDecoration.none,
//             shadows: const [
//               Shadow(
//                 offset: Offset(1.0, 1.0),
//                 color: Colors.black,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAudioAndButtons(double width) {
//     return Container(
//         color: Colors.blueGrey.withOpacity(0.2),
//         child: ScrollingText(text: widget.reel.audio.audioName));
//   }
//
//   Widget _buildActionButtons() {
//     final reelsCubit = context.read<ReelsCubit>();
//
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         _buildActionButton(
//           widget.reel.likeCount == 0
//               ? FontAwesomeIcons.heart
//               : FontAwesomeIcons.solidHeart,
//           widget.reel.likeCount,
//           () async {
//             await _handleLikeAction(reelsCubit);
//           },
//           iconColor: widget.reel.likeCount == 0 ? Colors.white : Colors.red,
//         ),
//         _buildActionButton(
//           FontAwesomeIcons.comment,
//           widget.reel.commentCount,
//           () async {
//             await _handleCommentAction(reelsCubit);
//           },
//         ),
//         _buildActionButton(
//           FontAwesomeIcons.paperPlane,
//           widget.reel.shareCount,
//           () async {
//             _handleShareAction(widget.reel.videoMedia);
//           },
//         ),
//         _buildActionButton(
//           widget.reel.saveCount == 0
//               ? FontAwesomeIcons.bookmark
//               : FontAwesomeIcons.solidBookmark,
//           widget.reel.saveCount,
//           () async {
//             await _handleSaveAction(reelsCubit);
//           },
//           iconColor:
//               widget.reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
//         ),
//         _buildActionButton(
//           Icons.card_giftcard,
//           0,
//           () {
//             showGiftBottomSheet(context, receiverId: widget.reel.user.id);
//           },
//         ),
//         _buildActionButton(
//           Icons.report_outlined,
//           0,
//           () {
//             bottomSheet(
//               context: context,
//               widget: ReportView(
//                 id: widget.reel.user.id,
//                 categoryId: '66684135dbb427ee42aa0141',
//               ),
//             );
//           },
//         ),
//         if (widget.itemType != ReelItemType.instagram)
//           RotatingCircularButton(
//             reel: widget.reel,
//             rotationController: _rotationController,
//           ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton(IconData icon, int count, VoidCallback function,
//       {Color? iconColor}) {
//     double iconSize = 45.h;
//     double textSize = 30.sp;
//
//     return InkWell(
//       onTap: function,
//       child: Column(
//         children: [
//           FaIcon(
//             icon,
//             color: iconColor ?? Colors.white,
//             size: iconSize,
//           ),
//           Text(
//             count > 0 ? '$count' : "",
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             textScaler: TextScaler.noScaling,
//             style: TextStyle(
//               height: 1.h,
//               fontSize: textSize,
//               color: Colors.white,
//               decoration: TextDecoration.none,
//               shadows: const [
//                 Shadow(
//                   offset: Offset(0, 1.0),
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 16.h,
//           )
//            // Divider(height: 16.h,thickness: 0,color: Colors.transparent,)
//         ],
//       ),
//     );
//   }
//
//   Future<void> _handleLikeAction(ReelsCubit reelsCubit) async {
//     try {
//       await reelsCubit.likeReel(widget.reel.id);
//       final response = reelsCubit.state.likeReelResponse;
//       if (response?.message == "Reel liked successfully") {
//         setState(() => widget.reel.likeCount++);
//       } else if (response?.message == "Reel unlike successfully") {
//         setState(() {
//           if (widget.reel.likeCount > 0) widget.reel.likeCount--;
//         });
//       }
//     } catch (e) {
//       // Handle error (e.g., show a snackbar)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error liking reel: $e')),
//       );
//     }
//   }
//
//   Future<void> _handleCommentAction(ReelsCubit reelsCubit) async {
//     try {
//       await reelsCubit.getComments(widget.reel.id);
//       _togglePlayPause();
//
//       await showCommentsBottomSheet(context, reel: widget.reel);
//       _togglePlayPause();
//     } catch (e) {
//       // Handle error (e.g., show a snackbar)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching comments: $e')),
//       );
//     }
//   }
//
//   void _handleShareAction(String videoUrl) {
//     Share.share(
//       videoUrl,
//       subject: 'Check out this reel!',
//     );
//   }
//
//   Future<void> _handleSaveAction(ReelsCubit reelsCubit) async {
//     try {
//       await reelsCubit.saveReel(widget.reel.id);
//       final response = reelsCubit.state.reelSaveResponse;
//       if (response!.message == "saved successfully") {
//         setState(() => widget.reel.saveCount++);
//       } else if (response.message == "unsaved successfully") {
//         setState(() => widget.reel.saveCount--);
//       }
//     } catch (e) {
//       // Handle error (e.g., show a snackbar)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving reel: $e')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _pauseVideo();
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     _rotationController.dispose();
//     super.dispose();
//   }
// }
//
// /// A rotating circular button widget for audio interaction
// class RotatingCircularButton extends StatelessWidget {
//   final Reel reel;
//   final AnimationController rotationController;
//
//   const RotatingCircularButton({
//     Key? key,
//     required this.reel,
//     required this.rotationController,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipOval(
//       child: RotationTransition(
//         turns: rotationController,
//         child: Container(
//           width: 55.h,
//           height: 55.h,
//           decoration: BoxDecoration(
//             color: reel.audio.audioPicture.isEmpty
//                 ? Colors.black
//                 : Colors.transparent,
//             image: DecorationImage(
//               image: NetworkImage(
//                 reel.audio.audioPicture,
//               ),
//               fit: BoxFit.cover,
//               onError: (exception, stackTrace) => Container(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           child: InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => BlocProvider.value(
//                     value: serviceLocator<ReelsCubit>()
//                       ..fetchReelsWithSameAudio(reel.audio.id),
//                     child: InstagramAudioScreen(
//                       audio: reel.audio,
//                       reel: reel,
//                     ),
//                   ),
//                 ),
//               );
//             },
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Icon(
//                     FontAwesomeIcons.music,
//                     size: 30.w,
//                     shadows: const [
//                       Shadow(
//                         offset: Offset(1.0, 1.0),
//                         blurRadius: 1.0,
//                         color: Colors.black,
//                       ),
//                     ],
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:chewie/chewie.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:fourtyninehub/core/extensions/context_extension.dart';
// // import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
// // import 'package:fourtyninehub/features/social_media/reels/presentation/pages/profile_buttom_sheet.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:video_player/video_player.dart';
// //
// // import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
// // import '../../../../../common/widgets/dynamic/sizer.dart';
// // import '../../../../../res/style/app_colors.dart';
// // import '../../../../../routes/routes.dart';
// // import '../../../../../service_locator/service_locator.dart';
// // import '../../../../ads_feature/create_company_ad/presentation/pages/widgets/reel_post_content.dart';
// // import '../../../tinder/data/shared/shared.dart';
// // import '../../../twitter/presentation/widgets/report_view.dart';
// // import '../../data/models/new_reels_model.dart';
// // import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
// // import '../widgets/comments.dart';
// // import 'audio_screen.dart';
// //
// // class MainReelItem extends StatefulWidget {
// //   final Reel reel;
// //   final bool isVisible;
// //   final bool fromSpotlight;
// //
// //   const MainReelItem(
// //       {super.key,
// //       required this.reel,
// //       required this.isVisible,
// //       required this.fromSpotlight});
// //
// //   @override
// //   MainReelItemState createState() => MainReelItemState();
// // }
// //
// // class MainReelItemState extends State<MainReelItem>
// //     with AutomaticKeepAliveClientMixin {
// //   late final VideoPlayerController _videoPlayerController;
// //   ChewieController? _chewieController;
// //   bool _isInitialized = false;
// //   bool _isPlaying = false;
// //   bool _showPlayPauseIcon = false;
// //
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }
// //
// //   @override
// //   void didUpdateWidget(MainReelItem oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.isVisible != oldWidget.isVisible) {
// //       widget.isVisible ? _playVideo() : _pauseVideo();
// //     }
// //   }
// //
// //   Future<void> _initializePlayer() async {
// //     if (!await _checkConnectivity()) return;
// //
// //     await _initializeVideoController();
// //     _setupChewieController();
// //     _setInitialVideoState();
// //   }
// //
// //   Future<void> _initializeVideoController() async {
// //     _videoPlayerController =
// //         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
// //     try {
// //       await _videoPlayerController.initialize();
// //     } catch (error) {
// //       if (mounted) {
// //         _handleVideoError('Failed to load video');
// //       }
// //     }
// //   }
// //
// //   void _setupChewieController() {
// //     _chewieController = ChewieController(
// //       videoPlayerController: _videoPlayerController,
// //       autoPlay: widget.isVisible,
// //       looping: true,
// //       showControls: false,
// //       aspectRatio: _videoPlayerController.value.aspectRatio,
// //     );
// //   }
// //
// //   void _setInitialVideoState() {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = true;
// //         _isPlaying = widget.isVisible;
// //       });
// //     }
// //   }
// //
// //   Future<bool> _checkConnectivity() async {
// //     final connectivityResult = await Connectivity().checkConnectivity();
// //     if (connectivityResult == ConnectivityResult.none) {
// //       if (mounted) {
// //         _handleVideoError('No internet connection');
// //       }
// //       return false;
// //     }
// //     return true;
// //   }
// //
// //   void _handleVideoError(String message) {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(message)),
// //       );
// //     }
// //   }
// //
// //   void _playVideo() {
// //     if (_isInitialized && !_isPlaying) {
// //       _chewieController?.play();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = true;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //       _hidePlayPauseIconAfterDelay();
// //     }
// //   }
// //
// //   void _pauseVideo() {
// //     if (_isInitialized && _isPlaying) {
// //       _chewieController?.pause();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = false;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //     }
// //   }
// //
// //   void _togglePlayPause() {
// //     if (_isPlaying) {
// //       _pauseVideo();
// //     } else {
// //       _playVideo();
// //     }
// //   }
// //
// //   void _hidePlayPauseIconAfterDelay() {
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (mounted) {
// //         setState(() {
// //           _showPlayPauseIcon = false;
// //         });
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     if (widget.fromSpotlight) {
// //       return GestureDetector(
// //         onTap: _togglePlayPause,
// //         onVerticalDragEnd: (details) async {
// //           // Check if the swipe was upwards (primaryVelocity < 0)
// //           if (details.primaryVelocity! < 0) {
// //             // Show the bottom sheet for any upward swipe
// //             _togglePlayPause();
// //             await ProfileBottomSheet.show(context, widget.reel);
// //             _togglePlayPause();
// //           }
// //         },
// //         child: Stack(
// //           fit: StackFit.expand,
// //           children: [
// //             _buildVideoOrPlaceholder(),
// //             _buildPlayPauseIcon(),
// //             _buildOverlay(),
// //             if (!_isInitialized)
// //               const Center(
// //                 child: CupertinoActivityIndicator(radius: 25),
// //               ),
// //           ],
// //         ),
// //       );
// //     } else {
// //       return GestureDetector(
// //         onTap: _togglePlayPause,
// //         child: Stack(
// //           fit: StackFit.expand,
// //           children: [
// //             _buildVideoOrPlaceholder(),
// //             _buildPlayPauseIcon(),
// //             _buildOverlay(),
// //             if (!_isInitialized)
// //               const Center(
// //                 child: CupertinoActivityIndicator(radius: 25),
// //               ),
// //           ],
// //         ),
// //       );
// //     }
// //   }
// //
// //   Widget _buildVideoOrPlaceholder() {
// //     if (_isInitialized && _chewieController != null) {
// //       return FittedBox(
// //         fit: BoxFit.fitHeight,
// //         child: SizedBox(
// //           width: _videoPlayerController.value.size.width,
// //           height: _videoPlayerController.value.size.height,
// //           child: Chewie(controller: _chewieController!),
// //         ),
// //       );
// //     } else {
// //       return Image.network(
// //         widget.reel.thumbnailSignedUrl,
// //         fit: BoxFit.cover,
// //         loadingBuilder: (context, child, loadingProgress) => const Center(
// //           child: CupertinoActivityIndicator(radius: 25),
// //         ),
// //         errorBuilder: (context, error, stackTrace) =>
// //             const Center(child: Icon(Icons.error)),
// //       );
// //     }
// //   }
// //
// //   Widget _buildPlayPauseIcon() {
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Center(
// //         child: AnimatedOpacity(
// //           opacity: _showPlayPauseIcon ? 1.0 : 0.0,
// //           duration: const Duration(milliseconds: 300),
// //           child: Icon(
// //             _isPlaying ? Icons.pause : Icons.play_arrow,
// //             color: Colors.white,
// //             size: 100,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildOverlay() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: _togglePlayPause,
// //           ),
// //         ),
// //         _buildReelInfo(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildReelInfo() {
// //     final height = MediaQuery.of(context).size.height;
// //     final width = MediaQuery.of(context).size.width;
// //     return SizedBox(
// //       height: height,
// //       width: width,
// //       child: Padding(
// //         padding: const EdgeInsets.only(bottom: 8.0),
// //         child: Row(
// //           children: [
// //             // Positioned(
// //             //
// //             //   top: 100,
// //             //   right: 100,
// //             //   child: Padding(
// //             //     padding: EdgeInsets.all(8.0),
// //             //     child: IconButton(
// //             //
// //             //       onPressed: () {
// //             //         _pauseVideo();
// //             //
// //             //         Navigator.push(
// //             //             context,
// //             //             MaterialPageRoute(
// //             //               builder: (context) => const ReelsRecordingScreen(),
// //             //             ));
// //             //       },
// //             //       icon: const FaIcon(
// //             //         Icons.camera_alt_outlined,
// //             //         color: Colors.white,
// //             //         size: 35,
// //             //       ),
// //             //     ),
// //             //   ),
// //             // ),
// //
// //             Expanded(
// //               flex: 4,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(4.0),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.max,
// //                   mainAxisAlignment: MainAxisAlignment.end,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     FittedBox(
// //                       child: Row(
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           _buildUserAvatar(),
// //                           const SizedBox(width: 12),
// //                           _buildUserInfo(),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(
// //                       height: 8,
// //                     ),
// //                     FittedBox(child: _buildAudioAndButtons(width)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // context.isArabic
// //             //     ? Positioned(
// //             //         left: 8,
// //             //         bottom: 0,
// //             //         child: _buildActionButtons(),
// //             //       )
// //             //     :
// //             Expanded(flex: 1, child: _buildActionButtons()),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserAvatar() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         border: Border.all(
// //           color: widget.reel.user.story
// //               ? AppColors.PRIMARY_COLOR_DARK
// //               : Colors.transparent,
// //           width: 3,
// //         ),
// //       ),
// //       child: InkWell(
// //         onTap: () {
// //           context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
// //         },
// //         child: CircleAvatar(
// //           radius: 60.h,
// //           backgroundImage: CachedNetworkImageProvider(
// //             widget.reel.user.profilePictureSignedUrl!,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserInfo() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         InkWell(
// //             onTap: () {
// //               context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
// //             },
// //             child: _buildUserName()),
// //         _buildReelNameAndViews(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildUserName() {
// //     return Row(
// //       children: [
// //         Text(
// //           capitalizeAndSplit(
// //               '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
// //           textScaler: TextScaler.noScaling, // Disable font scaling
// //
// //           style: TextStyle(
// //             fontSize: 50.sp,
// //             color: Colors.white,
// //             decoration: TextDecoration.none,
// //             fontWeight: FontWeight.bold,
// //             shadows: const [
// //               Shadow(
// //                 offset: Offset(1.0, 1.0),
// //                 // blurRadius: 0.0,
// //                 color: Colors.black,
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(width: 4),
// //         if (widget.reel.user.verified)
// //           const Icon(
// //             Icons.verified,
// //             color: AppColors.PRIMARY_COLOR_DARK,
// //             size: 25,
// //           ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildReelNameAndViews() {
// //     return Row(
// //       children: [
// //         Text(
// //           "${widget.reel.name.substring(0, (widget.reel.name.length * 0.75).round())}...",
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //           textScaler: TextScaler.noScaling,
// //           // Disable font scaling
// //
// //           style: TextStyle(
// //             fontSize: 30.sp,
// //             color: Colors.white60,
// //             decoration: TextDecoration.none,
// //             shadows: const [
// //               Shadow(
// //                 offset: Offset(1.0, 1.0),
// //                 // blurRadius: 1.0,
// //                 color: Colors.black,
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(width: 16),
// //         FaIcon(
// //           FontAwesomeIcons.eye,
// //           size: 20,
// //           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
// //         ),
// //         const SizedBox(width: 8),
// //         Text(
// //           widget.reel.viewCount.toString(),
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //           textScaler: TextScaler.noScaling,
// //           // Disable font scaling
// //
// //           style: TextStyle(
// //             fontSize: 30.sp,
// //             color: Colors.white60,
// //             decoration: TextDecoration.none,
// //             shadows: const [
// //               Shadow(
// //                 offset: Offset(1.0, 1.0),
// //                 // blurRadius: 1.0,
// //                 color: Colors.black,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildAudioAndButtons(double width) {
// //     return Container(
// //       color: Colors.blueGrey.withOpacity(0.2),
// //       child: ScrollingText(text: widget.reel.audio.audioName),
// //     );
// //   }
// //
// //   Widget _buildActionButtons() {
// //     final reelsCubit = context.read<ReelsCubit>();
// //
// //     return Column(
// //       mainAxisSize: MainAxisSize.max,
// //       mainAxisAlignment: MainAxisAlignment.end,
// //       children: [
// //         _buildActionButton(
// //           widget.reel.likeCount == 0
// //               ? FontAwesomeIcons.heart
// //               : FontAwesomeIcons.solidHeart,
// //           widget.reel.likeCount,
// //           () async {
// //             await _handleLikeAction(reelsCubit);
// //           },
// //           iconColor: widget.reel.likeCount == 0 ? Colors.white : Colors.red,
// //         ),
// //         _buildActionButton(
// //           FontAwesomeIcons.comment,
// //           widget.reel.commentCount,
// //           () async {
// //             await _handleCommentAction(reelsCubit);
// //           },
// //         ),
// //         _buildActionButton(
// //           FontAwesomeIcons.paperPlane,
// //           widget.reel.shareCount,
// //           () async {
// //             _handleShareAction(widget.reel.videoMedia);
// //           },
// //         ),
// //         _buildActionButton(
// //           widget.reel.saveCount == 0
// //               ? FontAwesomeIcons.bookmark
// //               : FontAwesomeIcons.solidBookmark,
// //           widget.reel.saveCount,
// //           () async {
// //             await _handleSaveAction(reelsCubit);
// //           },
// //           iconColor:
// //               widget.reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
// //         ),
// //         _buildActionButton(
// //           Icons.card_giftcard,
// //           0,
// //           () {
// //             showGiftBottomSheet(context, receiverId: widget.reel.user.id);
// //           },
// //         ),
// //         _buildActionButton(
// //           Icons.report_outlined,
// //           0,
// //           () {
// //             bottomSheet(
// //               context: context,
// //               widget: ReportView(
// //                 id: widget.reel.user.id,
// //                 categoryId: '66684135dbb427ee42aa0141',
// //               ),
// //             );
// //           },
// //         ),
// //         // Container(
// //         //   width: 50.h,
// //         //   height: 50.h,
// //         //   decoration: BoxDecoration(
// //         //     color: widget.reel.audio.audioPicture.isEmpty
// //         //         ? Colors.black
// //         //         : Colors.transparent, // Background color
// //         //     image: DecorationImage(
// //         //       image: NetworkImage(
// //         //         widget.reel.audio.audioPicture,
// //         //       ),
// //         //       fit: BoxFit.cover,
// //         //       onError: (exception, stackTrace) => Container(
// //         //         height: double.infinity,
// //         //         width: double.infinity,
// //         //         color: Colors.black,
// //         //       ),
// //         //     ),
// //         //     borderRadius: const BorderRadius.only(
// //         //       topLeft: Radius.circular(10.0), // Rounded corner on the left
// //         //       topRight: Radius.circular(10.0),
// //         //       bottomLeft: Radius.circular(10.0),
// //         //       bottomRight: Radius.circular(50.0),
// //         //     ),
// //         //   ),
// //         //   child: InkWell(
// //         //     onTap: () {
// //         //       _pauseVideo();
// //         //       Navigator.push(
// //         //         context,
// //         //         MaterialPageRoute(
// //         //           builder: (context) => BlocProvider.value(
// //         //             value: serviceLocator<ReelsCubit>()
// //         //               ..fetchReelsWithSameAudio(widget.reel.audio.id),
// //         //             child: InstagramAudioScreen(
// //         //               audio: widget.reel.audio,
// //         //               reel: widget.reel,
// //         //             ),
// //         //           ),
// //         //         ),
// //         //       );
// //         //     },
// //         //     child: Stack(
// //         //       children: [
// //         //         // Music Note Icon
// //         //         Positioned(
// //         //           bottom: 0.0,
// //         //           right: 0.0,
// //         //           child: Icon(
// //         //             FontAwesomeIcons.music,
// //         //             size: 20.h,
// //         //             shadows: const [
// //         //               Shadow(
// //         //                 offset: Offset(1.0, 1.0),
// //         //                 blurRadius: 1.0,
// //         //                 color: Colors.black,
// //         //               ),
// //         //             ],
// //         //             color: Colors.white, // Icon color
// //         //           ),
// //         //         ),
// //         //       ],
// //         //     ),
// //         //   ),
// //         // )
// //         RotatingCircularButton(reel: widget.reel)
// //       ],
// //     );
// //   }
// //
// //   Future<void> _handleLikeAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.likeReel(widget.reel.id);
// //       final response = reelsCubit.state.likeReelResponse;
// //       if (response?.message == "Reel liked successfully") {
// //         setState(() => widget.reel.likeCount++);
// //       } else if (response?.message == "Reel unlike successfully") {
// //         setState(() {
// //           if (widget.reel.likeCount > 0) widget.reel.likeCount--;
// //         });
// //       }
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   Future<void> _handleCommentAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.getComments(widget.reel.id);
// //       _togglePlayPause();
// //
// //       await showCommentsBottomSheet(context, reel: widget.reel);
// //       _togglePlayPause();
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   void _handleShareAction(String videoUrl) {
// //     Share.share(
// //       videoUrl,
// //       subject: 'Check out this reel!',
// //     );
// //   }
// //
// //   Future<void> _handleSaveAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.saveReel(widget.reel.id);
// //       final response = reelsCubit.state.reelSaveResponse;
// //       if (response!.message == "saved successfully") {
// //         setState(() => widget.reel.saveCount++);
// //       } else if (response.message == "unsaved successfully") {
// //         setState(() => widget.reel.saveCount--);
// //       }
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   Widget _buildActionButton(IconData icon, int count, VoidCallback function,
// //       {Color? iconColor}) {
// //     return IconButton(
// //       padding: EdgeInsets.zero,
// //       onPressed: function,
// //       icon: Column(
// //         children: [
// //           FaIcon(
// //             icon,
// //             color: iconColor ?? Colors.white,
// //             size: 40.h,
// //           ),
// //           // if (count != 0)
// //           Text(
// //             count > 0 ? '$count' : " ", textScaler: TextScaler.noScaling,
// //             // Disable font scaling
// //
// //             style: TextStyle(
// //               fontSize: 25.sp,
// //               color: Colors.white,
// //               decoration: TextDecoration.none,
// //               shadows: const [
// //                 Shadow(
// //                   offset: Offset(0, 1.0),
// //                   // blurRadius: 0.0,
// //                   color: Colors.black,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pauseVideo();
// //     _videoPlayerController.dispose();
// //     _chewieController?.dispose();
// //     super.dispose();
// //   }
// // }
// //
// // class RotatingCircularButton extends StatefulWidget {
// //   final Reel reel;
// //
// //   const RotatingCircularButton({super.key, required this.reel});
// //
// //   @override
// //   _RotatingCircularButtonState createState() => _RotatingCircularButtonState();
// // }
// //
// // class _RotatingCircularButtonState extends State<RotatingCircularButton>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _rotationController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _rotationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 5), // Adjust the duration as needed
// //     )..repeat(); // This makes the animation repeat indefinitely
// //   }
// //
// //   @override
// //   void dispose() {
// //     _rotationController
// //         .dispose(); // Dispose the controller when the widget is disposed
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ClipOval(
// //       child: RotationTransition(
// //         turns: _rotationController,
// //         child: Container(
// //           width: 55.h,
// //           height: 55.h,
// //           decoration: BoxDecoration(
// //             color: widget.reel.audio.audioPicture.isEmpty
// //                 ? Colors.black
// //                 : Colors.transparent,
// //             image: DecorationImage(
// //               image: NetworkImage(
// //                 widget.reel.audio.audioPicture,
// //               ),
// //               fit: BoxFit.cover,
// //               onError: (exception, stackTrace) => Container(
// //                 height: double.infinity,
// //                 width: double.infinity,
// //                 color: Colors.black,
// //               ),
// //             ),
// //           ),
// //           child: InkWell(
// //             onTap: () {
// //               // _pauseVideo();
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => BlocProvider.value(
// //                     value: serviceLocator<ReelsCubit>()
// //                       ..fetchReelsWithSameAudio(widget.reel.audio.id),
// //                     child: InstagramAudioScreen(
// //                       audio: widget.reel.audio,
// //                       reel: widget.reel,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //             child: Stack(
// //               children: [
// //                 // Music Note Icon
// //                 Positioned(
// //                   bottom: 0.0,
// //                   right: 0.0,
// //                   top: 0,
// //                   left: 0,
// //                   child: Icon(
// //                     FontAwesomeIcons.music,
// //                     size: 30.w,
// //                     shadows: const [
// //                       Shadow(
// //                         offset: Offset(1.0, 1.0),
// //                         blurRadius: 1.0,
// //                         color: Colors.black,
// //                       ),
// //                     ],
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // //-------------------------------------------------------------------------------------------------------------------
// // class ReelItemForInstagram extends StatefulWidget {
// //   final Reel reel;
// //   final bool isVisible;
// //
// //   const ReelItemForInstagram(
// //       {super.key, required this.reel, required this.isVisible});
// //
// //   @override
// //   ReelItemForInstagramState createState() => ReelItemForInstagramState();
// // }
// //
// // class ReelItemForInstagramState extends State<ReelItemForInstagram>
// //     with AutomaticKeepAliveClientMixin {
// //   late final VideoPlayerController _videoPlayerController;
// //   ChewieController? _chewieController;
// //   bool _isInitialized = false;
// //   bool _isPlaying = false;
// //   bool _showPlayPauseIcon = false;
// //
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }
// //
// //   @override
// //   void didUpdateWidget(ReelItemForInstagram oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.isVisible != oldWidget.isVisible) {
// //       widget.isVisible ? _playVideo() : _pauseVideo();
// //     }
// //   }
// //
// //   Future<void> _initializePlayer() async {
// //     if (!await _checkConnectivity()) return;
// //
// //     await _initializeVideoController();
// //     _setupChewieController();
// //     _setInitialVideoState();
// //   }
// //
// //   Future<void> _initializeVideoController() async {
// //     _videoPlayerController =
// //         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
// //     try {
// //       await _videoPlayerController.initialize();
// //     } catch (error) {
// //       if (mounted) {
// //         _handleVideoError('Failed to load video');
// //       }
// //     }
// //   }
// //
// //   void _setupChewieController() {
// //     _chewieController = ChewieController(
// //       videoPlayerController: _videoPlayerController,
// //       autoPlay: widget.isVisible,
// //       looping: true,
// //       showControls: false,
// //       aspectRatio: _videoPlayerController.value.aspectRatio,
// //     );
// //   }
// //
// //   void _setInitialVideoState() {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = true;
// //         _isPlaying = widget.isVisible;
// //       });
// //     }
// //   }
// //
// //   Future<bool> _checkConnectivity() async {
// //     final connectivityResult = await Connectivity().checkConnectivity();
// //     if (connectivityResult == ConnectivityResult.none) {
// //       if (mounted) {
// //         _handleVideoError('No internet connection');
// //       }
// //       return false;
// //     }
// //     return true;
// //   }
// //
// //   void _handleVideoError(String message) {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(message)),
// //       );
// //     }
// //   }
// //
// //   void _playVideo() {
// //     if (_isInitialized && !_isPlaying) {
// //       _chewieController?.play();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = true;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //       _hidePlayPauseIconAfterDelay();
// //     }
// //   }
// //
// //   void _pauseVideo() {
// //     if (_isInitialized && _isPlaying) {
// //       _chewieController?.pause();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = false;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //     }
// //   }
// //
// //   void _togglePlayPause() {
// //     if (_isPlaying) {
// //       _pauseVideo();
// //     } else {
// //       _playVideo();
// //     }
// //   }
// //
// //   void _hidePlayPauseIconAfterDelay() {
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (mounted) {
// //         setState(() {
// //           _showPlayPauseIcon = false;
// //         });
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           _buildVideoOrPlaceholder(),
// //           _buildPlayPauseIcon(),
// //           _buildOverlay(),
// //           if (!_isInitialized)
// //             const Center(
// //               child: CupertinoActivityIndicator(radius: 25),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildVideoOrPlaceholder() {
// //     if (_isInitialized && _chewieController != null) {
// //       return FittedBox(
// //         fit: BoxFit.fitHeight,
// //         child: SizedBox(
// //           width: _videoPlayerController.value.size.width,
// //           height: _videoPlayerController.value.size.height,
// //           child: Chewie(controller: _chewieController!),
// //         ),
// //       );
// //     } else {
// //       return Image.network(
// //         widget.reel.thumbnailSignedUrl,
// //         fit: BoxFit.cover,
// //         loadingBuilder: (context, child, loadingProgress) => const Center(
// //           child: CupertinoActivityIndicator(radius: 25),
// //         ),
// //         errorBuilder: (context, error, stackTrace) =>
// //             const Center(child: Icon(Icons.error)),
// //       );
// //     }
// //   }
// //
// //   Widget _buildPlayPauseIcon() {
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Center(
// //         child: AnimatedOpacity(
// //           opacity: _showPlayPauseIcon ? 1.0 : 0.0,
// //           duration: const Duration(milliseconds: 300),
// //           child: Icon(
// //             _isPlaying ? Icons.pause : Icons.play_arrow,
// //             color: Colors.white,
// //             size: 100,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildOverlay() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: _togglePlayPause,
// //           ),
// //         ),
// //         _buildReelInfo(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildReelInfo() {
// //     final height = MediaQuery.of(context).size.height;
// //     final width = MediaQuery.of(context).size.width;
// //     return SizedBox(
// //       height: height,
// //       width: width,
// //       child: Row(
// //         children: [
// //           // Positioned(
// //           //
// //           //   top: 100,
// //           //   right: 100,
// //           //   child: Padding(
// //           //     padding: EdgeInsets.all(8.0),
// //           //     child: IconButton(
// //           //
// //           //       onPressed: () {
// //           //         _pauseVideo();
// //           //
// //           //         Navigator.push(
// //           //             context,
// //           //             MaterialPageRoute(
// //           //               builder: (context) => const ReelsRecordingScreen(),
// //           //             ));
// //           //       },
// //           //       icon: const FaIcon(
// //           //         Icons.camera_alt_outlined,
// //           //         color: Colors.white,
// //           //         size: 35,
// //           //       ),
// //           //     ),
// //           //   ),
// //           // ),
// //
// //           Padding(
// //             padding: const EdgeInsets.all(4.0),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.max,
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 FittedBox(
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       _buildUserAvatar(),
// //                       const SizedBox(width: 12),
// //                       _buildUserInfo(),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(
// //                   height: 8,
// //                 ),
// //                 FittedBox(child: _buildAudioAndButtons(width)),
// //               ],
// //             ),
// //           ),
// //
// //           // context.isArabic
// //           //     ? Positioned(
// //           //         left: 8,
// //           //         bottom: 0,
// //           //         child: _buildActionButtons(),
// //           //       )
// //           //     :
// //           _buildActionButtons(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserAvatar() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         border: Border.all(
// //           color: widget.reel.user.story
// //               ? AppColors.PRIMARY_COLOR_DARK
// //               : Colors.transparent,
// //           width: 3,
// //         ),
// //       ),
// //       child: InkWell(
// //         onTap: () {
// //           context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
// //         },
// //         child: CircleAvatar(
// //           radius: 20,
// //           backgroundImage: CachedNetworkImageProvider(
// //             widget.reel.user.profilePictureSignedUrl!,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserInfo() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         InkWell(
// //             onTap: () {
// //               context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
// //             },
// //             child: _buildUserName()),
// //         _buildReelNameAndViews(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildUserName() {
// //     return Row(
// //       children: [
// //         Text(
// //           capitalizeAndSplit(
// //               '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
// //           textScaler: TextScaler.noScaling, // Disable font scaling
// //
// //           style: TextStyle(
// //             fontSize: 50.sp,
// //             color: Colors.white,
// //             decoration: TextDecoration.none,
// //             fontWeight: FontWeight.bold,
// //             shadows: const [
// //               Shadow(
// //                 offset: Offset(1.0, 1.0),
// //                 // blurRadius: 0.0,
// //                 color: Colors.black,
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(width: 4),
// //         if (widget.reel.user.verified)
// //           const Icon(
// //             Icons.verified,
// //             color: AppColors.PRIMARY_COLOR_DARK,
// //             size: 25,
// //           ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildReelNameAndViews() {
// //     return Row(
// //       children: [
// //         Text(
// //           "${widget.reel.name.substring(0, (widget.reel.name.length * 0.75).round())}...",
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //           textScaler: TextScaler.noScaling,
// //           // Disable font scaling
// //
// //           style: TextStyle(
// //             fontSize: 30.sp,
// //             color: Colors.white60,
// //             decoration: TextDecoration.none,
// //             shadows: const [
// //               Shadow(
// //                 offset: Offset(1.0, 1.0),
// //                 // blurRadius: 1.0,
// //                 color: Colors.black,
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(width: 16),
// //         FaIcon(
// //           FontAwesomeIcons.eye,
// //           size: 20,
// //           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
// //         ),
// //         const SizedBox(width: 8),
// //         Text(
// //           widget.reel.viewCount.toString(),
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //           textScaler: TextScaler.noScaling,
// //           // Disable font scaling
// //
// //           style: TextStyle(
// //             fontSize: 30.sp,
// //             color: Colors.white60,
// //             decoration: TextDecoration.none,
// //             shadows: const [
// //               Shadow(
// //                 offset: Offset(1.0, 1.0),
// //                 // blurRadius: 1.0,
// //                 color: Colors.black,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildAudioAndButtons(double width) {
// //     return Container(
// //       color: Colors.blueGrey.withOpacity(0.2),
// //       child: ScrollingText(text: widget.reel.audio.audioName),
// //     );
// //   }
// //
// //   Widget _buildActionButtons() {
// //     final reelsCubit = context.read<ReelsCubit>();
// //
// //     return Padding(
// //       padding: const EdgeInsets.all(4.0).add(EdgeInsets.only(bottom: 30)),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.max,
// //         mainAxisAlignment: MainAxisAlignment.end,
// //         children: [
// //           _buildActionButton(
// //             widget.reel.likeCount == 0
// //                 ? FontAwesomeIcons.heart
// //                 : FontAwesomeIcons.solidHeart,
// //             widget.reel.likeCount,
// //             () async {
// //               await _handleLikeAction(reelsCubit);
// //             },
// //             iconColor: widget.reel.likeCount == 0 ? Colors.white : Colors.red,
// //           ),
// //           _buildActionButton(
// //             FontAwesomeIcons.comment,
// //             widget.reel.commentCount,
// //             () async {
// //               await _handleCommentAction(reelsCubit);
// //             },
// //           ),
// //           _buildActionButton(
// //             FontAwesomeIcons.paperPlane,
// //             widget.reel.shareCount,
// //             () async {
// //               _handleShareAction(widget.reel.videoMedia);
// //             },
// //           ),
// //           _buildActionButton(
// //             widget.reel.saveCount == 0
// //                 ? FontAwesomeIcons.bookmark
// //                 : FontAwesomeIcons.solidBookmark,
// //             widget.reel.saveCount,
// //             () async {
// //               await _handleSaveAction(reelsCubit);
// //             },
// //             iconColor:
// //                 widget.reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
// //           ),
// //           _buildActionButton(
// //             Icons.card_giftcard,
// //             0,
// //             () {
// //               showGiftBottomSheet(context, receiverId: widget.reel.user.id);
// //             },
// //           ),
// //           _buildActionButton(
// //             Icons.report_outlined,
// //             0,
// //             () {
// //               bottomSheet(
// //                 context: context,
// //                 widget: ReportView(
// //                   id: widget.reel.user.id,
// //                   categoryId: '66684135dbb427ee42aa0141',
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Future<void> _handleLikeAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.likeReel(widget.reel.id);
// //       final response = reelsCubit.state.likeReelResponse;
// //       if (response?.message == "Reel liked successfully") {
// //         setState(() => widget.reel.likeCount++);
// //       } else if (response?.message == "Reel unlike successfully") {
// //         setState(() {
// //           if (widget.reel.likeCount > 0) widget.reel.likeCount--;
// //         });
// //       }
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   Future<void> _handleCommentAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.getComments(widget.reel.id);
// //       _togglePlayPause();
// //
// //       await showCommentsBottomSheet(context, reel: widget.reel);
// //       _togglePlayPause();
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   void _handleShareAction(String videoUrl) {
// //     Share.share(
// //       videoUrl,
// //       subject: 'Check out this reel!',
// //     );
// //   }
// //
// //   Future<void> _handleSaveAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.saveReel(widget.reel.id);
// //       final response = reelsCubit.state.reelSaveResponse;
// //       if (response!.message == "saved successfully") {
// //         setState(() => widget.reel.saveCount++);
// //       } else if (response.message == "unsaved successfully") {
// //         setState(() => widget.reel.saveCount--);
// //       }
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   Widget _buildActionButton(IconData icon, int count, VoidCallback function,
// //       {Color? iconColor}) {
// //     return IconButton(
// //       onPressed: function,
// //       icon: Column(
// //         children: [
// //           FaIcon(
// //             icon,
// //             color: iconColor ?? Colors.white,
// //             size: 50.h,
// //           ),
// //           // if (count != 0)
// //           Text(
// //             count > 0 ? '$count' : " ", textScaler: TextScaler.noScaling,
// //             // Disable font scaling
// //
// //             style: TextStyle(
// //               fontSize: 30.sp,
// //               color: Colors.white,
// //               decoration: TextDecoration.none,
// //               shadows: const [
// //                 Shadow(
// //                   offset: Offset(0, 1.0),
// //                   // blurRadius: 0.0,
// //                   color: Colors.black,
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(
// //             height: 2,
// //           )
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pauseVideo();
// //     _videoPlayerController.dispose();
// //     _chewieController?.dispose();
// //     super.dispose();
// //   }
// // }
// // //-------------------------------------------------------------------------------------------------------------------
// // // ----------------------------------------------------------------------------------------
// //
// // class SpotlightReelItem extends StatefulWidget {
// //   final Reel reel;
// //   final bool isVisible;
// //
// //   const SpotlightReelItem(
// //       {super.key, required this.reel, required this.isVisible});
// //
// //   @override
// //   SpotlightReelItemState createState() => SpotlightReelItemState();
// // }
// //
// // class SpotlightReelItemState extends State<SpotlightReelItem>
// //     with AutomaticKeepAliveClientMixin {
// //   late final VideoPlayerController _videoPlayerController;
// //   ChewieController? _chewieController;
// //   bool _isInitialized = false;
// //   bool _isPlaying = false;
// //   bool _showPlayPauseIcon = false;
// //
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }
// //
// //   @override
// //   void didUpdateWidget(SpotlightReelItem oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.isVisible != oldWidget.isVisible) {
// //       widget.isVisible ? _playVideo() : _pauseVideo();
// //     }
// //   }
// //
// //   Future<void> _initializePlayer() async {
// //     if (!await _checkConnectivity()) return;
// //
// //     await _initializeVideoController();
// //     _setupChewieController();
// //     _setInitialVideoState();
// //   }
// //
// //   Future<void> _initializeVideoController() async {
// //     _videoPlayerController =
// //         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
// //     try {
// //       await _videoPlayerController.initialize();
// //     } catch (error) {
// //       if (mounted) {
// //         _handleVideoError('Failed to load video');
// //       }
// //     }
// //   }
// //
// //   void _setupChewieController() {
// //     _chewieController = ChewieController(
// //       videoPlayerController: _videoPlayerController,
// //       autoPlay: widget.isVisible,
// //       looping: true,
// //       showControls: false,
// //       aspectRatio: _videoPlayerController.value.aspectRatio,
// //     );
// //   }
// //
// //   void _setInitialVideoState() {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = true;
// //         _isPlaying = widget.isVisible;
// //       });
// //     }
// //   }
// //
// //   Future<bool> _checkConnectivity() async {
// //     final connectivityResult = await Connectivity().checkConnectivity();
// //     if (connectivityResult == ConnectivityResult.none) {
// //       if (mounted) {
// //         _handleVideoError('No internet connection');
// //       }
// //       return false;
// //     }
// //     return true;
// //   }
// //
// //   void _handleVideoError(String message) {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(message)),
// //       );
// //     }
// //   }
// //
// //   void _playVideo() {
// //     if (_isInitialized && !_isPlaying) {
// //       _chewieController?.play();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = true;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //       _hidePlayPauseIconAfterDelay();
// //     }
// //   }
// //
// //   void _pauseVideo() {
// //     if (_isInitialized && _isPlaying) {
// //       _chewieController?.pause();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = false;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //     }
// //   }
// //
// //   void _togglePlayPause() {
// //     if (_isPlaying) {
// //       _pauseVideo();
// //     } else {
// //       _playVideo();
// //     }
// //   }
// //
// //   void _hidePlayPauseIconAfterDelay() {
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (mounted) {
// //         setState(() {
// //           _showPlayPauseIcon = false;
// //         });
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       onVerticalDragEnd: (details) async {
// //         // Check if the swipe was upwards (primaryVelocity < 0)
// //         if (details.primaryVelocity! < 0) {
// //           // Show the bottom sheet for any upward swipe
// //           _togglePlayPause();
// //
// //           await ProfileBottomSheet.show(context, widget.reel);
// //           _togglePlayPause();
// //         }
// //       },
// //       child: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           _buildVideoOrPlaceholder(),
// //           _buildPlayPauseIcon(),
// //           _buildOverlay(),
// //           if (!_isInitialized)
// //             const Center(
// //               child: CupertinoActivityIndicator(radius: 25),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildVideoOrPlaceholder() {
// //     if (_isInitialized && _chewieController != null) {
// //       return FittedBox(
// //         fit: BoxFit.fitHeight,
// //         child: SizedBox(
// //           width: _videoPlayerController.value.size.width,
// //           height: _videoPlayerController.value.size.height,
// //           child: Chewie(controller: _chewieController!),
// //         ),
// //       );
// //     } else {
// //       return CachedNetworkImage(
// //         imageUrl: widget.reel.thumbnailSignedUrl,
// //         fit: BoxFit.cover,
// //         placeholder: (context, url) => const Center(
// //           child: CupertinoActivityIndicator(radius: 25),
// //         ),
// //         errorWidget: (context, url, error) =>
// //             const Center(child: Icon(Icons.error)),
// //       );
// //     }
// //   }
// //
// //   Widget _buildPlayPauseIcon() {
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       child: Center(
// //         child: AnimatedOpacity(
// //           opacity: _showPlayPauseIcon ? 1.0 : 0.0,
// //           duration: const Duration(milliseconds: 300),
// //           child: Icon(
// //             _isPlaying ? Icons.pause : Icons.play_arrow,
// //             color: Colors.white,
// //             size: 100,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildOverlay() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const SizedBox(height: kToolbarHeight + 20),
// //         Expanded(
// //           child: GestureDetector(
// //             onTap: _togglePlayPause,
// //           ),
// //         ),
// //         _buildReelInfo(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildReelInfo() {
// //     final height = MediaQuery.of(context).size.height;
// //     final width = MediaQuery.of(context).size.width;
// //     return Padding(
// //       padding: const EdgeInsets.all(0.0),
// //       child: SizedBox(
// //         height: height * 0.5,
// //         width: double.infinity,
// //         child: Stack(
// //           children: [
// //             // Positioned(
// //             //
// //             //   top: 100,
// //             //   right: 100,
// //             //   child: Padding(
// //             //     padding: EdgeInsets.all(8.0),
// //             //     child: IconButton(
// //             //
// //             //       onPressed: () {
// //             //         _pauseVideo();
// //             //
// //             //         Navigator.push(
// //             //             context,
// //             //             MaterialPageRoute(
// //             //               builder: (context) => const ReelsRecordingScreen(),
// //             //             ));
// //             //       },
// //             //       icon: const FaIcon(
// //             //         Icons.camera_alt_outlined,
// //             //         color: Colors.white,
// //             //         size: 35,
// //             //       ),
// //             //     ),
// //             //   ),
// //             // ),
// //
// //             Positioned(
// //               bottom: 16,
// //               left: 4,
// //               right: 20,
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     children: [
// //                       _buildUserAvatar(),
// //                       const SizedBox(width: 12),
// //                       FittedBox(child: _buildUserInfo()),
// //                     ],
// //                   ),
// //                   _buildAudioAndButtons(width),
// //                 ],
// //               ),
// //             ),
// //             context.isArabic
// //                 ? Positioned(
// //                     left: 8,
// //                     bottom: 0,
// //                     child: _buildActionButtons(),
// //                   )
// //                 : Positioned(
// //                     right: 8,
// //                     bottom: 0,
// //                     child: _buildActionButtons(),
// //                   ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserAvatar() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         border: Border.all(
// //           color: widget.reel.user.story
// //               ? AppColors.PRIMARY_COLOR_DARK
// //               : Colors.transparent,
// //           width: 3,
// //         ),
// //       ),
// //       child: CircleAvatar(
// //         radius: 30,
// //         backgroundImage: CachedNetworkImageProvider(
// //           widget.reel.user.profilePictureSignedUrl!,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildUserInfo() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         _buildUserName(),
// //         _buildReelNameAndViews(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildUserName() {
// //     return Row(
// //       children: [
// //         Text(
// //           capitalizeAndSplit(
// //               '${widget.reel.user.firstName} ${widget.reel.user.lastName}'),
// //           textScaler: TextScaler.noScaling, // Disable font scaling
// //
// //           style: const TextStyle(
// //             fontSize: 26,
// //             decoration: TextDecoration.none,
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         const SizedBox(width: 4),
// //         if (widget.reel.user.verified)
// //           const Icon(
// //             Icons.verified,
// //             color: AppColors.PRIMARY_COLOR_DARK,
// //             size: 25,
// //           ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildReelNameAndViews() {
// //     return SizedBox(
// //       width: 200,
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Expanded(
// //             child: Text(
// //               widget.reel.name,
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //               textScaler: TextScaler.noScaling,
// //               // Disable font scaling
// //
// //               style: const TextStyle(
// //                 color: AppColors.DARK_GRAY_COLOR,
// //                 decoration: TextDecoration.none,
// //                 fontSize: 18,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 16),
// //           FaIcon(
// //             FontAwesomeIcons.eye,
// //             size: 20,
// //             color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
// //           ),
// //           const SizedBox(width: 8),
// //           Text(
// //             widget.reel.viewCount.toString(), textScaler: TextScaler.noScaling,
// //             // Disable font scaling
// //
// //             style: const TextStyle(
// //               color: AppColors.DARK_GRAY_COLOR,
// //               fontSize: 18,
// //               decoration: TextDecoration.none,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAudioAndButtons(double width) {
// //     return Row(
// //       children: [
// //         const SizedBox(width: 4),
// //         // FaIcon(
// //         //   FontAwesomeIcons.music,
// //         //   color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5),
// //         // ),
// //         Container(
// //           color: Colors.blueGrey.withOpacity(0.2),
// //           width: width / 2,
// //           child: ScrollingText(text: widget.reel.audio.audioName),
// //         ),
// //         const SizedBox(width: 4),
// //         RoundedButtonWithImage(
// //           imagePath: widget.reel.audio.audioPicture,
// //           onPressed: () {
// //             _pauseVideo();
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => BlocProvider.value(
// //                   value: serviceLocator<ReelsCubit>()
// //                     ..fetchReelsWithSameAudio(widget.reel.audio.id),
// //                   child: InstagramAudioScreen(
// //                     audio: widget.reel.audio,
// //                     reel: widget.reel,
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //         const Spacer(),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildActionButtons() {
// //     final reelsCubit = context.read<ReelsCubit>();
// //
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// //       children: [
// //         _buildActionButton(
// //           widget.reel.likeCount == 0
// //               ? FontAwesomeIcons.heart
// //               : FontAwesomeIcons.solidHeart,
// //           widget.reel.likeCount,
// //           () async {
// //             await _handleLikeAction(reelsCubit);
// //           },
// //           iconColor: widget.reel.likeCount == 0 ? Colors.white : Colors.red,
// //         ),
// //         _buildActionButton(
// //           FontAwesomeIcons.comment,
// //           widget.reel.commentCount,
// //           () async {
// //             await _handleCommentAction(reelsCubit);
// //           },
// //         ),
// //         _buildActionButton(
// //           FontAwesomeIcons.paperPlane,
// //           widget.reel.shareCount,
// //           () async {
// //             _handleShareAction(widget.reel.videoMedia);
// //           },
// //         ),
// //         _buildActionButton(
// //           widget.reel.saveCount == 0
// //               ? FontAwesomeIcons.bookmark
// //               : FontAwesomeIcons.solidBookmark,
// //           widget.reel.saveCount,
// //           () async {
// //             await _handleSaveAction(reelsCubit);
// //           },
// //           iconColor:
// //               widget.reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
// //         ),
// //         _buildActionButton(
// //           Icons.card_giftcard,
// //           0,
// //           () {
// //             showGiftBottomSheet(context, receiverId: widget.reel.user.id);
// //           },
// //         ),
// //         _buildActionButton(
// //           Icons.report_outlined,
// //           0,
// //           () {
// //             bottomSheet(
// //               context: context,
// //               widget: ReportView(
// //                 id: widget.reel.user.id,
// //                 categoryId: '66684135dbb427ee42aa0141',
// //               ),
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Future<void> _handleLikeAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.likeReel(widget.reel.id);
// //       final response = reelsCubit.state.likeReelResponse;
// //       if (response?.message == "Reel liked successfully") {
// //         setState(() => widget.reel.likeCount++);
// //       } else if (response?.message == "Reel unlike successfully") {
// //         setState(() => widget.reel.likeCount--);
// //       }
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   Future<void> _handleCommentAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.getComments(widget.reel.id);
// //       _togglePlayPause();
// //       await showCommentsBottomSheet(context, reel: widget.reel);
// //       _togglePlayPause();
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   void _handleShareAction(String videoUrl) {
// //     Share.share(
// //       videoUrl,
// //       subject: 'Check out this reel!',
// //     );
// //   }
// //
// //   Future<void> _handleSaveAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.saveReel(widget.reel.id);
// //       final response = reelsCubit.state.reelSaveResponse;
// //       if (response!.message == "saved successfully") {
// //         setState(() => widget.reel.saveCount++);
// //       } else if (response.message == "unsaved successfully") {
// //         setState(() => widget.reel.saveCount--);
// //       }
// //     } catch (e) {
// //       // Handle error (e.g., show a snackbar)
// //     }
// //   }
// //
// //   Widget _buildActionButton(IconData icon, int count, VoidCallback function,
// //       {Color? iconColor}) {
// //     return IconButton(
// //       onPressed: function,
// //       icon: Column(
// //         children: [
// //           FaIcon(
// //             icon,
// //             color: iconColor ?? Colors.white,
// //             size: 50.h,
// //           ),
// //           const SizedBox(height: 2),
// //           // if (count != 0)
// //           Text(
// //             count > 0 ? '$count' : " ", textScaler: TextScaler.noScaling,
// //             // Disable font scaling
// //
// //             style: const TextStyle(color: Colors.white),
// //           )
// //           // else
// //           // const Sizer(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pauseVideo();
// //     _videoPlayerController.dispose();
// //     _chewieController?.dispose();
// //     super.dispose();
// //   }
// // }
// //
// // // ----------------------------------------------------------------------------------------
// //
// // /*
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:chewie/chewie.dart';
// // import 'package:connectivity_plus/connectivity_plus.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:video_player/video_player.dart';
// //
// // import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
// // import '../../../../../common/widgets/dynamic/sizer.dart';
// // import '../../../../../res/style/app_colors.dart';
// // import '../../../../../routes/routes.dart';
// // import '../../../../../service_locator/service_locator.dart';
// // import '../../../../ads_feature/create_company_ad/presentation/pages/widgets/reel_post_content.dart';
// // import '../../../tinder/data/shared/shared.dart';
// // import '../../../twitter/presentation/widgets/report_view.dart';
// // import '../../data/models/new_reels_model.dart';
// // import '../controllers/explore_reels_cubit/explore_reels_cubit.dart';
// // import '../widgets/comments.dart';
// // import 'audio_screen.dart';
// // import 'profile_buttom_sheet.dart';
// //
// // /// A versatile ReelItem widget that adapts to different contexts such as
// // /// main feed, Instagram-style reels, and spotlight reels.
// // ///
// // /// [reel]: The Reel model containing all necessary data.
// // /// [isVisible]: Controls video playback based on visibility.
// // /// [isInstagram]: Adjusts UI components to mimic Instagram-style reels.
// // /// [isSpotlight]: Enables additional gestures and UI for spotlight reels.
// // /// [isMain]: Determines if the rotating circular button is displayed.
// // class ReelItem extends StatefulWidget {
// //   final Reel reel;
// //   final bool isVisible;
// //   final bool isInstagram;
// //   final bool isSpotlight;
// //   final bool isMain;
// //
// //   const ReelItem({
// //     Key? key,
// //     required this.reel,
// //     required this.isVisible,
// //     this.isInstagram = false,
// //     this.isSpotlight = false,
// //     this.isMain = false,
// //   }) : super(key: key);
// //
// //   @override
// //   _ReelItemState createState() => _ReelItemState();
// // }
// //
// // class _ReelItemState extends State<ReelItem>
// //     with AutomaticKeepAliveClientMixin {
// //   late final VideoPlayerController _videoPlayerController;
// //   ChewieController? _chewieController;
// //   bool _isInitialized = false;
// //   bool _isPlaying = false;
// //   bool _showPlayPauseIcon = false;
// //
// //   @override
// //   bool get wantKeepAlive => true;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }
// //
// //   @override
// //   void didUpdateWidget(ReelItem oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.isVisible != oldWidget.isVisible) {
// //       widget.isVisible ? _playVideo() : _pauseVideo();
// //     }
// //   }
// //
// //   /// Initializes the video player after checking connectivity.
// //   Future<void> _initializePlayer() async {
// //     if (!await _checkConnectivity()) return;
// //
// //     await _initializeVideoController();
// //     _setupChewieController();
// //     _setInitialVideoState();
// //   }
// //
// //   /// Initializes the VideoPlayerController with the provided video URL.
// //   Future<void> _initializeVideoController() async {
// //     _videoPlayerController =
// //         VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
// //     try {
// //       await _videoPlayerController.initialize();
// //     } catch (error) {
// //       if (mounted) {
// //         _handleVideoError('Failed to load video');
// //       }
// //     }
// //   }
// //
// //   /// Sets up the ChewieController for enhanced video controls.
// //   void _setupChewieController() {
// //     _chewieController = ChewieController(
// //       videoPlayerController: _videoPlayerController,
// //       autoPlay: widget.isVisible,
// //       looping: true,
// //       showControls: false,
// //       aspectRatio: _videoPlayerController.value.aspectRatio,
// //     );
// //   }
// //
// //   /// Sets the initial state of the video playback.
// //   void _setInitialVideoState() {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = true;
// //         _isPlaying = widget.isVisible;
// //       });
// //     }
// //   }
// //
// //   /// Checks network connectivity before initializing video.
// //   Future<bool> _checkConnectivity() async {
// //     final connectivityResult = await Connectivity().checkConnectivity();
// //     if (connectivityResult == ConnectivityResult.none) {
// //       if (mounted) {
// //         _handleVideoError('No internet connection');
// //       }
// //       return false;
// //     }
// //     return true;
// //   }
// //
// //   /// Handles video loading errors by displaying a SnackBar.
// //   void _handleVideoError(String message) {
// //     if (mounted) {
// //       setState(() {
// //         _isInitialized = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(message)),
// //       );
// //     }
// //   }
// //
// //   /// Plays the video if initialized and not already playing.
// //   void _playVideo() {
// //     if (_isInitialized && !_isPlaying) {
// //       _chewieController?.play();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = true;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //       _hidePlayPauseIconAfterDelay();
// //     }
// //   }
// //
// //   /// Pauses the video if initialized and currently playing.
// //   void _pauseVideo() {
// //     if (_isInitialized && _isPlaying) {
// //       _chewieController?.pause();
// //       if (mounted) {
// //         setState(() {
// //           _isPlaying = false;
// //           _showPlayPauseIcon = true;
// //         });
// //       }
// //     }
// //   }
// //
// //   /// Toggles between play and pause states.
// //   void _togglePlayPause() {
// //     _isPlaying ? _pauseVideo() : _playVideo();
// //   }
// //
// //   /// Hides the play/pause icon after a short delay.
// //   void _hidePlayPauseIconAfterDelay() {
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (mounted) {
// //         setState(() {
// //           _showPlayPauseIcon = false;
// //         });
// //       }
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     super.build(context);
// //     return GestureDetector(
// //       onTap: _togglePlayPause,
// //       onVerticalDragEnd: widget.isSpotlight
// //           ? (details) async {
// //               // Check if the swipe was upwards (primaryVelocity < 0)
// //               if (details.primaryVelocity! < 0) {
// //                 // Show the bottom sheet for any upward swipe
// //                 _togglePlayPause();
// //                 await ProfileBottomSheet.show(context, widget.reel);
// //                 _togglePlayPause();
// //               }
// //             }
// //           : null,
// //       child: Stack(
// //         fit: StackFit.expand,
// //         children: [
// //           _buildVideoOrPlaceholder(),
// //           _buildPlayPauseIcon(),
// //           _buildOverlay(),
// //           if (!_isInitialized)
// //             const Center(
// //               child: CupertinoActivityIndicator(radius: 25),
// //             ),
// //           if (widget.isInstagram)
// //             Positioned(
// //               bottom: 30,
// //               right: 10,
// //               child: _buildActionButtons(),
// //             ),
// //           if (widget.isMain)
// //             Positioned(
// //               right: 10,
// //               bottom: 100,
// //               child: RotatingCircularButton(reel: widget.reel),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// Builds the video player or a placeholder image.
// //   Widget _buildVideoOrPlaceholder() {
// //     if (_isInitialized && _chewieController != null) {
// //       return FittedBox(
// //         fit: BoxFit.cover,
// //         child: SizedBox(
// //           width: _videoPlayerController.value.size.width,
// //           height: _videoPlayerController.value.size.height,
// //           child: Chewie(controller: _chewieController!),
// //         ),
// //       );
// //     } else {
// //       return CachedNetworkImage(
// //         imageUrl: widget.reel.thumbnailSignedUrl,
// //         fit: BoxFit.cover,
// //         placeholder: (context, url) => const Center(
// //           child: CupertinoActivityIndicator(radius: 25),
// //         ),
// //         errorWidget: (context, url, error) =>
// //             const Center(child: Icon(Icons.error)),
// //       );
// //     }
// //   }
// //
// //   /// Displays the play/pause icon with animated opacity.
// //   Widget _buildPlayPauseIcon() {
// //     return AnimatedOpacity(
// //       opacity: _showPlayPauseIcon ? 1.0 : 0.0,
// //       duration: const Duration(milliseconds: 300),
// //       child: GestureDetector(
// //         onTap: _togglePlayPause,
// //         child: Center(
// //           child: Icon(
// //             _isPlaying ? Icons.pause : Icons.play_arrow,
// //             color: Colors.white,
// //             size: 100,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Builds the overlay containing user info, reel details, and action buttons.
// //   Widget _buildOverlay() {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         // Top overlay can be expanded for additional controls or branding
// //         if (!widget.isInstagram)
// //           Expanded(
// //             child: GestureDetector(
// //               onTap: _togglePlayPause,
// //             ),
// //           ),
// //         _buildReelInfo(),
// //       ],
// //     );
// //   }
// //
// //   /// Builds reel information including user avatar, name, and action buttons.
// //   Widget _buildReelInfo() {
// //     final width = MediaQuery.of(context).size.width;
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: widget.isInstagram
// //           ? _buildInstagramReelInfo(width)
// //           : _buildDefaultReelInfo(width),
// //     );
// //   }
// //
// //   /// Builds reel info specific to Instagram-style reels.
// //   Widget _buildInstagramReelInfo(double width) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   _buildUserAvatar(),
// //                   _buildUserInfo(),
// //
// //                 ],
// //               ),
// //               const SizedBox(height: 8),
// //               _buildAudioAndButtons(width),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Builds reel info for the default (main and spotlight) reels.
// //   Widget _buildDefaultReelInfo(double width) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           flex: 4,
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildUserInfo(),
// //               const SizedBox(height: 8),
// //               _buildAudioAndButtons(width),
// //             ],
// //           ),
// //         ),
// //         if (!widget.isInstagram)
// //           Expanded(
// //             flex: 1,
// //             child: _buildActionButtons(),
// //           ),
// //       ],
// //     );
// //   }
// //
// //   /// Builds the user avatar with a clickable profile link.
// //   Widget _buildUserAvatar() {
// //     return Container(
// //       decoration: BoxDecoration(
// //         shape: BoxShape.circle,
// //         border: Border.all(
// //           color: widget.reel.user.story
// //               ? AppColors.PRIMARY_COLOR_DARK
// //               : Colors.transparent,
// //           width: 3,
// //         ),
// //       ),
// //       child: InkWell(
// //         onTap: () {
// //           context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
// //         },
// //         child: CircleAvatar(
// //           radius: widget.isInstagram ? 20 : 60.h,
// //           backgroundImage: CachedNetworkImageProvider(
// //             widget.reel.user.profilePictureSignedUrl!,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Builds the user information including name and verification status.
// //   Widget _buildUserInfo() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         InkWell(
// //           onTap: () {
// //             context.push(Routes.OTHERSACCOUNT, extra: widget.reel.user.id);
// //           },
// //           child: _buildUserName(),
// //         ),
// //         _buildReelNameAndViews(),
// //       ],
// //     );
// //   }
// //
// //   /// Builds the user's name with verification badge if applicable.
// //   Widget _buildUserName() {
// //     return Row(
// //       children: [
// //         Text(
// //           _capitalizeAndFormatName(),
// //           textScaleFactor: 1.0, // Disable font scaling
// //           style: TextStyle(
// //             fontSize: widget.isInstagram ? 26.sp : 50.sp,
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //             shadows: widget.isInstagram
// //                 ? []
// //                 : const [
// //                     Shadow(
// //                       offset: Offset(1.0, 1.0),
// //                       color: Colors.black,
// //                     ),
// //                   ],
// //           ),
// //         ),
// //         const SizedBox(width: 4),
// //         if (widget.reel.user.verified)
// //           const Icon(
// //             Icons.verified,
// //             color: AppColors.PRIMARY_COLOR_DARK,
// //             size: 25,
// //           ),
// //       ],
// //     );
// //   }
// //
// //   /// Formats and capitalizes the user's full name.
// //   String _capitalizeAndFormatName() {
// //     String fullName =
// //         '${widget.reel.user.firstName} ${widget.reel.user.lastName}'.trim();
// //     return fullName.split(' ').map((e) => _capitalize(e)).join(' ');
// //   }
// //
// //   /// Capitalizes the first letter of a string.
// //   String _capitalize(String s) => s.isNotEmpty
// //       ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
// //       : '';
// //
// //   /// Builds the reel's name and view count with appropriate styling.
// //   Widget _buildReelNameAndViews() {
// //     final reelName = widget.isInstagram
// //         ? widget.reel.name
// //         : (widget.reel.name.length > 20
// //             ? "${widget.reel.name.substring(0, 17)}..."
// //             : widget.reel.name);
// //     final viewCount = widget.reel.viewCount.toString();
// //
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: Text(
// //             reelName,
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis,
// //             textScaleFactor: 1.0, // Disable font scaling
// //             style: TextStyle(
// //               fontSize: widget.isInstagram ? 18.sp : 30.sp,
// //               color: widget.isInstagram
// //                   ? AppColors.DARK_GRAY_COLOR
// //                   : Colors.white60,
// //               decoration: TextDecoration.none,
// //               shadows: widget.isInstagram
// //                   ? []
// //                   : const [
// //                       Shadow(
// //                         offset: Offset(1.0, 1.0),
// //                         color: Colors.black,
// //                       ),
// //                     ],
// //             ),
// //           ),
// //         ),
// //         const SizedBox(width: 16),
// //         FaIcon(
// //           FontAwesomeIcons.eye,
// //           size: 20,
// //           color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
// //         ),
// //         const SizedBox(width: 8),
// //         Text(
// //           viewCount,
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //           textScaleFactor: 1.0, // Disable font scaling
// //           style: TextStyle(
// //             fontSize: widget.isInstagram ? 18.sp : 30.sp,
// //             color:
// //                 widget.isInstagram ? AppColors.DARK_GRAY_COLOR : Colors.white60,
// //             decoration: TextDecoration.none,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Displays the audio name with a scrolling text effect.
// //   Widget _buildAudioAndButtons(double width) {
// //     return Container(
// //       color: Colors.blueGrey.withOpacity(0.2),
// //       child: ScrollingText(text: widget.reel.audio.audioName),
// //     );
// //   }
// //
// //   /// Builds the action buttons such as like, comment, share, save, gift, and report.
// //   Widget _buildActionButtons() {
// //     final reelsCubit = context.read<ReelsCubit>();
// //
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       mainAxisAlignment: widget.isInstagram
// //           ? MainAxisAlignment.end
// //           : MainAxisAlignment.spaceAround,
// //       children: [
// //         _buildActionButton(
// //           icon: widget.reel.likeCount == 0
// //               ? FontAwesomeIcons.heart
// //               : FontAwesomeIcons.solidHeart,
// //           count: widget.reel.likeCount,
// //           onPressed: () => _handleLikeAction(reelsCubit),
// //           iconColor: widget.reel.likeCount == 0 ? Colors.white : Colors.red,
// //           size: widget.isInstagram ? 30.h : 40.h,
// //           fontSize: widget.isInstagram ? 18.sp : 25.sp,
// //         ),
// //         _buildActionButton(
// //           icon: FontAwesomeIcons.comment,
// //           count: widget.reel.commentCount,
// //           onPressed: () => _handleCommentAction(reelsCubit),
// //           size: widget.isInstagram ? 30.h : 40.h,
// //           fontSize: widget.isInstagram ? 18.sp : 25.sp,
// //         ),
// //         _buildActionButton(
// //           icon: FontAwesomeIcons.paperPlane,
// //           count: widget.reel.shareCount,
// //           onPressed: () => _handleShareAction(widget.reel.videoMedia),
// //           size: widget.isInstagram ? 30.h : 40.h,
// //           fontSize: widget.isInstagram ? 18.sp : 25.sp,
// //         ),
// //         _buildActionButton(
// //           icon: widget.reel.saveCount == 0
// //               ? FontAwesomeIcons.bookmark
// //               : FontAwesomeIcons.solidBookmark,
// //           count: widget.reel.saveCount,
// //           onPressed: () => _handleSaveAction(reelsCubit),
// //           iconColor:
// //               widget.reel.saveCount == 0 ? Colors.white : Colors.yellowAccent,
// //           size: widget.isInstagram ? 30.h : 40.h,
// //           fontSize: widget.isInstagram ? 18.sp : 25.sp,
// //         ),
// //         _buildActionButton(
// //           icon: Icons.card_giftcard,
// //           count: 0,
// //           onPressed: () {
// //             showGiftBottomSheet(context, receiverId: widget.reel.user.id);
// //           },
// //           size: widget.isInstagram ? 30.h : 40.h,
// //           fontSize: widget.isInstagram ? 18.sp : 25.sp,
// //         ),
// //         _buildActionButton(
// //           icon: Icons.report_outlined,
// //           count: 0,
// //           onPressed: () {
// //             bottomSheet(
// //               context: context,
// //               widget: ReportView(
// //                 id: widget.reel.user.id,
// //                 categoryId: '66684135dbb427ee42aa0141',
// //               ),
// //             );
// //           },
// //           size: widget.isInstagram ? 30.h : 40.h,
// //           fontSize: widget.isInstagram ? 18.sp : 25.sp,
// //         ),
// //         if (widget.isMain) RotatingCircularButton(reel: widget.reel),
// //       ],
// //     );
// //   }
// //
// //   /// Constructs an individual action button with icon and count.
// //   Widget _buildActionButton({
// //     required IconData icon,
// //     required int count,
// //     required VoidCallback onPressed,
// //     Color? iconColor,
// //     double size = 40.0,
// //     double fontSize = 25.0,
// //   }) {
// //     return IconButton(
// //       padding: EdgeInsets.zero,
// //       onPressed: onPressed,
// //       icon: Column(
// //         children: [
// //           FaIcon(
// //             icon,
// //             color: iconColor ?? Colors.white,
// //             size: size,
// //           ),
// //           Text(
// //             count > 0 ? '$count' : " ",
// //             textScaleFactor: 1.0, // Disable font scaling
// //             style: TextStyle(
// //               fontSize: fontSize,
// //               color: Colors.white,
// //               shadows: widget.isInstagram
// //                   ? []
// //                   : const [
// //                       Shadow(
// //                         offset: Offset(0, 1.0),
// //                         color: Colors.black,
// //                       ),
// //                     ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// Handles the like action, updating the like count accordingly.
// //   Future<void> _handleLikeAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.likeReel(widget.reel.id);
// //       final response = reelsCubit.state.likeReelResponse;
// //       if (response?.message == "Reel liked successfully") {
// //         setState(() => widget.reel.likeCount++);
// //       } else if (response?.message == "Reel unlike successfully") {
// //         setState(() {
// //           if (widget.reel.likeCount > 0) widget.reel.likeCount--;
// //         });
// //       }
// //     } catch (e) {
// //       _showErrorSnackBar('Error liking reel: $e');
// //     }
// //   }
// //
// //   /// Handles the comment action by fetching comments and displaying the comments sheet.
// //   Future<void> _handleCommentAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.getComments(widget.reel.id);
// //       _togglePlayPause();
// //
// //       await showCommentsBottomSheet(context, reel: widget.reel);
// //       _togglePlayPause();
// //     } catch (e) {
// //       _showErrorSnackBar('Error loading comments: $e');
// //     }
// //   }
// //
// //   /// Shares the reel video URL using the share package.
// //   void _handleShareAction(String videoUrl) {
// //     Share.share(
// //       videoUrl,
// //       subject: 'Check out this reel!',
// //     );
// //   }
// //
// //   /// Handles the save action, updating the save count accordingly.
// //   Future<void> _handleSaveAction(ReelsCubit reelsCubit) async {
// //     try {
// //       await reelsCubit.saveReel(widget.reel.id);
// //       final response = reelsCubit.state.reelSaveResponse;
// //       if (response!.message == "saved successfully") {
// //         setState(() => widget.reel.saveCount++);
// //       } else if (response.message == "unsaved successfully") {
// //         setState(() => widget.reel.saveCount--);
// //       }
// //     } catch (e) {
// //       _showErrorSnackBar('Error saving reel: $e');
// //     }
// //   }
// //
// //   /// Displays an error SnackBar with the provided message.
// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message)),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pauseVideo();
// //     _videoPlayerController.dispose();
// //     _chewieController?.dispose();
// //     super.dispose();
// //   }
// // }
// //
// // /// A circular button that rotates to indicate the audio being played.
// // ///
// // /// [reel]: The Reel model containing audio information.
// // class RotatingCircularButton extends StatefulWidget {
// //   final Reel reel;
// //
// //   const RotatingCircularButton({Key? key, required this.reel})
// //       : super(key: key);
// //
// //   @override
// //   _RotatingCircularButtonState createState() => _RotatingCircularButtonState();
// // }
// //
// // class _RotatingCircularButtonState extends State<RotatingCircularButton>
// //     with SingleTickerProviderStateMixin {
// //   late final AnimationController _rotationController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _rotationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 5), // Rotation duration
// //     )..repeat(); // Repeats indefinitely
// //   }
// //
// //   @override
// //   void dispose() {
// //     _rotationController.dispose(); // Dispose the controller to free resources
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ClipOval(
// //       child: RotationTransition(
// //         turns: _rotationController,
// //         child: Container(
// //           width: 55.h,
// //           height: 55.h,
// //           decoration: BoxDecoration(
// //             color: widget.reel.audio.audioPicture.isEmpty
// //                 ? Colors.black
// //                 : Colors.transparent,
// //             image: DecorationImage(
// //               image: NetworkImage(widget.reel.audio.audioPicture),
// //               fit: BoxFit.cover,
// //               onError: (_, __) => Container(
// //                 color: Colors.black,
// //               ),
// //             ),
// //           ),
// //           child: InkWell(
// //             onTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => BlocProvider.value(
// //                     value: serviceLocator<ReelsCubit>()
// //                       ..fetchReelsWithSameAudio(widget.reel.audio.id),
// //                     child: InstagramAudioScreen(
// //                       audio: widget.reel.audio,
// //                       reel: widget.reel,
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //             child: const Center(
// //               child: Icon(
// //                 FontAwesomeIcons.music,
// //                 size: 30,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // */
