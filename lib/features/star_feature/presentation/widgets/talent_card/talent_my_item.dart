import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../domain/entity/star_entity.dart';
import '../../../data/model/tube_video_models.dart';
import '../../controller/star_cubit/star_cubit.dart';
import '../../pages/my_video_details_view.dart';

class TalentMyItem extends StatelessWidget {
  final StarEntity talent;
  final StarCubit cubit;
  final int index;
  final Function(StarEntity, String)? onVideoTap;

  const TalentMyItem({
    super.key,
    required this.talent,
    required this.cubit,
    required this.index,
    this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
    final createdAt = talent.createdAt ?? DateTime.now();

    // Check if it's a TubeVideo to get additional info
    final tubeVideo =
        talent is TubeVideoModel ? talent as TubeVideoModel : null;
    final thumbnailUrl = tubeVideo?.thumbnail;

    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        if (onVideoTap != null) {
          onVideoTap!(talent, mediaUrl);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailsView(
                talent: talent,
                mediaUrl: mediaUrl,
                cubit: cubit,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail section
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Stack(
                children: [
                  // Background thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: thumbnailUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.video_library,
                                size: 48,
                                color: Colors.grey[600],
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.video_library,
                              size: 48,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),

                  // Play button overlay
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Duration badge
                  if (tubeVideo != null && tubeVideo.duration > 0)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(tubeVideo.duration),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Video info section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile picture
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: talent.user.image.isNotEmpty
                      ? NetworkImage(talent.user.image)
                      : null,
                  child: talent.user.image.isEmpty
                      ? Icon(Icons.person, size: 18, color: Colors.grey[600])
                      : null,
                ),
                SizedBox(width: 12),

                // Title and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        talent.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${talent.user.firstName} ${talent.user.lastName}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Stats row
                      Row(
                        children: [
                          Icon(Icons.visibility,
                              size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(
                            "${_formatNumber(talent.totalViews)} views",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 8),
                          Text("•", style: TextStyle(color: Colors.grey[600])),
                          SizedBox(width: 8),
                          Text(
                            _formatTimeAgo(createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // More options button
                IconButton(
                  onPressed: () => _showVideoOptions(context),
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),

            // Stats row for tube videos
            if (tubeVideo != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  if (tubeVideo.likes > 0) ...[
                    Icon(Icons.thumb_up_outlined, size: 16, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(
                      "${tubeVideo.likes}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                  if (tubeVideo.dislikes > 0) ...[
                    Icon(Icons.thumb_down_outlined,
                        size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      "${tubeVideo.dislikes}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                  if (talent.averageRating > 0) ...[
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 4),
                    Text(
                      "${talent.averageRating}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
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

  String _formatNumber(num number) {
    if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(0)}K";
    }
    return number.toString();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() > 1 ? 'years' : 'year'} ago";
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return "$months ${months > 1 ? 'months' : 'month'} ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} ${difference.inDays > 1 ? 'days' : 'day'} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} ${difference.inHours > 1 ? 'hours' : 'hour'} ago";
    }
    return 'Just now';
  }

  void _showVideoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // Add edit functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Add share functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Video'),
        content: Text(
            'Are you sure you want to delete this video? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteMyTubeVideo(talent.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
