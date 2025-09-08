import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../domain/entity/star_entity.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../common/options_bottom_sheet.dart';
import '../common/thumbnail_widget.dart';

class ProfileVideoGrid extends StatelessWidget {
  final List<StarEntity> videos;
  final bool isGridView;
  final Function(StarEntity)? onVideoTap;
  final StarCubit starCubit;
  final bool isCurrentUser;

  const ProfileVideoGrid({
    super.key,
    required this.videos,
    this.isGridView = true,
    this.onVideoTap,
    required this.starCubit,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
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
              isCurrentUser
                  ? (context.isArabic
                      ? 'لا توجد فيديوهات بعد'
                      : 'No videos yet')
                  : (context.isArabic ? 'لا توجد فيديوهات' : 'No videos'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (isCurrentUser) ...[
              SizedBox(height: 8),
              Text(
                context.isArabic
                    ? 'ابدأ في رفع أول فيديو لك'
                    : 'Start uploading your first video',
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

    return isGridView ? _buildGridView(context) : _buildListView(context);
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16 / 12,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildGridVideoItem(context, video, index);
      },
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildListVideoItem(context, video, index),
        );
      },
    );
  }

  Widget _buildGridVideoItem(
      BuildContext context, StarEntity video, int index) {
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        onVideoTap?.call(video);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with options
          Expanded(
            child: Stack(
              children: [
                ThumbnailWidget(
                  width: double.infinity,
                  height: double.infinity,
                  duration: '7:54',
                  showVolumeIcon: true,
                  showPlayIcon: true,
                  onTap: () {
                    ManageVibration.vibrate();
                    onVideoTap?.call(video);
                  },
                ),
                // Options menu
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _showVideoOptions(context, video),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),

          // Title
          Text(
            video.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildListVideoItem(
      BuildContext context, StarEntity video, int index) {
    final thumbnailWidth = MediaQuery.of(context).size.width * 0.4;
    final thumbnailHeight = thumbnailWidth * 0.56;

    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        onVideoTap?.call(video);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ThumbnailWidget(
                  width: thumbnailWidth,
                  height: thumbnailHeight,
                  duration: '7:54',
                  showVolumeIcon: true,
                ),
                // Options overlay
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _showVideoOptions(context, video),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),

            // Video info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    "${video.user.firstName} ${video.user.lastName}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${video.totalViews} views • 7 days ago",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // More button
            GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                _showVideoOptions(context, video);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoOptions(BuildContext context, StarEntity video) {
    List<OptionItem> options = [];

    // Common options for all users
    options.addAll([
      OptionItem(
        icon: Icons.playlist_add,
        title: context.isArabic ? 'إضافة لقائمة التشغيل' : 'Add to playlist',
        onTap: () {
          ManageVibration.vibrate();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to playlist')),
          );
        },
      ),
      OptionItem(
        icon: starCubit.isFavorite(video.id)
            ? Icons.favorite
            : Icons.favorite_border,
        title: starCubit.isFavorite(video.id)
            ? (context.isArabic ? 'إزالة من المفضلة' : 'Remove from favorites')
            : (context.isArabic ? 'إضافة للمفضلة' : 'Add to favorites'),
        onTap: () {
          ManageVibration.vibrate();
          Navigator.pop(context);
          starCubit.toggleFavorite(video.id);
        },
        iconColor: starCubit.isFavorite(video.id) ? Colors.red : null,
      ),
      OptionItem(
        icon: Icons.share,
        title: context.isArabic ? 'مشاركة' : 'Share',
        onTap: () {
          ManageVibration.vibrate();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Video shared')),
          );
        },
      ),
    ]);

    // Delete option only for current user's videos
    if (isCurrentUser) {
      options.add(
        OptionItem(
          icon: Icons.delete,
          title: context.isArabic ? 'حذف الفيديو' : 'Delete video',
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
            _showDeleteConfirmation(context, video);
          },
          iconColor: Colors.red,
          textColor: Colors.red,
        ),
      );
    } else {
      // Report option for other users' videos
      options.add(
        OptionItem(
          icon: Icons.flag,
          title: context.isArabic ? 'بلاغ' : 'Report',
          onTap: () {
            ManageVibration.vibrate();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Video reported')),
            );
          },
          iconColor: Colors.red,
          textColor: Colors.red,
        ),
      );
    }

    OptionsBottomSheet.showOptions(
      context: context,
      options: options,
    );
  }

  void _showDeleteConfirmation(BuildContext context, StarEntity video) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'حذف الفيديو' : 'Delete Video',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          context.isArabic
              ? 'هل أنت متأكد من حذف هذا الفيديو؟ لا يمكن التراجع عن هذا الإجراء.'
              : 'Are you sure you want to delete this video? This action cannot be undone.',
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
              starCubit.deleteMyTubeVideo(video.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic ? 'تم حذف الفيديو' : 'Video deleted',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }
}
