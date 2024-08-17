
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../data/repositories/reels_repository_impl.dart';

/// ReelView is the main screen that displays a list of reels.
/// It initializes the ReelsCubit and handles navigation.
class ReelView extends StatelessWidget {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      backgroundColor: Colors.transparent,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ReelsCubit(repository: ReelsRepository()),
          ),
          BlocProvider(
            create: (context) => serviceLocator<UserCubit>(),
          )
        ],
        child: const ReelsScreen(),
      ),
    );
  }

  /// Builds the app bar with a back button.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconAppButton(
        icon: Icons.arrow_back,
        color: Colors.white,
        size: 24,
        onPressed: () => context.pop(),
      ),
    );
  }
}

// void showRSnackBar(BuildContext context, {
//   required String message,
//   String? actionLabel,
//   VoidCallback? onActionPressed,
//   IconData? icon,
//   Color backgroundColor = Colors.black,
//   Color textColor = Colors.white,
//   Color actionTextColor = Colors.blue,
//   Duration duration = const Duration(seconds: 4),
// }) {
//
//
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(snackBar);
// }

void showSnackBarAfterBuild(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
  IconData? icon,
  Color backgroundColor = Colors.white10,
  Color textColor = Colors.red,
  Color actionTextColor = Colors.blue,
  Duration duration = const Duration(seconds: 1),
}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: textColor),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    action: actionLabel != null
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onActionPressed ?? () {},
            textColor: actionTextColor,
          )
        : null,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: const EdgeInsets.all(16),
    elevation: 10,
  );
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
}

/// ReelsScreen displays a list of reels in a vertical PageView.
/// The screen fetches more reels as the user scrolls.
class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  ReelsScreenState createState() => ReelsScreenState();
}

class ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialReels();
  }

  /// Fetches the initial set of reels.
  void _fetchInitialReels() {
    context.read<ReelsCubit>().fetchReels();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelsCubit, ReelsState>(
      builder: (context, state) {
        if (state.reels.isEmpty) {
          showSnackBarAfterBuild(context, message: 'Check the login page.');
          return const Center(
            child: CupertinoActivityIndicator(radius: 25),
          );
        }

        if (serviceLocator<UserCubit>().token == null ||
            serviceLocator<UserCubit>().token!.isEmpty) {
          showSnackBarAfterBuild(context, message: 'Check the login page.');

          return const Center(
            child: CupertinoActivityIndicator(radius: 25),
          );
        }

        return PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: state.reels.length + (state.hasReachedMax ? 0 : 1),
          onPageChanged: _handlePageChange,
          itemBuilder: (context, index) {
            if (index >= state.reels.length) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 25),
              );
            }
            return ReelItem(
              key: ValueKey(state.reels[index].id),
              reel: state.reels[index],
              isVisible: _currentPage == index,
            );
          },
        );
      },
    );
  }

  /// Handles the page change event to load more reels if needed.
  void _handlePageChange(int index) {
    setState(() => _currentPage = index);
    final reelsCubit = context.read<ReelsCubit>();
    if (index == reelsCubit.state.reels.length - 1) {
      reelsCubit.fetchReels();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

/// ReelItem displays an individual reel, handling video playback and visibility.
class ReelItem extends StatefulWidget {
  final Reel reel;
  final bool isVisible;

  const ReelItem({super.key, required this.reel, required this.isVisible});

  @override
  ReelItemState createState() => ReelItemState();
}

class ReelItemState extends State<ReelItem> with AutomaticKeepAliveClientMixin {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayPauseIcon = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _playVideo() : _pauseVideo();
    }
  }

  /// Initializes the video player and handles connectivity checks.
  Future<void> _initializePlayer() async {
    if (!await _checkConnectivity()) return;

    await _initializeVideoController();
    _setupChewieController();
    _setInitialVideoState();
  }

  /// Initializes the video controller with the reel's video media.
  Future<void> _initializeVideoController() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoMedia));
    try {
      await _videoPlayerController.initialize();
    } catch (error) {
      _handleVideoError('Failed to load video');
    }
  }

  /// Sets up the Chewie controller with video player settings.
  void _setupChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.isVisible,
      looping: true,
      showControls: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
    );
  }

  /// Sets the initial state of the video player.
  void _setInitialVideoState() {
    setState(() {
      _isInitialized = true;
      _isPlaying = widget.isVisible;
    });
  }

  /// Checks the internet connectivity before initializing the player.
  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _handleVideoError('No internet connection');
      return false;
    }
    return true;
  }

  /// Handles video playback error by showing a message.
  void _handleVideoError(String message) {
    setState(() {
      _isInitialized = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Plays the video if it is initialized and not currently playing.
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

  /// Pauses the video if it is initialized and currently playing.
  void _pauseVideo() {
    if (_isInitialized && _isPlaying) {
      _chewieController?.pause();
      setState(() {
        _isPlaying = false;
        _showPlayPauseIcon = true;
      });
    }
  }

  /// Toggles play/pause state of the video.
  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
  }

  /// Hides the play/pause icon after a delay.
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoOrPlaceholder(),
          _buildPlayPauseIcon(),
          _buildOverlay(),
          if (!_isInitialized)
            const Center(
              child: CupertinoActivityIndicator(radius: 25),
            ),
        ],
      ),
    );
  }

  /// Builds the video player or a placeholder image.
  Widget _buildVideoOrPlaceholder() {
    if (_isInitialized && _chewieController != null) {
      return FittedBox(
        fit: BoxFit.fill,
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

  /// Builds the play/pause icon overlay.
  Widget _buildPlayPauseIcon() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Center(
        child: AnimatedOpacity(
          opacity: _showPlayPauseIcon ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 100,
          ),
        ),
      ),
    );
  }

  /// Builds the overlay containing user and reel info.
  Widget _buildOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kToolbarHeight + 20),
        Expanded(
          child: GestureDetector(
            onTap: _togglePlayPause,
          ),
        ),
        _buildReelInfo(),
      ],
    );
  }

  /// Builds the information section of the reel including user info and actions.
  Widget _buildReelInfo() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox(
        height: height / 2,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 16,
              left: 4,
              right: 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildUserAvatar(),
                      const SizedBox(width: 12),
                      Expanded(child: _buildUserInfo()),
                    ],
                  ),
                  _buildAudioAndButtons(width),
                ],
              ),
            ),
            Positioned(
              right: 8,
              bottom: kToolbarHeight,
              child: _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the user avatar with an optional story indicator.
  Widget _buildUserAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.reel.user.story
              ? AppColors.PRIMARY_COLOR_DARK
              : Colors.transparent,
          width: 3,
        ),
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: CachedNetworkImageProvider(
          widget.reel.user.profilePictureSignedUrl,
        ),
      ),
    );
  }

  /// Builds the user information including name and reel name.
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserName(),
        _buildReelNameAndViews(),
      ],
    );
  }

  /// Builds the user's name with a verification badge if applicable.
  Widget _buildUserName() {
    return Row(
      children: [
        Text(
          '${widget.reel.user.firstName} ${widget.reel.user.lastName}',
          textScaler: const TextScaler.linear(1.5),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        if (widget.reel.user.verified)
          const Icon(
            Icons.verified,
            color: Colors.blue,
            size: 25,
          ),
      ],
    );
  }

  /// Builds the reel name and view count.
  Widget _buildReelNameAndViews() {
    return Row(
      children: [
        Text(
          widget.reel.name,
          style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
        ),
        const SizedBox(width: 16),
        FaIcon(
          FontAwesomeIcons.eye,
          size: 20,
          color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          widget.reel.viewCount.toString(),
          style: const TextStyle(color: AppColors.DARK_GRAY_COLOR),
        ),
      ],
    );
  }

  /// Builds the audio name with a scrolling text effect and a button to use the audio.
  Widget _buildAudioAndButtons(double width) {
    return Row(
      children: [
        const SizedBox(width: 4),
        FaIcon(
          FontAwesomeIcons.music,
          color: AppColors.PRIMARY_COLOR_DARK.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Container(
          color: Colors.blueGrey.withOpacity(0.1),
          width: width / 2,
          child: ScrollingText(text: widget.reel.audio.audioName),
        ),
        const Spacer(),
        RoundedButtonWithImage(
          imagePath: widget.reel.audio.audioPicture,
          onPressed: () {
            _pauseVideo();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const InstagramAudioScreen(),
            //   ),
            // );
          },
        ),
      ],
    );
  }

  /// Builds a column of action buttons (like, comment, share, save).
  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(FontAwesomeIcons.heart, widget.reel.likeCount),
        _buildActionButton(FontAwesomeIcons.comment, widget.reel.commentCount),
        _buildActionButton(FontAwesomeIcons.share, widget.reel.shareCount),
        _buildActionButton(FontAwesomeIcons.bookmark, widget.reel.saveCount),
      ],
    );
  }

  /// Builds an individual action button with an icon and a count.
  Widget _buildActionButton(IconData icon, int count) {
    return IconButton(
      onPressed: () {},
      icon: Column(
        children: [
          FaIcon(
            icon,
            color: Colors.white,
            size: 35,
          ),
          const SizedBox(height: 4),
          if (count != 0)
            Text(
              '$count',
              style: const TextStyle(color: Colors.white),
            )
          else
            const Sizer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

/// ScrollingText creates a horizontally scrolling text widget.
class ScrollingText extends StatefulWidget {
  final String text;

  ScrollingText({super.key, required this.text});

  @override
  _ScrollingTextState createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.03;

    return ClipRect(
      child: Container(
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(_animation.value, 0),
              child: child,
            );
          },
          child: Text(
            widget.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontSize: textSize, color: AppColors.DARK_GRAY_COLOR),
          ),
        ),
      ),
    );
  }
}

/// RoundedButtonWithImage creates a small, rounded button with an image.
class RoundedButtonWithImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const RoundedButtonWithImage({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:
                const BorderSide(color: AppColors.PRIMARY_COLOR_DARK, width: 2),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imagePath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

// -----------------------1
