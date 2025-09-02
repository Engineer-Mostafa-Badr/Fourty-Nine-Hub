import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

import '../common/thumbnail_widget.dart';
import 'video/video_card_widget.dart';
import 'video/video_list_item.dart';

class ProfileHomeTab extends StatelessWidget {
  final List<StarEntity> videos;

  const ProfileHomeTab({
    super.key,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return _buildEmptyState(context);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For You Section - Horizontal Scroll
          _buildSectionHeader(
            context,
            context.isArabic ? 'لك' : 'For You',
          ),

          _buildHorizontalVideoSection(context),

          SizedBox(height: _getResponsiveSpacing(context, 24)),

          // New Content Section - Vertical Scroll
          _buildSectionHeader(
            context,
            context.isArabic ? 'أغنية جديدة 2020' : 'New Song 2020',
          ),

          _buildVerticalVideoSection(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            context.isArabic ? 'لا توجد فيديوهات' : 'No videos yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
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

  Widget _buildHorizontalVideoSection(BuildContext context) {
    return SizedBox(
      height: _getVideoCardHeight(context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: _getResponsivePadding(context, 20)),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: EdgeInsets.only(right: _getResponsiveSpacing(context, 12)),
            child: _buildSimpleVideoCard(context, video, index),
          );
        },
      ),
    );
  }

// إضافة هذه الدالة
  Widget _buildSimpleVideoCard(
      BuildContext context, StarEntity video, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Thumbnail بدون الـ favorite button المحتاج للـ StarCubit
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ThumbnailWidget(
              imageUrl: video.mediaUrl.isNotEmpty
                  ? video.mediaUrl.first.mediaKey
                  : null,
              width: double.infinity,
              height: double.infinity,
              duration: '7:54',
              showVolumeIcon: true,
              onTap: () => _navigateToVideo(context, video),
            ),
          ),
        ),
        SizedBox(height: 12),
        // Video Info بدون الـ options والـ rating
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6),
              Text(
                "${video.user.firstName} ${video.user.lastName}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToVideo(BuildContext context, StarEntity video) {
    final mediaUrl =
        video.mediaUrl.isNotEmpty ? video.mediaUrl.first.mediaKey : '';
    Navigator.pushNamed(
      context,
      '/video-player',
      arguments: {
        'video': video,
        'mediaUrl': mediaUrl,
      },
    );
  }

  Widget _buildVerticalVideoSection(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 8, // Show limited items in home tab
      itemBuilder: (context, index) {
        final video = videos[index % videos.length];
        return Padding(
          padding: EdgeInsets.only(bottom: _getResponsiveSpacing(context, 16)),
          child: VideoListItem(
            video: video,
            index: index,
          ),
        );
      },
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
    return cardWidth * 0.75; // Adjust ratio as needed
  }
}
