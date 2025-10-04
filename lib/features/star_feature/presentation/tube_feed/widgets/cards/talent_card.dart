import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';


import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../data/model/tube_video_models.dart';
import '../../../profile/widgets/playlist_bottom_sheet.dart';
import 'talent_card_info_section.dart';
import 'talent_card_overlay_controls.dart';
import '../../../../../../helpers/manage_vibration.dart';
import '../../../../domain/entity/star_entity.dart';
import '../../../presentation_exports.dart';

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
                        ? FeedVideoPlayer(
                            videoUrl: mediaUrl,
                            thumbnailUrl: thumbnailUrl,
                            autoPlay: true,
                            startMuted: true,
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

