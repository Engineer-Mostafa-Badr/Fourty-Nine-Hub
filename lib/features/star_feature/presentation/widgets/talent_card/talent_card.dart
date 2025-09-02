import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

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

class TalentCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
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
              isVideo
                  ? _navigateToVideoPlayer(context, mediaUrl, talent)
                  : _navigateToProfile(context, talent);
            },
            child: Stack(
              children: [
                // Video or Image Container
                isVideo
                    ? YouTubeStyleVideoPlayer(
                        videoUrl: mediaUrl,
                        title: talent.title,
                        autoPlay: true,
                        startMuted: true,
                        thumbnailUrl: "assets/images/testforvideo.jpg",
                        talent: talent,
                        onTap: () => _navigateToProfile(context, talent),
                      )
                    : _buildImageContainer(mediaUrl),

                // Favorite Overlay (only for non-video content)
                if (!isVideo)
                  TalentCardOverlayControls(
                    talent: talent,
                    cubit: cubit,
                    isPlaying: false,
                  ),
              ],
            ),
          ),

          // Video Info Section
          TalentCardInfoSection(
            talent: talent,
            cubit: cubit,
            onProfileTap: () => _navigateToProfile(context, talent),
            onMoreOptionsTap: () => _showYouTubeOptions(context, talent),
          ),

          // Delete Button for My Talents
          if (isMyTalent) _buildDeleteButton(context, talent),
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
            'Delete Talent', // Use LocaleKeys if needed
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

  // Navigation methods
  static void _navigateToVideoPlayer(
    BuildContext context,
    String mediaUrl,
    StarEntity talent,
  ) {
    // Implementation
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
            // Show report dialog
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
