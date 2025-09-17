import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../service_locator/service_locator.dart';
import '../../../domain/entity/star_entity.dart';
import '../../../data/model/tube_video_models.dart';
import '../../controller/playlist_cubit/playlist_cubit.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../common/options_bottom_sheet.dart';
import '../common/thumbnail_widget.dart';
import 'playlist_bottom_sheet.dart';

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
                  imageUrl: _getVideoThumbnail(video),
                  width: double.infinity,
                  height: double.infinity,
                  duration: _formatDuration(video),
                  showVolumeIcon: true,
                  showPlayIcon: false,
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
                    onTap: () {
                      ManageVibration.vibrate();
                      _showVideoOptions(context, video);
                    },
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

          // Title and info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 4),
              Text(
                "${_formatViewCount(video.totalViews, context)} ${context.isArabic ? 'مشاهدة' : 'views'}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
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
                  imageUrl: _getVideoThumbnail(video),
                  width: thumbnailWidth,
                  height: thumbnailHeight,
                  duration: _formatDuration(video),
                  showVolumeIcon: true,
                  showPlayIcon: false,
                ),
                // Options overlay
                // Positioned(
                //   top: 4,
                //   right: 4,
                //   child: GestureDetector(
                //     onTap: () => _showVideoOptions(context, video),
                //     child: Container(
                //       padding: EdgeInsets.all(4),
                //       decoration: BoxDecoration(
                //         color: Colors.black.withOpacity(0.6),
                //         shape: BoxShape.circle,
                //       ),
                //       child: Icon(
                //         Icons.more_vert,
                //         color: Colors.white,
                //         size: 16,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(width: 16),

            // Video info - استخدام البيانات الحقيقية
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
                    "${_formatViewCount(video.totalViews, context)} ${context.isArabic ? 'مشاهدة' : 'views'} • ${_formatTimeAgo(video.createdAt ?? DateTime.now(), context).toArabicNumbers(context)}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  // إضافة تفاصيل إضافية للفيديوهات الجديدة
                  if (video is TubeVideoModel) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up_outlined,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          video.likes.toString().toArabicNumbers(context),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.star_outline,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          video.averageRating
                              .toStringAsFixed(1)
                              .toArabicNumbers(context),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
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

  // Helper methods للحصول على البيانات الحقيقية
  String? _getVideoThumbnail(StarEntity video) {
    if (video is TubeVideoModel) {
      return video.thumbnail;
    }
    // للفيديوهات القديمة، استخدم أول صورة من mediaUrl
    if (video.mediaUrl.isNotEmpty) {
      final mediaUrl = video.mediaUrl.first.mediaKey;
      // إذا كان URL للصورة، استخدمه كـ thumbnail
      if (mediaUrl.toLowerCase().contains('.jpg') ||
          mediaUrl.toLowerCase().contains('.png') ||
          mediaUrl.toLowerCase().contains('.webp')) {
        return mediaUrl;
      }
    }
    return null; // استخدم default thumbnail
  }

  String _formatDuration(StarEntity video) {
    Duration duration;

    if (video is TubeVideoModel) {
      duration = Duration(seconds: video.duration);
    } else if (video.mediaUrl.isNotEmpty) {
      duration = video.mediaUrl.first.duration ?? Duration.zero;
    } else {
      duration = Duration.zero;
    }

    if (duration == Duration.zero) return '0:00';

    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      final hours = duration.inHours.toString();
      return '$hours:${minutes.padLeft(2, '0')}:$seconds';
    }
    return '$minutes:$seconds';
  }

  String _formatViewCount(num views, BuildContext context) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString().toArabicNumbers(context);
  }

  String _formatTimeAgo(DateTime dateTime, BuildContext context) {
    final difference = DateTime.now().difference(dateTime);
    final isArabic = context.isArabic;

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return isArabic ? 'منذ ${years} سنة' : '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return isArabic ? 'منذ ${months} شهر' : '${months}mo ago';
    } else if (difference.inDays > 0) {
      return isArabic ? 'منذ ${difference.inDays} يوم' : '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return isArabic ? 'منذ ${difference.inHours} ساعة' : '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return isArabic ? 'منذ ${difference.inMinutes} دقيقة' : '${difference.inMinutes}m ago';
    }
    return isArabic ? 'الآن' : 'Just now';
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
          _showPlaylistBottomSheet(context, video);
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
