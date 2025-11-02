import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';
import '../screens/tube_channel_screen.dart';
import '../screens/tube_video_player_screen.dart';
/*
class VideoCardTube extends StatelessWidget {
  final GetAllTubeVideosEntity video;
  final List<GetAllTubeVideosEntity>? videoList;
  final bool? isFavorite;
  final bool isMyVideo; // 👈 NEW FLAG
  final VoidCallback? onTap;
  final VoidCallback? onEditPressed; // 👈 NEW callback
  final VoidCallback? onDeletePressed; // 👈 NEW callback

  const VideoCardTube({
    required this.video,
    this.videoList,
    this.isFavorite = false,
    this.isMyVideo = false, // 👈 default false
    this.onTap,
    this.onEditPressed,
    this.onDeletePressed,
    super.key,
  });

  String _formatViews(int? views) {
    if (views == null || views == 0) return '0 views';
    if (views < 1000) return '$views views';
    if (views < 1000000) return '${(views / 1000).toStringAsFixed(1)}K views';
    return '${(views / 1000000).toStringAsFixed(1)}M views';
  }

  String _formatTimeAgo(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return '';
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  void _showMyVideoMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Edit Video',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEditPressed?.call();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Delete Video',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDeletePressed?.call();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFav = isFavorite == true || video.isFavorite == true;
    final cubit = context.read<TubeCubit>();
    final state = cubit.state;

    return GestureDetector(
      onTap: onTap ??
              () {
            // default tap logic
            if (state.currentVideo?.id == video.id &&
                state.isMinimized &&
                state.areControllersInitialized) {
              cubit.maximizePlayer();
              if (state.isPlaying && state.videoPlayerController != null) {
                state.videoPlayerController!.play();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: VideoPlayerPage(video: video, videoList: videoList),
                  ),
                ),
              );
            } else {
              cubit.playVideo(video, videoList: videoList);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: cubit,
                    child: VideoPlayerPage(video: video, videoList: videoList),
                  ),
                ),
              );
            }
          },
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Thumbnail
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Builder(
                    builder: (_) {
                      // 🖼️ If a local thumbnail exists, show it immediately
                      if (video.localThumbnailPath != null &&
                          File(video.localThumbnailPath!).existsSync()) {
                        return Image.file(
                          File(video.localThumbnailPath!),
                          fit: BoxFit.cover,
                        );
                      }

                      // 🌐 Otherwise, fall back to the remote thumbnail
                      if (video.thumbnail != null && video.thumbnail!.isNotEmpty) {
                        return Image.network(
                          video.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF0F0F0F),
                            child: const Center(
                              child: Icon(Icons.videocam_off,
                                  color: Color(0xFF717171), size: 48),
                            ),
                          ),
                        );
                      }

                      // ❌ If neither local nor remote exists
                      return Container(
                        color: const Color(0xFF0F0F0F),
                        child: const Center(
                          child: Icon(Icons.videocam_off,
                              color: Color(0xFF717171), size: 48),
                        ),
                      );
                    },
                  ),
                ),


                if (video.duration != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        _formatDuration(video.duration),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (video.id != null) {
                        cubit.toggleFavoriteTubeVideo(video.id!);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.redAccent,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 📄 Info Row
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: video.owner?.channelPicture != null
                        ? NetworkImage(video.owner!.channelPicture!)
                        : null,
                    radius: 18,
                    backgroundColor: const Color(0xFF272727),
                    child: video.owner?.channelPicture == null
                        ? const Icon(Icons.person,
                        color: Color(0xFF717171), size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title ?? 'Untitled',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFF1F1F1),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                video.owner?.channelName ??
                                    'Unknown Channel',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (video.owner?.isAccountVerified == true)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.check_circle,
                                    size: 12, color: Color(0xFFAAAAAA)),
                              ),
                          ],
                        ),
                        Text(
                          [
                            _formatViews(video.views),
                            _formatTimeAgo(video.createdAt),
                          ].where((s) => s.isNotEmpty).join(' • '),
                          style: const TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ⋮ Menu only for MyVideos
                  if (isMyVideo)
                    IconButton(
                      icon: const Icon(Icons.more_vert,
                          color: Color(0xFFF1F1F1), size: 20),
                      onPressed: () => _showMyVideoMenu(context),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class VideoCardTube extends StatelessWidget {
  final GetAllTubeVideosEntity video;
  final List<GetAllTubeVideosEntity>? videoList;
  final bool? isFavorite;
  final bool isMyVideo;
  final VoidCallback? onTap;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const VideoCardTube({
    required this.video,
    this.videoList,
    this.isFavorite = false,
    this.isMyVideo = false,
    this.onTap,
    this.onEditPressed,
    this.onDeletePressed,
    super.key,
  });

  // ==================== FORMATTERS ====================

  String _formatViews(int? views) {
    if (views == null || views == 0) return '0 views';
    if (views < 1000) return '$views views';
    if (views < 1000000) return '${(views / 1000).toStringAsFixed(1)}K views';
    return '${(views / 1000000).toStringAsFixed(1)}M views';
  }

  String _formatTimeAgo(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return '';
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  // ==================== RATING STARS (USER + AVERAGE) ====================

  Widget _buildRatingStars1(BuildContext context, TubeCubit cubit) {
    final bool isRated = video.isRate ?? false;
    final int userRating = video.userRating ?? 0;
    final double avgRating = video.averageRating ?? 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starIndex = i + 1;

        // If user has rated → show user rating (interactive disabled)
        // If not rated → show interactive stars
        // If average exists → overlay average (read-only)
        final bool showAverage = isRated && avgRating > 0;
        final bool filledByUser = isRated && starIndex <= userRating;
        final bool filledByAvg = showAverage && starIndex <= avgRating.round();

        return GestureDetector(
          onTap: isRated
              ? null
              : () {
                  if (video.id == null) return;
                  cubit.rateTubeVideo(video.id!, starIndex);
                },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base star (border or dim)
              Icon(
                Icons.star_border,
                color:
                    isRated ? const Color(0xFF555555) : const Color(0xFF777777),
                size: 18,
              ),

              // Average fill (behind)
              if (showAverage && filledByAvg)
                Icon(
                  Icons.star,
                  color:
                      const Color(0xFFFFC107).withOpacity(0.4), // light amber
                  size: 18,
                ),

              // User fill (on top)
              if (filledByUser)
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 18,
                ),

              // Empty star (interactive)
              if (!isRated && !filledByUser)
                Icon(
                  Icons.star_border,
                  color: const Color(0xFF777777),
                  size: 18,
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRatingStars(BuildContext context, TubeCubit cubit) {
    final bool isRated = video.isRate ?? false;
    final int userRating = video.userRating ?? 0;
    final double avgRating = video.averageRating ?? 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starIndex = i + 1;
        final bool filledByUser = isRated && starIndex <= userRating;
        final bool filledByAvg =
            avgRating > 0 && starIndex <= avgRating.round();

        // Interactive only if NOT rated
        if (!isRated) {
          return GestureDetector(
            onTap: () {
              if (video.id == null) return;
              cubit.rateTubeVideo(video.id!, starIndex);
            },
            child: Icon(
              starIndex <= userRating ? Icons.star : Icons.star_border,
              color: starIndex <= userRating
                  ? Colors.amber
                  : const Color(0xFF777777),
              size: 18,
            ),
          );
        }

        // Already rated → show user rating + average in background
        return Stack(
          alignment: Alignment.center,
          children: [
            // Average rating (background)
            if (filledByAvg)
              Icon(
                Icons.star,
                color: const Color(0xFFFFC107).withOpacity(0.3),
                size: 18,
              ),

            // User rating (on top)
            Icon(
              filledByUser ? Icons.star : Icons.star_border,
              color: filledByUser ? Colors.amber : const Color(0xFF555555),
              size: 18,
            ),
          ],
        );
      }),
    );
  }
  // ==================== AVERAGE RATING TEXT (next to stars) ====================

  Widget _buildAverageRatingText() {
    if (video.averageRating == null || video.averageRating == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        video.averageRating!.toStringAsFixed(1),
        style: const TextStyle(
          color: Color(0xFFFFC107),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ==================== MENUS ====================

  void _showMyVideoMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3F3F3F),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Colors.white),
                title: const Text('Edit Video',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  onEditPressed?.call();
                },
              ),
              const Divider(color: Color(0xFF2F2F2F), height: 1),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete Video',
                    style: TextStyle(color: Colors.red, fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  onDeletePressed?.call();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showVideoMenu(BuildContext context, TubeCubit cubit) {
    final bool isWatchLater = video.isWatchLater ?? false;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3F3F3F),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(
                  isWatchLater ? Icons.watch_later : Icons.watch_later_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  isWatchLater
                      ? 'Remove from Watch Later'
                      : 'Save to Watch Later',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (video.id != null) {
                    if (isWatchLater) {
                      cubit.removeWatchLaterTubeVideo(video.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Removed from Watch Later'),
                          backgroundColor: Color(0xFF272727),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      cubit.addWatchLaterTubeVideo(video.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to Watch Later'),
                          backgroundColor: Color(0xFF272727),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
              const Divider(color: Color(0xFF2F2F2F), height: 1),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: Colors.white),
                title: const Text('Share',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Share
                },
              ),
              const Divider(color: Color(0xFF2F2F2F), height: 1),
              ListTile(
                leading: const Icon(Icons.report_outlined, color: Colors.white),
                title: const Text('Report',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Report
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    final bool isFav = isFavorite == true || video.isFavorite == true;
    final cubit = context.read<TubeCubit>();
    final state = cubit.state;

    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          GestureDetector(
            onTap: onTap ??
                () {
                  if (state.currentVideo?.id == video.id &&
                      state.isMinimized &&
                      state.areControllersInitialized) {
                    cubit.maximizePlayer();
                    if (state.isPlaying &&
                        state.videoPlayerController != null) {
                      state.videoPlayerController!.play();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: VideoPlayerPage(
                              video: video, videoList: videoList),
                        ),
                      ),
                    );
                  } else {
                    cubit.playVideo(video, videoList: videoList);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: VideoPlayerPage(
                              video: video, videoList: videoList),
                        ),
                      ),
                    );
                  }
                },
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Builder(
                    builder: (_) {
                      if (video.localThumbnailPath != null &&
                          File(video.localThumbnailPath!).existsSync()) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.file(
                            File(video.localThumbnailPath!),
                            fit: BoxFit.cover,
                          ),
                        );
                      }

                      if (video.thumbnail != null &&
                          video.thumbnail!.isNotEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.network(
                            video.thumbnail!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: const Color(0xFF0F0F0F),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF0F0F0F),
                              child: const Center(
                                child: Icon(Icons.videocam_off,
                                    color: Color(0xFF717171), size: 48),
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        color: const Color(0xFF0F0F0F),
                        child: const Center(
                          child: Icon(Icons.videocam_off,
                              color: Color(0xFF717171), size: 48),
                        ),
                      );
                    },
                  ),
                ),

                // Duration
                if (video.duration != null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDuration(video.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (video.id != null) {
                        cubit.toggleFavoriteTubeVideo(video.id!);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Watch Later Badge
                if (video.isWatchLater == true)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.watch_later,
                              color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Watch Later',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info Row
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel Avatar
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TubeChannelScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: video.owner?.channelPicture != null
                          ? NetworkImage(video.owner!.channelPicture!)
                          : null,
                      radius: 18,
                      backgroundColor: const Color(0xFF272727),
                      child: video.owner?.channelPicture == null
                          ? const Icon(Icons.person,
                              color: Color(0xFF717171), size: 20)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Video Info + Rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        video.title ?? 'Untitled',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFF1F1F1),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Channel + Verified
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              video.owner?.channelName ?? 'Unknown Channel',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Color(0xFFAAAAAA), fontSize: 12),
                            ),
                          ),
                          if (video.owner?.isAccountVerified == true)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.check_circle,
                                  size: 12, color: Color(0xFFAAAAAA)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Views • Time ago
                      Text(
                        [
                          _formatViews(video.views),
                          _formatTimeAgo(video.createdAt),
                        ].where((s) => s.isNotEmpty).join(' • '),
                        style: const TextStyle(
                            color: Color(0xFFAAAAAA), fontSize: 12),
                      ),

                      const SizedBox(height: 6),

                      // RATING ROW: Stars + Number
                      Row(
                        children: [
                          _buildRatingStars(context, cubit),
                          _buildAverageRatingText(),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menu
                IconButton(
                  icon: const Icon(Icons.more_vert,
                      color: Color(0xFFF1F1F1), size: 20),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (isMyVideo) {
                      _showMyVideoMenu(context);
                    } else {
                      _showVideoMenu(context, cubit);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class VideoCardTube extends StatelessWidget {
//   final GetAllTubeVideosEntity video;
//   final List<GetAllTubeVideosEntity>? videoList;
//   final bool? isFavorite;
//   final bool isMyVideo;
//   final VoidCallback? onTap;
//   final VoidCallback? onEditPressed;
//   final VoidCallback? onDeletePressed;
//
//   const VideoCardTube({
//     required this.video,
//     this.videoList,
//     this.isFavorite = false,
//     this.isMyVideo = false,
//     this.onTap,
//     this.onEditPressed,
//     this.onDeletePressed,
//     super.key,
//   });
//
//   String _formatViews(int? views) {
//     if (views == null || views == 0) return '0 views';
//     if (views < 1000) return '$views views';
//     if (views < 1000000) return '${(views / 1000).toStringAsFixed(1)}K views';
//     return '${(views / 1000000).toStringAsFixed(1)}M views';
//   }
//
//   String _formatTimeAgo(String? createdAt) {
//     if (createdAt == null) return '';
//     try {
//       final date = DateTime.parse(createdAt);
//       final now = DateTime.now();
//       final difference = now.difference(date);
//
//       if (difference.inDays > 365) {
//         final years = (difference.inDays / 365).floor();
//         return '$years ${years == 1 ? 'year' : 'years'} ago';
//       } else if (difference.inDays > 30) {
//         final months = (difference.inDays / 30).floor();
//         return '$months ${months == 1 ? 'month' : 'months'} ago';
//       } else if (difference.inDays > 0) {
//         return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
//       } else if (difference.inMinutes > 0) {
//         return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
//       } else {
//         return 'Just now';
//       }
//     } catch (_) {
//       return '';
//     }
//   }
//
//   String _formatDuration(int? seconds) {
//     if (seconds == null) return '';
//     final duration = Duration(seconds: seconds);
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes.remainder(60);
//     final secs = duration.inSeconds.remainder(60);
//     if (hours > 0) {
//       return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
//     }
//     return '$minutes:${secs.toString().padLeft(2, '0')}';
//   }
//
//   void _showMyVideoMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1A1A1A),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Drag handle
//               Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3F3F3F),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.edit_outlined, color: Colors.white),
//                 title: const Text(
//                   'Edit Video',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   onEditPressed?.call();
//                 },
//               ),
//               const Divider(color: Color(0xFF2F2F2F), height: 1),
//               ListTile(
//                 leading: const Icon(Icons.delete_outline, color: Colors.red),
//                 title: const Text(
//                   'Delete Video',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   onDeletePressed?.call();
//                 },
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showVideoMenu(BuildContext context, TubeCubit cubit) {
//     final bool isWatchLater = video.isWatchLater ?? false;
//
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1A1A1A),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Drag handle
//               Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3F3F3F),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(
//                   isWatchLater ? Icons.watch_later : Icons.watch_later_outlined,
//                   color: Colors.white,
//                 ),
//                 title: Text(
//                   isWatchLater ? 'Remove from Watch Later' : 'Save to Watch Later',
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   if (video.id != null) {
//                     if (isWatchLater) {
//                       cubit.removeWatchLaterTubeVideo(video.id!);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Removed from Watch Later'),
//                           backgroundColor: Color(0xFF272727),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     } else {
//                       cubit.addWatchLaterTubeVideo(video.id!);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Added to Watch Later'),
//                           backgroundColor: Color(0xFF272727),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   }
//                 },
//               ),
//               const Divider(color: Color(0xFF2F2F2F), height: 1),
//               ListTile(
//                 leading: const Icon(Icons.share_outlined, color: Colors.white),
//                 title: const Text(
//                   'Share',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement share functionality
//                 },
//               ),
//               const Divider(color: Color(0xFF2F2F2F), height: 1),
//               ListTile(
//                 leading: const Icon(Icons.report_outlined, color: Colors.white),
//                 title: const Text(
//                   'Report',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Implement report functionality
//                 },
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isFav = isFavorite == true || video.isFavorite == true;
//     final cubit = context.read<TubeCubit>();
//     final state = cubit.state;
//
//     return GestureDetector(
//       onTap: onTap ??
//               () {
//             if (state.currentVideo?.id == video.id &&
//                 state.isMinimized &&
//                 state.areControllersInitialized) {
//               cubit.maximizePlayer();
//               if (state.isPlaying && state.videoPlayerController != null) {
//                 state.videoPlayerController!.play();
//               }
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => BlocProvider.value(
//                     value: cubit,
//                     child: VideoPlayerPage(video: video, videoList: videoList),
//                   ),
//                 ),
//               );
//             } else {
//               cubit.playVideo(video, videoList: videoList);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => BlocProvider.value(
//                     value: cubit,
//                     child: VideoPlayerPage(video: video, videoList: videoList),
//                   ),
//                 ),
//               );
//             }
//           },
//       child: Container(
//         color: Colors.black,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🖼️ Thumbnail with enhanced overlay
//             Stack(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: Builder(
//                     builder: (_) {
//                       if (video.localThumbnailPath != null &&
//                           File(video.localThumbnailPath!).existsSync()) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(0),
//                           child: Image.file(
//                             File(video.localThumbnailPath!),
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       }
//
//                       if (video.thumbnail != null && video.thumbnail!.isNotEmpty) {
//                         return ClipRRect(
//                           borderRadius: BorderRadius.circular(0),
//                           child: Image.network(
//                             video.thumbnail!,
//                             fit: BoxFit.cover,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Container(
//                                 color: const Color(0xFF0F0F0F),
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     value: loadingProgress.expectedTotalBytes != null
//                                         ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                         : null,
//                                     color: Colors.redAccent,
//                                   ),
//                                 ),
//                               );
//                             },
//                             errorBuilder: (_, __, ___) => Container(
//                               color: const Color(0xFF0F0F0F),
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.videocam_off,
//                                   color: Color(0xFF717171),
//                                   size: 48,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//
//                       return Container(
//                         color: const Color(0xFF0F0F0F),
//                         child: const Center(
//                           child: Icon(
//                             Icons.videocam_off,
//                             color: Color(0xFF717171),
//                             size: 48,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//                 // Duration badge
//                 if (video.duration != null)
//                   Positioned(
//                     bottom: 8,
//                     right: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 6,
//                         vertical: 3,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.85),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         _formatDuration(video.duration),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 // Favorite button
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: GestureDetector(
//                     onTap: () {
//                       if (video.id != null) {
//                         cubit.toggleFavoriteTubeVideo(video.id!);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.black.withOpacity(0.6),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         isFav ? Icons.favorite : Icons.favorite_border,
//                         color: isFav ? Colors.redAccent : Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Watch Later badge (if added to watch later)
//                 if (video.isWatchLater == true)
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.9),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: const [
//                           Icon(
//                             Icons.watch_later,
//                             color: Colors.white,
//                             size: 14,
//                           ),
//                           SizedBox(width: 4),
//                           Text(
//                             'Watch Later',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//
//             // 📄 Enhanced Info Row
//             Padding(
//               padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Channel Avatar
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=> TubeChannelScreen()));
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         backgroundImage: video.owner?.channelPicture != null
//                             ? NetworkImage(video.owner!.channelPicture!)
//                             : null,
//                         radius: 18,
//                         backgroundColor: const Color(0xFF272727),
//                         child: video.owner?.channelPicture == null
//                             ? const Icon(
//                           Icons.person,
//                           color: Color(0xFF717171),
//                           size: 20,
//                         )
//                             : null,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//
//                   // Video Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           video.title ?? 'Untitled',
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Color(0xFFF1F1F1),
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             height: 1.3,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Flexible(
//                               child: Text(
//                                 video.owner?.channelName ?? 'Unknown Channel',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   color: Color(0xFFAAAAAA),
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                             if (video.owner?.isAccountVerified == true)
//                               const Padding(
//                                 padding: EdgeInsets.only(left: 4),
//                                 child: Icon(
//                                   Icons.check_circle,
//                                   size: 12,
//                                   color: Color(0xFFAAAAAA),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           [
//                             _formatViews(video.views),
//                             _formatTimeAgo(video.createdAt),
//                           ].where((s) => s.isNotEmpty).join(' • '),
//                           style: const TextStyle(
//                             color: Color(0xFFAAAAAA),
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Menu Button
//                   IconButton(
//                     icon: const Icon(
//                       Icons.more_vert,
//                       color: Color(0xFFF1F1F1),
//                       size: 20,
//                     ),
//                     padding: const EdgeInsets.all(4),
//                     constraints: const BoxConstraints(),
//                     onPressed: () {
//                       if (isMyVideo) {
//                         _showMyVideoMenu(context);
//                       } else {
//                         _showVideoMenu(context, cubit);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
