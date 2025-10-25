import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../data/model/tube_video_models.dart';
import '../../presentation_exports.dart';
import 'talent_video_player.dart';

class RelatedVideosSection extends StatelessWidget {
  final List<StarEntity> recommendedVideos;
  final bool isLoading;
  final StarCubit starCubit;
  final Function(StarEntity) onVideoTap;

  const RelatedVideosSection({
    super.key,
    required this.recommendedVideos,
    required this.isLoading,
    required this.starCubit,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              context.isArabic ? 'مقاطع مرتبطة' : 'Related Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (recommendedVideos.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  context.isArabic
                      ? 'لا توجد فيديوهات مرتبطة'
                      : 'No related videos',
                  style: TextStyle(
                      color: context.isDarkMode ? Colors.white : Colors.grey),
                ),
              ),
            )
          else
            ...recommendedVideos.map((video) => _RelatedVideoCard(
                  talent: video,
                  starCubit: starCubit,
                  onTap: () => onVideoTap(video),
                )),
        ],
      ),
    );
  }
}

class _RelatedVideoCard extends StatefulWidget {
  final StarEntity talent;
  final StarCubit starCubit;
  final VoidCallback onTap;

  const _RelatedVideoCard({
    super.key,
    required this.talent,
    required this.starCubit,
    required this.onTap,
  });

  @override
  State<_RelatedVideoCard> createState() => _RelatedVideoCardState();
}

class _RelatedVideoCardState extends State<_RelatedVideoCard> {
  Map<String, num> talentRatings = {};

  String _formatViewCount(num views) {
    final viewCount = views.toInt();
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return context.isArabic
          ? '$years ${years == 1 ? 'سنة' : 'سنوات'}'
          : '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return context.isArabic
          ? '$months ${months == 1 ? 'شهر' : 'أشهر'}'
          : '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return context.isArabic
          ? '${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}'
          : '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return context.isArabic
          ? '${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}'
          : '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }
    return context.isArabic ? 'منذ قليل' : 'Just now';
  }

  void _showVideoOptions(StarEntity talent) {
    // Placeholder - to be implemented
  }

  @override
  Widget build(BuildContext context) {
    final talent = widget.talent;
    final mediaUrl =
        talent.mediaUrl.isNotEmpty ? talent.mediaUrl.first.mediaKey : '';
    final createdAt = talent.createdAt ?? DateTime.now();
    final thumbnailUrl = talent is TubeVideoModel ? talent.thumbnail : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail with YouTube-style player
          GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              children: [
                // Thumbnail with CachedNetworkImage
                thumbnailUrl != null && thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/testforvideo.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: DecorationImage(
                            image: AssetImage('assets/images/testforvideo.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                // Heart button
                // Positioned(
                //   top: 8,
                //   left: 8,
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.6),
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(
                //       Icons.favorite,
                //       color: Colors.red,
                //       size: 20,
                //     ),
                //   ),
                // ),
                // // Mute button
                // Positioned(
                //   top: 8,
                //   right: 8,
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.6),
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(
                //       Icons.volume_off,
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //   ),
                // ),
                // Duration
                if (talent is TubeVideoModel && talent.duration > 0)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDuration(talent.duration),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                // Play button overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Video Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: talent.user.image.isNotEmpty
                      ? NetworkImage(talent.user.image)
                      : null,
                  child: talent.user.image.isEmpty
                      ? Icon(Icons.person, size: 18, color: Colors.grey[600])
                      : null,
                ),
                const SizedBox(width: 12),

                // Title and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        talent.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${talent.user.firstName} ${talent.user.lastName}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${_formatViewCount(talent.totalViews)} views • ${_formatTimeAgo(createdAt)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // More Options and Stars
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => _showVideoOptions(talent),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    // Interactive Star Rating
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (starIndex) => GestureDetector(
                          onTap: () {
                            setState(() {
                              talentRatings[talent.id] = starIndex + 1;
                            });
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('Rated ${starIndex + 1} stars'),
                            //     duration: const Duration(seconds: 1),
                            //   ),
                            // );
                            showSuccessDialog(
                                context,
                                context.isArabic
                                    ? 'تم تقييم الفيديو بـ ${starIndex + 1} نجوم'
                                    : 'Video rated with ${starIndex + 1} stars');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Icon(
                              starIndex <
                                      (talentRatings[talent.id] ??
                                          talent.averageRating)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: starIndex <
                                      (talentRatings[talent.id] ??
                                          talent.averageRating)
                                  ? Colors.amber
                                  : Colors.grey[400],
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
