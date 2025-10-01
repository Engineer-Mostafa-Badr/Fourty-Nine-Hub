import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

import '../../../../../service_locator/service_locator.dart';
import '../../../data/model/tube_video_models.dart';
import '../../controller/comment_cubit/comment_cubit.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../shared/widgets/common/loading_indicator.dart';
import '../../tube_feed/widgets/cards/talent_card.dart';
import '../../presentation_exports.dart';


import 'playlist_bottom_sheet.dart';
import 'video/video_card_widget.dart';

class ProfileHomeTab extends StatefulWidget {
  final List<StarEntity> videos; // fallback data
  final bool isCurrentUser;
  final String? userId;

  const ProfileHomeTab({
    super.key,
    required this.videos,
    required this.isCurrentUser,
    this.userId,
  });

  @override
  State<ProfileHomeTab> createState() => _ProfileHomeTabState();
}

class _ProfileHomeTabState extends State<ProfileHomeTab> {
  late StarCubit _starCubit;

  @override
  void initState() {
    super.initState();
    _starCubit = context.read<StarCubit>();

    // Load appropriate videos based on user type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isCurrentUser) {
        // For current user, load all available content for "For You" section
        _starCubit.loadTalents(TalentCategory.available, refresh: true);
        // And load user's own videos for "New Songs" section
        _starCubit.loadTalents(TalentCategory.myTalents, refresh: true);
      } else {
        // For other users, load all available content
        _starCubit.loadTalents(TalentCategory.available, refresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        print(
            "📺 ProfileHomeTab Build - Available: ${state.availableTalents.length}, MyTalents: ${state.myTalents.length}");
        print("📺 Widget videos fallback: ${widget.videos.length}");
        print("📺 Is current user: ${widget.isCurrentUser}");
        if (state.status == StarStates.loading &&
            state.availableTalents.isEmpty &&
            (widget.isCurrentUser ? state.myTalents.isEmpty : true)) {
          return Center(
            child: StarLoadingIndicator(message: 'Loading videos...'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // For You Section - Show available content
              _buildSectionHeader(
                context,
                context.isArabic ? 'لك' : 'For You',
              ),
              _buildForYouSection(context, state),

              SizedBox(height: _getResponsiveSpacing(context, 24)),

              // User-specific content section
              if (widget.isCurrentUser) ...[
                // Current user's own videos
                _buildSectionHeader(
                  context,
                  context.isArabic ? 'فيديوهاتي' : 'My Videos',
                ),
                _buildMyVideosSection(context, state),
              ] else ...[
                // Other user's videos from profile
                _buildSectionHeader(
                  context,
                  context.isArabic ? 'فيديوهات المستخدم' : 'User Videos',
                ),
                _buildUserVideosSection(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, String message, String? subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: _getResponsivePadding(context, 20),
        right: _getResponsivePadding(context, 20),
        top: _getResponsivePadding(context, 20),
        bottom: _getResponsivePadding(context, 16),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: _getResponsiveFontSize(context, 22),
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildForYouSection(BuildContext context, StarState state) {
    final forYouVideos = state.availableTalents.take(10).toList();

    if (forYouVideos.isEmpty) {
      return SizedBox(
        height: 200,
        child: _buildEmptyState(
          context,
          context.isArabic ? 'لا توجد فيديوهات متاحة' : 'No videos available',
          null,
        ),
      );
    }

    return SizedBox(
      height: _getVideoCardHeight(context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: _getResponsivePadding(context, 20)),
        itemCount: forYouVideos.length,
        itemBuilder: (context, index) {
          final video = forYouVideos[index] as TubeVideoModel;
          return Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: EdgeInsets.only(right: _getResponsiveSpacing(context, 12)),
            child: VideoCardWidget(
              video: video,
              index: index,
              isHorizontal: true,
              starCubit: _starCubit,
              onTap: () => _navigateToVideo(context, video),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyVideosSection(BuildContext context, StarState state) {
    final myVideos = state.myTalents.take(8).toList();

    if (state.isLoading(TalentCategory.myTalents) && myVideos.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
            child: StarLoadingIndicator(message: 'Loading your videos...')),
      );
    }

    if (myVideos.isEmpty && !state.isLoading(TalentCategory.myTalents)) {
      return SizedBox(
        height: 200,
        child: _buildEmptyState(
          context,
          context.isArabic ? 'لا توجد فيديوهات بعد' : 'No videos yet',
          context.isArabic
              ? 'ابدأ في رفع أول فيديو لك'
              : 'Start uploading your first video',
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: myVideos.length,
      itemBuilder: (context, index) {
        final video = myVideos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: _getResponsiveSpacing(context, 16)),
          child: TalentCard(
            talent: video,
            cubit: _starCubit,
            isMyTalent: true,
          ),
        );
      },
    );
  }

  Widget _buildUserVideosSection(BuildContext context) {
    // Use actual user videos from fallback data
    final userVideos = widget.videos;

    if (userVideos.isEmpty) {
      return SizedBox(
        height: 200,
        child: _buildEmptyState(
          context,
          context.isArabic ? 'لا توجد فيديوهات' : 'No videos',
          null,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: userVideos.length,
      itemBuilder: (context, index) {
        final video = userVideos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: _getResponsiveSpacing(context, 16)),
          child: TalentCard(
            talent: video,
            cubit: _starCubit,
          ),
        );
      },
    );
  }

  void _navigateToVideo(BuildContext context, StarEntity video) {
    // Check if video is approved/available
    if (!video.isApproved) {
      // Show message that video is not available yet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'تم رفع الفيديو بنجاح!\n\nملاحظة: الفيديو غير متاح حالياً. البث المباشر أو ملف الفيديو غير جاهز بعد. يحتاج وقت ليصبح متاحاً للمستخدمين.'
                : 'Video uploaded successfully!\n\nNote: Video is not currently available. The live stream or video file are not yet ready. It takes time before it becomes available to users.',
          ),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.orange[700],
        ),
      );
      return;
    }

    final mediaUrl =
        video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<StarCubit>.value(
              value: _starCubit, // استخدام نفس ال cubit instance
            ),
            BlocProvider<CommentCubit>(
              create: (context) => serviceLocator<CommentCubit>(),
            ),
          ],
          child: TalentVideoPlayer(
            videoUrl: mediaUrl,
            talent: video,
          ),
        ),
      ),
    );
  }

  void _showPlaylistBottomSheet(BuildContext context, StarEntity video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider(
        create: (context) => serviceLocator<PlaylistCubit>(),
        child: PlaylistBottomSheet(video: video),
      ),
    );
  }

  // Helper methods for responsive design
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 400) {
      return basePadding * 1.15;
    }
    return basePadding;
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    return baseSpacing;
  }

  double _getVideoCardHeight(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.85;
    return cardWidth * 0.75;
  }
}
