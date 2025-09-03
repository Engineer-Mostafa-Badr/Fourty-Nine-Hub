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
import '../../../domain/entity/star_entity.dart';
import '../../controller/profile_cubit/profile_cubit.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../helper/youtube_style_video_player.dart';
import '../../pages/profile_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final mediaUrl = widget.talent.mediaUrl.isNotEmpty
        ? widget.talent.mediaUrl.first.mediaKey
        : '';
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
                // تسجيل المشاهدة عند النقر على الفيديو
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
                    ? YouTubeStyleVideoPlayerWithTracking(
                        videoUrl: mediaUrl,
                        title: widget.talent.title,
                        autoPlay: true,
                        startMuted: true,
                        thumbnailUrl: "assets/images/testforvideo.jpg",
                        talent: widget.talent,
                        onTap: () => _navigateToProfile(context, widget.talent),
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

          // Video Info Section
          TalentCardInfoSection(
            talent: widget.talent,
            cubit: widget.cubit,
            onProfileTap: () => _navigateToProfile(context, widget.talent),
            onMoreOptionsTap: () => _showYouTubeOptions(context, widget.talent),
          ),

          // Delete Button for My Talents
          if (widget.isMyTalent) _buildDeleteButton(context, widget.talent),
        ],
      ),
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
            'Delete Talent',
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

  // تسجيل المشاهدة مرة واحدة فقط
  void _incrementViewIfNeeded() {
    if (!_hasIncrementedView) {
      _hasIncrementedView = true;
      // استدعاء API تسجيل المشاهدة
      widget.cubit.incrementVideoView(widget.talent.id);
    }
  }

  // Navigation methods
  static void _navigateToVideoPlayer(
    BuildContext context,
    String mediaUrl,
    StarEntity talent,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TalentVideoPlayer(
          videoUrl: mediaUrl,
          talent: talent,
        ),
      ),
    );
  }

  static void _navigateToProfile(BuildContext context, StarEntity talent) {
    final mockVideos = List.generate(
      10,
      (index) => StarEntity(
        id: '${talent.id}_mock_$index',
        title: '${talent.title} - Part ${index + 1}',
        description: 'Mock video ${index + 1}',
        user: talent.user,
        mediaUrl: talent.mediaUrl,
        totalViews: talent.totalViews + (index * 1000),
        averageRating: talent.averageRating,
        isApproved: talent.isApproved,
        haveStories: talent.haveStories,
        storyCount: talent.storyCount,
        createdAt: DateTime.now().subtract(Duration(days: index * 30)),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<ProfileCubit>(
          create: (context) => serviceLocator<ProfileCubit>()..getMyProfile(),
          child: ProfilePageView(
            user: talent.user,
            userVideos: mockVideos,
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
        context.read<StarCubit>().deleteMyTalent(id: talent.id);
        Navigator.pop(context);
      },
    );
  }

  void _showYouTubeOptions(BuildContext context, StarEntity talent) {
    final cubit = context.read<StarCubit>();
    OptionsBottomSheet.showOptions(
      context: context,
      options: [
        OptionItem(
          icon: Icons.playlist_add,
          title: context.isArabic ? 'إنشاء قائمة' : 'Play next in queue',
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
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
        OptionItem(
          icon: Icons.flag,
          title: context.isArabic ? 'ابلاغ' : 'Report',
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  static bool _isVideoUrl(String url) {
    return url.toLowerCase().contains('.mp4') ||
        url.toLowerCase().contains('.mov') ||
        url.toLowerCase().contains('.avi') ||
        url.toLowerCase().contains('.m3u8');
  }
}

// Wrapper للـ YouTubeStyleVideoPlayer مع تتبع المشاهدات
class YouTubeStyleVideoPlayerWithTracking extends YouTubeStyleVideoPlayer {
  final VoidCallback? onVideoStarted;

  const YouTubeStyleVideoPlayerWithTracking({
    super.key,
    required super.videoUrl,
    required super.title,
    super.autoPlay = false,
    super.startMuted = true,
    super.onTap,
    super.showLiveIndicator = false,
    super.thumbnailUrl,
    super.talent,
    this.onVideoStarted,
  });

  @override
  State<YouTubeStyleVideoPlayer> createState() =>
      _YouTubeStyleVideoPlayerWithTrackingState();
}

class _YouTubeStyleVideoPlayerWithTrackingState
    extends State<YouTubeStyleVideoPlayerWithTracking> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _showControls = true;
  bool _isDragging = false;
  double _visibilityFraction = 0;
  bool _hasTrackedView = false;

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

          if (widget.autoPlay && _visibilityFraction > 0.5) {
            _controller.play();
            setState(() => _isPlaying = true);
            _trackVideoStart();
          }
        }
      });

    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });

      // تتبع بداية تشغيل الفيديو
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
      context.read<StarCubit>().toggleFavorite(widget.talent!.id);
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    _visibilityFraction = info.visibleFraction;

    if (!_isInitialized) return;

    if (info.visibleFraction > 0.5) {
      if (!_controller.value.isPlaying && widget.autoPlay) {
        _controller.play();
        setState(() => _isPlaying = true);
        _trackVideoStart();
      }
    } else {
      if (_controller.value.isPlaying) {
        _controller.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  void _seekToPosition(double localX) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && _controller.value.duration.inMilliseconds > 0) {
      final position = (localX / renderBox.size.width).clamp(0.0, 1.0);
      final duration = _controller.value.duration;
      final newPosition = Duration(
        milliseconds: (position * duration.inMilliseconds).round(),
      );
      _controller.seekTo(newPosition);
    }
  }

  void _openFullVideoPlayer() {
    if (widget.talent != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TalentVideoPlayer(
            videoUrl: widget.videoUrl,
            talent: widget.talent!,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.videoUrl}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: BlocBuilder<StarCubit, StarState>(
        builder: (context, state) {
          final cubit = context.read<StarCubit>();
          final isFavorite = widget.talent != null
              ? cubit.isFavorite(widget.talent!.id)
              : false;

          return GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              setState(() => _showControls = !_showControls);
              widget.onTap?.call();
              _openFullVideoPlayer();
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
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.thumbnailUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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

                  // Top Left Controls (Favorite)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isPlaying
                              ? Colors.black12
                              : Color(0xffD9D9D9).withValues(alpha: .5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: Color(0xffFF0000),
                            size: 25,
                          ),
                          onPressed: _toggleFavorite,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ),

                  // Top Right Controls (Mute)
                  if (_isInitialized)
                    Positioned(
                      top: 10,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isPlaying
                              ? Colors.black12
                              : Color(0xffD9D9D9).withValues(alpha: .5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: _isPlaying ? Colors.white : Colors.black,
                            size: 25,
                          ),
                          onPressed: _toggleMute,
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),

                  // Bottom Right Controls (Remaining Time)
                  if (_isInitialized)
                    Positioned(
                      bottom: _isPlaying || _isDragging ? 18 : 10,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: _controller,
                          builder: (context, value, child) {
                            if (!_isPlaying && !_isDragging) {
                              return Text(
                                _formatDuration(value.duration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            } else {
                              final remainingTime =
                                  value.duration - value.position;
                              return Text(
                                _formatDuration(remainingTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                  // Progress Bar
                  if (_isInitialized && (_isPlaying || _isDragging))
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTapDown: (details) {
                          _seekToPosition(details.localPosition.dx);
                        },
                        onPanUpdate: (details) {
                          _seekToPosition(details.localPosition.dx);
                        },
                        onPanStart: (details) {
                          setState(() {
                            _isDragging = true;
                          });
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          }
                        },
                        onPanEnd: (details) {
                          setState(() {
                            _isDragging = false;
                          });
                          if (_isPlaying) {
                            _controller.play();
                          }
                        },
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              // Progress Bar Background
                              Container(
                                height: 4,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              // Progress Bar Fill
                              ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: _controller,
                                builder: (context, value, child) {
                                  final progress =
                                      value.duration.inMilliseconds > 0
                                          ? value.position.inMilliseconds /
                                              value.duration.inMilliseconds
                                          : 0.0;
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 4,
                                      width: MediaQuery.of(context).size.width *
                                          progress.clamp(0.0, 1.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Progress Indicator Circle
                              ValueListenableBuilder<VideoPlayerValue>(
                                valueListenable: _controller,
                                builder: (context, value, child) {
                                  final progress =
                                      value.duration.inMilliseconds > 0
                                          ? value.position.inMilliseconds /
                                              value.duration.inMilliseconds
                                          : 0.0;
                                  final clampedProgress =
                                      progress.clamp(0.0, 1.0);
                                  return Positioned(
                                    left: (MediaQuery.of(context).size.width *
                                            clampedProgress) -
                                        5,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
