import '../../../../core/utils/duration_helper.dart';
import 'user_star_entity.dart';

class StarEntity {
  final String id;
  final UserStarEntity user;
  final List mediaUrl;
  final String title;
  final String description;
  final bool isApproved;
  final num totalViews;
  final num averageRating;
  final bool haveStories;
  final int storyCount;
  final int likes; // Added likes property
  final int dislikes; // Added dislikes property

  DateTime? createdAt;
  String? createAt;

  Duration get publishedDuration =>
      DateTime.now().difference(createdAt ?? DateTime.now());

  String get sinceTime =>
      DurationHelper().getTimeDifference(createdAt ?? DateTime.now());

  StarEntity({
    required this.id,
    required this.user,
    required this.mediaUrl,
    required this.title,
    required this.description,
    required this.isApproved,
    required this.totalViews,
    required this.averageRating,
    required this.haveStories,
    required this.storyCount,
    this.likes = 0, // Default value for likes
    this.dislikes = 0, // Default value for dislikes
    this.createdAt,
    this.createAt,
  });

  StarEntity copyWith({
    String? id,
    UserStarEntity? user,
    List? mediaUrl,
    String? title,
    String? description,
    bool? isApproved,
    num? totalViews,
    num? averageRating,
    bool? haveStories,
    int? storyCount,
    int? likes, // Added likes parameter
    int? dislikes, // Added dislikes parameter
    DateTime? createdAt,
    String? createAt,
  }) =>
      StarEntity(
        id: id ?? this.id,
        user: user ?? this.user,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        isApproved: isApproved ?? this.isApproved,
        totalViews: totalViews ?? this.totalViews,
        averageRating: averageRating ?? this.averageRating,
        haveStories: haveStories ?? this.haveStories,
        storyCount: storyCount ?? this.storyCount,
        likes: likes ?? this.likes, // Added likes assignment
        dislikes: dislikes ?? this.dislikes, // Added dislikes assignment
        createdAt: createdAt ?? this.createdAt,
        createAt: createAt ?? this.createAt,
      );
}

class MediaUrlEntity {
  final String id;
  final String mediaKey;
  final Duration? duration;
  final String? mediaType;

  MediaUrlEntity({
    required this.id,
    required this.mediaKey,
    this.duration,
    this.mediaType,
  });

  bool get isVideo => mediaType?.toLowerCase().contains('video') ?? false;

  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
