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
  }

  Widget _buildVideoInfoSection() {
    return Column(
      children: [
        TalentCardInfoSection(
          talent: widget.talent,
          cubit: widget.cubit,
          onProfileTap: () => _navigateToProfile(context, widget.talent),
          onMoreOptionsTap: () => _showTubeVideoOptions(context, widget.talent),
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
          OptionItem(
            icon: Icons.download,
            title: context.isArabic ? 'تحميل' : 'Download',
            onTap: () {
              ManageVibration.vibrate();
              Navigator.pop(context);
              _downloadVideo(context, talent);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.isArabic ? 'تم مشاركة الفيديو' : 'Video shared',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadVideo(BuildContext context, StarEntity talent) {
    // Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.isArabic ? 'بدء تحميل الفيديو' : 'Download started',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _addToWatchLater(BuildContext context, StarEntity talent) {
    print("🎬 Adding video to watch later: ${talent.id}");
    print("🎬 Cubit instance: ${cubit.runtimeType}");

    // Call the cubit to toggle watch later
    cubit.toggleWatchLater(talent.id);
  }

  void _reportVideo(BuildContext context, StarEntity talent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'الإبلاغ عن الفيديو' : 'Report Video',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          context.isArabic
              ? 'هل تريد الإبلاغ عن هذا الفيديو لانتهاكه قواعد المجتمع؟'
              : 'Do you want to report this video for violating community guidelines?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic
                        ? 'تم الإبلاغ عن الفيديو'
                        : 'Video reported',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'إبلاغ' : 'Report'),
          ),
        ],
      ),
    );
  }

  static bool _isVideoUrl(String url) {
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
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showControls = true;
  double _visibilityFraction = 0;
  bool _hasTrackedView = false;

  Timer? _playDelayTimer;
  Timer? _pauseDelayTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _isMuted = widget.startMuted;
            _controller.setVolume(_isMuted ? 0 : 1);
          });
        }
      });

    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });

      if (_controller.value.isPlaying && !_hasTrackedView) {
        _trackVideoStart();
      }
    }
  }

  void _trackVideoStart() {
    if (!_hasTrackedView) {
      _hasTrackedView = true;
      widget.onVideoStarted?.call();
    }
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
      if (!_hasTrackedView) {
        _trackVideoStart();
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleFavorite() {
    if (widget.talent != null) {
      widget.cubit.toggleFavorite(widget.talent!.id);
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    _visibilityFraction = info.visibleFraction;

    if (!_isInitialized) return;

    _playDelayTimer?.cancel();
    _pauseDelayTimer?.cancel();

    if (info.visibleFraction > 0.5) {
      if (!_controller.value.isPlaying && widget.autoPlay) {
        _playDelayTimer = Timer(Duration(milliseconds: 600), () {
          if (mounted &&
              !_controller.value.isPlaying &&
              _visibilityFraction > 0.5 &&
              widget.autoPlay) {
            _controller.play();
            setState(() => _isPlaying = true);
            _trackVideoStart();
          }
        });
      }
    } else {
      if (_controller.value.isPlaying) {
        _controller.pause();
        setState(() => _isPlaying = false);
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
          child: Icon(
            Icons.video_library,
            size: 48,
            color: Colors.grey[600],
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/testforvideo.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Image.asset(
      widget.thumbnailUrl ?? 'assets/images/testforvideo.jpg',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.talent != null
        ? widget.cubit.isFavorite(widget.talent!.id)
        : false;

    return VisibilityDetector(
      key: Key('video-${widget.videoUrl}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          setState(() => _showControls = !_showControls);
          widget.onTap?.call();
        },
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.3,
          width: double.infinity,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Thumbnail
              if (widget.thumbnailUrl != null && !_isPlaying)
                Positioned.fill(
                  child: _buildThumbnail(),
                ),

              // Video Player
              if (_isInitialized)
                AnimatedOpacity(
                  opacity: _isPlaying ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),

              // Loading Indicator
              if (!_isInitialized)
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),

              // Play button overlay when paused
              // if (_isInitialized && !_isPlaying)
              //   Center(
              //     child: GestureDetector(
              //       onTap: _togglePlayPause,
              //       child: Container(
              //         padding: EdgeInsets.all(16),
              //         decoration: BoxDecoration(
              //           color: Colors.black.withOpacity(0.7),
              //           shape: BoxShape.circle,
              //         ),
              //         child: Icon(
              //           Icons.play_arrow,
              //           color: Colors.white,
              //           size: 32,
              //         ),
              //       ),
              //     ),
              //   ),

              // Top Left Controls (Favorite)
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
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      color: Color(0xffFF0000),
                      size: 20,
                    ),
                    onPressed: _toggleFavorite,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),

              // Top Right Controls (Mute) - only when playing
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
    _playDelayTimer?.cancel();
    _pauseDelayTimer?.cancel();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }
}
