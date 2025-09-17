import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../data/model/tube_video_models.dart';
import '../../../domain/entity/star_entity.dart';
import '../../controller/comment_cubit/comment_cubit.dart';
import '../../controller/playlist_cubit/playlist_cubit.dart';
import '../../controller/profile_cubit/profile_cubit.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../helper/youtube_style_video_player.dart';
import '../../pages/profile_page.dart';
import '../profile_components/playlist_bottom_sheet.dart';
import 'talent_card_info_section.dart';
import 'talent_card_overlay_controls.dart';
import '../common/options_bottom_sheet.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../social_media/twitter/presentation/widgets/report_view.dart';

// class VideoPlayerManager {
//   static VideoPlayerManager? _instance;
//   static VideoPlayerManager get instance {
//     _instance ??= VideoPlayerManager._();
//     return _instance!;
//   }

//   VideoPlayerManager._();

//   // Track all active controllers
//   final Map<String, VideoPlayerController> _controllers = {};
//   final int _maxConcurrentVideos = 2; // Limit concurrent videos

//   // Get or create controller with resource management
//   Future<VideoPlayerController?> getController(
//       String videoUrl, String videoId) async {
//     // Clean up excess controllers if needed
//     if (_controllers.length >= _maxConcurrentVideos) {
//       await _cleanupOldestController();
//     }

//     // Return existing controller if available
//     if (_controllers.containsKey(videoId)) {
//       return _controllers[videoId];
//     }

//     try {
//       final controller = VideoPlayerController.network(videoUrl);
//       await controller.initialize();
//       _controllers[videoId] = controller;
//       return controller;
//     } catch (e) {
//       print('Failed to create video controller: $e');
//       return null;
//     }
//   }

//   // Clean up oldest controller
//   Future<void> _cleanupOldestController() async {
//     if (_controllers.isEmpty) return;

//     final oldestKey = _controllers.keys.first;
//     final controller = _controllers[oldestKey];

//     if (controller != null) {
//       await controller.dispose();
//       _controllers.remove(oldestKey);
//     }
//   }

//   // Dispose specific controller
//   Future<void> disposeController(String videoId) async {
//     final controller = _controllers[videoId];
//     if (controller != null) {
//       await controller.dispose();
//       _controllers.remove(videoId);
//     }
//   }

//   // Dispose all controllers
//   Future<void> disposeAll() async {
//     for (final controller in _controllers.values) {
//       await controller.dispose();
//     }
//     _controllers.clear();
//   }
// }

class VideoPlayerManager {
  static VideoPlayerManager? _instance;
  static VideoPlayerManager get instance {
    _instance ??= VideoPlayerManager._();
    return _instance!;
  }

  VideoPlayerManager._();

  // Track all active controllers
  final Map<String, VideoPlayerController> _controllers = {};
  final int _maxConcurrentVideos = 2; // Limit concurrent videos

  // Get or create controller with resource management
  Future<VideoPlayerController?> getController(
      String videoUrl, String videoId) async {
    // Clean up excess controllers if needed
    if (_controllers.length >= _maxConcurrentVideos) {
      await _cleanupOldestController();
    }

    // Return existing controller if available
    if (_controllers.containsKey(videoId)) {
      return _controllers[videoId];
    }

    try {
      final controller = VideoPlayerController.network(videoUrl);
      await controller.initialize();
      _controllers[videoId] = controller;
      return controller;
    } catch (e) {
      print('Failed to create video controller: $e');
      return null;
    }
  }

  // Clean up oldest controller
  Future<void> _cleanupOldestController() async {
    if (_controllers.isEmpty) return;

    final oldestKey = _controllers.keys.first;
    final controller = _controllers[oldestKey];

    if (controller != null) {
      await controller.dispose();
      _controllers.remove(oldestKey);
    }
  }

  // Dispose specific controller
  Future<void> disposeController(String videoId) async {
    final controller = _controllers[videoId];
    if (controller != null) {
      await controller.dispose();
      _controllers.remove(videoId);
    }
  }

  // Dispose all controllers
  Future<void> disposeAll() async {
    for (final controller in _controllers.values) {
      await controller.dispose();
    }
    _controllers.clear();
  }
}

class TalentCard extends StatefulWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final bool isMyTalent;
  final Function(StarEntity, String)? onVideoTap;

  const TalentCard({
    super.key,
    required this.talent,
    required this.cubit,
    this.isMyTalent = false,
    this.onVideoTap,
  });

  @override
  State<TalentCard> createState() => _TalentCardState();
}

class _TalentCardState extends State<TalentCard> {
  bool _hasIncrementedView = false;

  // Use widget.cubit consistently throughout the widget
  StarCubit get cubit => widget.cubit;

  @override
  Widget build(BuildContext context) {
    final mediaUrl = _getVideoUrl();
    final thumbnailUrl = _getThumbnailUrl();
    final isVideo = _isVideoUrl(mediaUrl);

    return BlocBuilder<StarCubit, StarState>(
      builder: (context, starState) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          color: context.isDarkMode ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video/Image Section with Favorite Overlay
              GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  if (isVideo) {
                    _incrementViewIfNeeded();
                    _navigateToVideoPlayer(context, mediaUrl, widget.talent);
                  } else {
                    _navigateToProfile(context, widget.talent);
                  }
                },
                child: Stack(
                  children: [
                    // Video or Image Container
                    isVideo
                        ? TalentVideoPlayerWidget(
                            videoUrl: mediaUrl,
                            title: widget.talent.title,
                            autoPlay: true,
                            startMuted: true,
                            thumbnailUrl: thumbnailUrl,
                            talent: widget.talent,
                            cubit: widget.cubit,
                            onTap: () => _navigateToVideoPlayer(
                                context, mediaUrl, widget.talent),
                            onVideoStarted: () => _incrementViewIfNeeded(),
                          )
                        : _buildImageContainer(mediaUrl),

                    // Favorite Overlay (only for non-video content)
                    if (!isVideo)
                      TalentCardOverlayControls(
                        talent: widget.talent,
                        cubit: widget.cubit,
                        isPlaying: false,
                      ),
                  ],
                ),
              ),

              // Video Info Section with enhanced tube video info
              _buildVideoInfoSection(),

              // Delete Button for My Talents
              if (widget.isMyTalent) _buildDeleteButton(context, widget.talent),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoInfoSection() {
    return Column(
      children: [
        TalentCardInfoSection(
          talent: widget.talent,
          cubit: widget.cubit,
          onProfileTap: () => _navigateToProfile(context, widget.talent),
          onMoreOptionsTap: () {
            ManageVibration.vibrate();
            _showTubeVideoOptions(context, widget.talent);
          },
        ),
      ],
    );
  }

  Widget _buildImageContainer(String mediaUrl) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        image: mediaUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(mediaUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, StarEntity talent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _handleDeleteTalent(context, talent),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Delete Video',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  String _getVideoUrl() {
    if (_isTubeVideo()) {
      final tubeVideo = widget.talent as TubeVideoModel;
      return tubeVideo.videoUrl ?? '';
    }
    return widget.talent.mediaUrl.isNotEmpty
        ? widget.talent.mediaUrl.first.mediaKey
        : '';
  }

  String? _getThumbnailUrl() {
    if (_isTubeVideo()) {
      final tubeVideo = widget.talent as TubeVideoModel;
      return tubeVideo.thumbnail;
    }
    return "assets/images/testforvideo.jpg";
  }

  bool _isTubeVideo() {
    return widget.talent is TubeVideoModel;
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    if (duration.inHours > 0) {
      return "${duration.inHours}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
    } else {
      return "${duration.inMinutes}:${twoDigits(duration.inSeconds.remainder(60))}";
    }
  }

  void _incrementViewIfNeeded() {
    if (!_hasIncrementedView) {
      _hasIncrementedView = true;
      widget.cubit.incrementVideoView(widget.talent.id);
    }
  }

  // Navigation methods
  void _navigateToVideoPlayer(
    BuildContext context,
    String mediaUrl,
    StarEntity talent,
  ) {
    final starCubit = widget.cubit;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<StarCubit>.value(
              value: starCubit,
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
  }

  static void _navigateToProfile(BuildContext context, StarEntity talent) {
    // Get current user ID to determine if this is current user or another user
    final currentUserId = UserCubit.to.state.data?.id;

    // تحديد إذا كان المستخدم الحالي بناءً على ProfileEntity userId
    // سنحتاج لجلب ProfileEntity أولاً لمعرفة userId الصحيح

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<StarCubit>(),
          child: BlocProvider<ProfileCubit>(
            create: (context) {
              final profileCubit = serviceLocator<ProfileCubit>();

              // نبدأ بجلب البروفايل بناءً على الـ channel/profile ID
              // سنحتاج لمعرفة الـ profile ID من StarEntity أو talent.user.id
              profileCubit.getProfileById(talent.user.id);

              return profileCubit;
            },
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, profileState) {
                // لما يتحمل البروفايل، نتحقق من userId
                if (profileState.isSuccess && profileState.profile != null) {
                  final profileUserId = profileState.profile!.userId;
                  final isCurrentUser = currentUserId == profileUserId;

                  print("🔍 Profile Navigation Debug:");
                  print("   Current User ID: $currentUserId");
                  print("   Profile User ID: $profileUserId");
                  print("   Is Current User: $isCurrentUser");
                }
              },
              builder: (context, profileState) {
                // تحديد إذا كان المستخدم الحالي بناءً على ProfileEntity
                bool isCurrentUser = false;
                if (profileState.profile != null) {
                  isCurrentUser = currentUserId == profileState.profile!.userId;
                } else {
                  // fallback للطريقة القديمة لحين تحميل البروفايل
                  isCurrentUser = currentUserId == talent.user.id;
                }

                return ProfilePageView(
                  user: talent.user,
                  userVideos: [], // Start with empty, will be loaded dynamically
                  isCurrentUser: isCurrentUser,
                  profileId: talent.user.id, // channel/profile ID
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleDeleteTalent(BuildContext context, StarEntity talent) {
    showAreYouSure(
      context: context,
      title: LocaleKeys.alert.localize,
      subTitle: LocaleKeys.remove.localize,
      action: () {
        cubit.deleteMyTubeVideo(talent.id);
        Navigator.pop(context);
      },
    );
  }

  // void _showTubeVideoOptions(BuildContext context, StarEntity talent) {
  //   final cubit = context.read<StarCubit>();

  //   OptionsBottomSheet.showOptions(
  //     context: context,
  //     options: [
  //       OptionItem(
  //         icon: Icons.playlist_add,
  //         title: context.isArabic ? 'إنشاء قائمة' : 'Add to playlist',
  //         onTap: () {
  //           ManageVibration.vibrate();
  //           Navigator.pop(context);
  //         },
  //       ),
  //       OptionItem(
  //         icon: cubit.isFavorite(talent.id)
  //             ? Icons.favorite
  //             : Icons.favorite_border,
  //         title: cubit.isFavorite(talent.id)
  //             ? (context.isArabic
  //                 ? 'إزالة من المفضلة'
  //                 : 'Remove from favorites')
  //             : (context.isArabic ? 'إضافة للمفضلة' : 'Add to favorites'),
  //         onTap: () {
  //           ManageVibration.vibrate();
  //           Navigator.pop(context);
  //           cubit.toggleFavorite(talent.id);
  //         },
  //       ),
  //       if (_isTubeVideo()) ...[
  //         OptionItem(
  //           icon: Icons.share,
  //           title: context.isArabic ? 'مشاركة' : 'Share',
  //           onTap: () {
  //             ManageVibration.vibrate();
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //       OptionItem(
  //         icon: Icons.flag,
  //         title: context.isArabic ? 'ابلاغ' : 'Report',
  //         iconColor: Colors.red,
  //         textColor: Colors.red,
  //         onTap: () {
  //           ManageVibration.vibrate();
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ],
  //   );
  // }

  void _showTubeVideoOptions(BuildContext context, StarEntity talent) {
    // Use the widget's cubit parameter

    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.playlist_add,
          title: context.isArabic ? 'إضافة إلى قائمة تشغيل' : 'Add to playlist',
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
            _showPlaylistBottomSheet(context, talent);
          },
        ),
        OptionItem(
          icon: cubit.isFavorite(talent.id)
              ? Icons.favorite
              : Icons.favorite_border,
          title: cubit.isFavorite(talent.id)
              ? (context.isArabic
                  ? 'إزالة من المفضلة'
                  : 'Remove from favorites')
              : (context.isArabic ? 'إضافة للمفضلة' : 'Add to favorites'),
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
            cubit.toggleFavorite(talent.id);
          },
        ),
        if (_isTubeVideo()) ...[
          OptionItem(
            icon: Icons.share,
            title: context.isArabic ? 'مشاركة' : 'Share',
            onTap: () {
              ManageVibration.vibrate();
              Navigator.pop(context);
              _shareVideo(context, talent);
            },
          ),
          (() {
            final isWatchLater = cubit.isWatchLater(talent.id);
            return OptionItem(
              icon:
                  isWatchLater ? Icons.watch_later : Icons.watch_later_outlined,
              title: context.isArabic
                  ? (isWatchLater
                      ? 'إزالة من المشاهدة لاحقاً'
                      : 'مشاهدة لاحقاً')
                  : (isWatchLater ? 'Remove from Watch Later' : 'Watch Later'),
              onTap: () {
                ManageVibration.vibrate();
                Navigator.pop(context);
                _addToWatchLater(context, talent);
              },
            );
          })(),
        ],
        OptionItem(
          icon: Icons.flag,
          title: context.isArabic ? 'ابلاغ' : 'Report',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
            _reportVideo(context, talent);
          },
        ),
      ],
    );
  }

// Helper method to show playlist bottom sheet
  void _showPlaylistBottomSheet(BuildContext context, StarEntity talent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: PlaylistBottomSheet(video: talent),
      ),
    );
  }

// Helper methods for other options
  void _shareVideo(BuildContext context, StarEntity talent) {
    // Implement share functionality
    showSuccessMessage(
      context,
      context.isArabic ? 'تم مشاركة الفيديو' : 'Video shared',
    );
  }

  void _downloadVideo(BuildContext context, StarEntity talent) {
    // Implement download functionality
    showSuccessMessage(
      context,
      context.isArabic ? 'بدء تحميل الفيديو' : 'Download started',
      color: Colors.blue,
      icon: Icons.download,
    );
  }

  void _addToWatchLater(BuildContext context, StarEntity talent) {
    print("🎬 Adding video to watch later: ${talent.id}");
    print("🎬 Cubit instance: ${cubit.runtimeType}");

    // Call the cubit to toggle watch later
    cubit.toggleWatchLater(talent.id);
  }

  void _reportVideo(BuildContext context, StarEntity talent) {
    bottomSheet(
      context: context,
      widget: ReportView(
        id: talent.id,
        categoryId: talent.user.id, // Using user id as category id
      ),
    );
  }

  bool _isVideoUrl(String url) {
    return url.toLowerCase().contains('.mp4') ||
        url.toLowerCase().contains('.mov') ||
        url.toLowerCase().contains('.avi') ||
        url.toLowerCase().contains('.m3u8');
  }
}

// Custom Video Player Widget for TalentCard
class TalentVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String title;
  final bool autoPlay;
  final bool startMuted;
  final VoidCallback? onTap;
  final String? thumbnailUrl;
  final StarEntity? talent;
  final StarCubit cubit;
  final VoidCallback? onVideoStarted;

  const TalentVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.title,
    this.autoPlay = false,
    this.startMuted = true,
    this.onTap,
    this.thumbnailUrl,
    this.talent,
    required this.cubit,
    this.onVideoStarted,
  });

  @override
  State<TalentVideoPlayerWidget> createState() =>
      _TalentVideoPlayerWidgetState();
}

class _TalentVideoPlayerWidgetState extends State<TalentVideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showControls = true;
  double _visibilityFraction = 0;
  bool _hasTrackedView = false;
  bool _isDisposed = false;

  Timer? _playDelayTimer;
  Timer? _initTimer;

  String get videoId => '${widget.talent?.id ?? widget.videoUrl.hashCode}';

  @override
  void initState() {
    super.initState();
    _isMuted = widget.startMuted;
    // Don't initialize immediately, wait for visibility
  }

  Future<void> _initializeVideo() async {
    if (_isInitializing || _isDisposed || _controller != null) return;

    setState(() {
      _isInitializing = true;
    });

    try {
      final controller = await VideoPlayerManager.instance.getController(
        widget.videoUrl,
        videoId,
      );

      if (controller != null && mounted && !_isDisposed) {
        _controller = controller;
        _controller!.setVolume(_isMuted ? 0 : 1);
        _controller!.setLooping(false);
        _controller!.addListener(_videoListener);

        setState(() {
          _isInitialized = true;
          _isInitializing = false;
        });

        // Auto-play immediately after initialization if widget.autoPlay is true
        if (widget.autoPlay && _visibilityFraction > 0.3) {
          await Future.delayed(Duration(milliseconds: 100));
          if (mounted &&
              !_isDisposed &&
              _controller != null &&
              _controller!.value.isInitialized &&
              !_controller!.value.isPlaying) {
            _controller!.play();
            setState(() => _isPlaying = true);
            _trackVideoStart();
          }
        }
      }
    } catch (error) {
      print('Video initialization error: $error');
      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialized = false;
          _isInitializing = false;
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted || _isDisposed || _controller == null) return;

    try {
      final isPlaying = _controller!.value.isPlaying;
      if (isPlaying != _isPlaying) {
        if (mounted && !_isDisposed) {
          setState(() {
            _isPlaying = isPlaying;
          });

          if (isPlaying && !_hasTrackedView) {
            _trackVideoStart();
          }
        }
      }

      // Check if video has ended and handle auto-next
      if (_controller!.value.position >= _controller!.value.duration &&
          _controller!.value.duration.inMilliseconds > 0) {
        _handleVideoEnd();
      }
    } catch (e) {
      // Handle any errors gracefully
      print('Error in video listener: $e');
      if (mounted && !_isDisposed) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  void _trackVideoStart() {
    if (!_hasTrackedView) {
      _hasTrackedView = true;
      widget.onVideoStarted?.call();
    }
  }

  void _handleVideoEnd() {
    // Video ended - just reset to beginning for now
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.seekTo(Duration.zero);
      _controller!.pause();
      setState(() => _isPlaying = false);
    }
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized || _isDisposed || !mounted)
      return;
    if (!_controller!.value.isInitialized) return;

    try {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
        if (!_hasTrackedView) {
          _trackVideoStart();
        }
      }
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller?.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleFavorite() {
    if (widget.talent != null) {
      widget.cubit.toggleFavorite(widget.talent!.id);
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    if (_isDisposed) return;

    _visibilityFraction = info.visibleFraction;

    // Cancel timers
    _playDelayTimer?.cancel();
    _initTimer?.cancel();

    if (info.visibleFraction > 0.3) {
      // Lower threshold for better UX
      // Visible - initialize if needed
      if (!_isInitialized && !_isInitializing) {
        _initTimer = Timer(Duration(milliseconds: 200), () {
          if (mounted && !_isDisposed && _visibilityFraction > 0.3) {
            _initializeVideo();
          }
        });
      } else if (_isInitialized && widget.autoPlay && !_isPlaying) {
        // Auto-play if initialized with shorter delay
        _playDelayTimer = Timer(Duration(milliseconds: 300), () {
          if (mounted &&
              !_isDisposed &&
              _controller != null &&
              _controller!.value.isInitialized &&
              !_controller!.value.isPlaying &&
              _visibilityFraction > 0.3) {
            _controller!.play();
            setState(() => _isPlaying = true);
            _trackVideoStart();
          }
        });
      }
    } else if (info.visibleFraction < 0.2) {
      // Adjusted threshold
      // Not visible - pause and potentially dispose
      if (_controller != null &&
          _controller!.value.isInitialized &&
          _controller!.value.isPlaying) {
        _controller!.pause();
        setState(() => _isPlaying = false);
      }

      // Dispose if completely out of view
      if (info.visibleFraction == 0) {
        _disposeController();
      }
    }
  }

  Future<void> _disposeController() async {
    if (_controller != null && !_isDisposed) {
      try {
        _controller!.removeListener(_videoListener);
      } catch (e) {
        // Ignore errors if already disposed
        print('Error removing video listener: $e');
      }

      // Don't dispose from manager yet, let it handle resource management
      // Just remove our reference
      _controller = null;

      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialized = false;
          _isPlaying = false;
        });
      }
    }
  }

  Widget _buildThumbnail() {
    if (widget.thumbnailUrl != null &&
        widget.thumbnailUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: widget.thumbnailUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: Icon(Icons.video_library, size: 48, color: Colors.grey[600]),
        ),
        errorWidget: (context, url, error) => _buildFallbackThumbnail(),
      );
    }
    return _buildFallbackThumbnail();
  }

  Widget _buildFallbackThumbnail() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child:
            Icon(Icons.play_circle_outline, size: 64, color: Colors.grey[600]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.talent != null
        ? widget.cubit.isFavorite(widget.talent!.id)
        : false;

    return VisibilityDetector(
      key: Key('video-$videoId'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          if (_isInitialized) {
            setState(() => _showControls = !_showControls);
          }
          widget.onTap?.call();
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Thumbnail (always show when not playing)
              if (!_isPlaying) Positioned.fill(child: _buildThumbnail()),

              // Video Player (only when initialized)
              if (_isInitialized &&
                  _controller != null &&
                  !_isDisposed &&
                  mounted)
                AnimatedOpacity(
                  opacity: _isPlaying ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: _controller != null &&
                            _controller!.value.isInitialized &&
                            !_isDisposed
                        ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black,
                          ),
                  ),
                ),

              // Loading Indicator (only when initializing)
              if (_isInitializing)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),

              // Play button overlay (only when initialized but not playing)
              // if (_isInitialized && !_isPlaying && !_isInitializing)
              //   Center(
              //     child: Container(
              //       padding: EdgeInsets.all(16),
              //       decoration: BoxDecoration(
              //         color: Colors.black.withOpacity(0.6),
              //         shape: BoxShape.circle,
              //       ),
              //       child:
              //           Icon(Icons.play_arrow, color: Colors.white, size: 40),
              //     ),
              //   ),

              // Favorite button
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Color(0xffFF0000),
                      size: 20,
                    ),
                    onPressed: _toggleFavorite,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),

              // Mute button (only when playing)
              if (_isInitialized && _isPlaying)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _toggleMute,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _playDelayTimer?.cancel();
    _initTimer?.cancel();

    // Cancel any pending async operations
    try {
      _disposeController();
    } catch (e) {
      print('Error during controller disposal: $e');
    }

    super.dispose();
  }
}
