import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/get_all_tube_videos_entity.dart';
import '../cubit/tube_cubit.dart';
import '../screens/tube_video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/tube/domain/entities/get_all_tube_videos_entity.dart';
import 'package:fourtyninehub/features/tube/presentation/cubit/tube_cubit.dart';
/*
class VideoCardTube extends StatelessWidget {
  final GetAllTubeVideosEntity video;
  final List<GetAllTubeVideosEntity>? videoList;

  /// if true, overrides the video’s own favorite status
  final bool? isFavorite;

  const VideoCardTube({
    required this.video,
    this.videoList,
    this.isFavorite = false,
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
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Use `isFavorite` override if provided
    final bool isFav = isFavorite == true || video.isFavorite == true;

    return GestureDetector(
      onTap: () {
        final cubit = context.read<TubeCubit>();
        cubit.playVideo(video, videoList: videoList);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: VideoPlayerPage(video: video),
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // 🎥 Thumbnail
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    video.thumbnail ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF0F0F0F),
                      child: const Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Color(0xFF717171),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),

                // 🕒 Duration Label
                if (video.duration != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        _formatDuration(video.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),

                // ❤️ Favorite Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      final cubit = context.read<TubeCubit>();
                      if (video.id != null) {
                        cubit.toggleFavoriteTubeVideo(video.id!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error: invalid video ID')),
                        );
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

            // 🧑 Channel + Info
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
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
                        ? const Icon(Icons.person, color: Color(0xFF717171), size: 20)
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
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                video.owner?.channelName ?? 'Unknown Channel',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (video.owner?.isAccountVerified == true)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Color(0xFFAAAAAA),
                                ),
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
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Color(0xFFF1F1F1), size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Show bottom sheet with options
                    },
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoCardTube extends StatelessWidget {
  final GetAllTubeVideosEntity video;
  final List<GetAllTubeVideosEntity>? videoList;
  final bool? isFavorite;

  const VideoCardTube({
    required this.video,
    this.videoList,
    this.isFavorite = false,
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
      return '${hours}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isFav = isFavorite == true || video.isFavorite == true;

    return GestureDetector(
      onTap: () {
        final cubit = context.read<TubeCubit>();
        cubit.playVideo(video, videoList: videoList);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: VideoPlayerPage(video: video, videoList: videoList), // Pass videoList
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // 🎥 Thumbnail
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    video.thumbnail ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF0F0F0F),
                      child: const Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Color(0xFF717171),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),

                // 🕒 Duration Label
                if (video.duration != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        _formatDuration(video.duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),

                // ❤️ Favorite Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      final cubit = context.read<TubeCubit>();
                      if (video.id != null) {
                        cubit.toggleFavoriteTubeVideo(video.id!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error: invalid video ID')),
                        );
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

            // 🧑 Channel + Info
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
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
                        ? const Icon(Icons.person, color: Color(0xFF717171), size: 20)
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
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                video.owner?.channelName ?? 'Unknown Channel',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 12,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (video.owner?.isAccountVerified == true)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Color(0xFFAAAAAA),
                                ),
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
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Color(0xFFF1F1F1), size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      // Show bottom sheet with options
                    },
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