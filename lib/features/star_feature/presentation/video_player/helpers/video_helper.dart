import 'package:flutter/material.dart';

import '../../../data/model/tube_video_models.dart';
import '../../../domain/entity/star_entity.dart';
import '../../presentation_exports.dart';

class VideoHelper {
  /// Load recommended videos for a given video ID
  static Future<List<TubeVideoModel>> loadRecommendedVideos({
    required StarCubit cubit,
    required String videoId,
  }) async {
    try {
      final videos = await cubit.getRecommendedVideos(videoId);
      return videos;
    } catch (e) {
      debugPrint('Error loading recommended videos: $e');
      return [];
    }
  }

  /// Format view count for display
  static String formatViewCount(int viewCount) {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  /// Check if video is liked
  static bool isVideoLiked(StarCubit cubit, String videoId) {
    final video = cubit.getVideoById(videoId);
    return video?.isLike ?? false;
  }

  /// Check if video is disliked
  static bool isVideoDisliked(StarCubit cubit, String videoId) {
    final video = cubit.getVideoById(videoId);
    return video?.isDislike ?? false;
  }

  /// Get video statistics
  static Map<String, dynamic> getVideoStatistics(StarEntity video) {
    return {
      'likes': video.likes,
      'dislikes': video.dislikes,
      'views': video.totalViews,
      'rating': video.averageRating,
    };
  }
}
