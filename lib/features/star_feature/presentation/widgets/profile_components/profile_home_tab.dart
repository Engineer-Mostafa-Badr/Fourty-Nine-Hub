import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

import '../../controller/star_cubit/star_cubit.dart';
import '../../utils/enums.dart';
import '../common/loading_indicator.dart';
import '../common/thumbnail_widget.dart';
import '../talent_card/talent_card.dart';

class ProfileHomeTab extends StatefulWidget {
  final List<StarEntity> videos; // fallback data
  final bool isCurrentUser;

  const ProfileHomeTab({
    super.key,
    required this.videos,
    required this.isCurrentUser,
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
    // تحميل جميع الفيديوهات المتاحة للصفحة الرئيسية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _starCubit.loadTalents(TalentCategory.available, refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.status == StarStates.loading &&
            state.availableTalents.isEmpty) {
          return Center(
            child: StarLoadingIndicator(message: 'Loading videos...'),
          );
        }

        final allVideos = state.availableTalents;

        if (allVideos.isEmpty) {
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
              _buildHorizontalVideoSection(context, allVideos),

              SizedBox(height: _getResponsiveSpacing(context, 24)),

              // New Content Section - Vertical Scroll
              _buildSectionHeader(
                context,
                context.isArabic ? 'أغنية جديدة 2020' : 'New Song 2020',
              ),
              _buildVerticalVideoSection(context, allVideos),
            ],
          ),
        );
      },
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

  Widget _buildHorizontalVideoSection(
      BuildContext context, List<StarEntity> videos) {
    // أخذ أول 10 فيديوهات للـ horizontal section
    final forYouVideos = videos.take(10).toList();

    return SizedBox(
      height: _getVideoCardHeight(context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: _getResponsivePadding(context, 20)),
        itemCount: forYouVideos.length,
        itemBuilder: (context, index) {
          final video = forYouVideos[index];
          return Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: EdgeInsets.only(right: _getResponsiveSpacing(context, 12)),
            child: _buildSimpleVideoCard(context, video, index),
          );
        },
      ),
    );
  }

  Widget _buildSimpleVideoCard(
      BuildContext context, StarEntity video, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Thumbnail with options
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
            child: Stack(
              children: [
                ThumbnailWidget(
                  imageUrl: video.mediaUrl.isNotEmpty
                      ? video.mediaUrl.first.mediaKey
                      : null,
                  width: double.infinity,
                  height: double.infinity,
                  duration: '7:54',
                  showVolumeIcon: true,
                  onTap: () => _navigateToVideo(context, video),
                ),
                // Three dots menu
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _showVideoOptions(context, video),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        // Video Info
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

  Widget _buildVerticalVideoSection(
      BuildContext context, List<StarEntity> videos) {
    // أخذ فيديوهات مختلفة للـ vertical section
    final newSongVideos = videos.skip(10).take(8).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: newSongVideos.length,
      itemBuilder: (context, index) {
        final video = newSongVideos[index];
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

  void _showVideoOptions(BuildContext context, StarEntity video) {
    // استخدام نفس options الموجودة في TalentCard
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Options
            Column(
              children: [
                _buildOptionItem(
                  context,
                  Icons.playlist_add,
                  context.isArabic ? 'إضافة لقائمة التشغيل' : 'Add to playlist',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to playlist')),
                    );
                  },
                ),
                _buildOptionItem(
                  context,
                  _starCubit.isFavorite(video.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  _starCubit.isFavorite(video.id)
                      ? (context.isArabic
                          ? 'إزالة من المفضلة'
                          : 'Remove from favorites')
                      : (context.isArabic
                          ? 'إضافة للمفضلة'
                          : 'Add to favorites'),
                  () {
                    Navigator.pop(context);
                    _starCubit.toggleFavorite(video.id);
                  },
                  iconColor:
                      _starCubit.isFavorite(video.id) ? Colors.red : null,
                ),
                _buildOptionItem(
                  context,
                  Icons.share,
                  context.isArabic ? 'مشاركة' : 'Share',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Shared')),
                    );
                  },
                ),
                _buildOptionItem(
                  context,
                  Icons.flag,
                  context.isArabic ? 'بلاغ' : 'Report',
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reported')),
                    );
                  },
                  iconColor: Colors.red,
                  textColor: Colors.red,
                ),
              ],
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.grey[700],
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black,
        ),
      ),
      onTap: onTap,
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
