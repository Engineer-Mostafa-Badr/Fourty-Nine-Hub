import '../../../../core/utils/duration_helper.dart';
import 'user_star_entity.dart';

class StarEntity {
  final String id;
  final UserStarEntity user;
  final List<MediaUrlEntity> mediaUrl;
  final String title;
  final String description;
  final bool isApproved;
  final num totalViews;
  final num averageRating;
  final bool haveStories;
  final int storyCount;

  DateTime? createdAt;
  String? createAt;

  Duration get publishedDuration => DateTime.now().difference(createdAt!);

  String get sinceTime => DurationHelper().getTimeDifference(createdAt!);

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
    this.createdAt,
    this.createAt,
  });

  StarEntity copyWith({
    String? id,
    UserStarEntity? user,
    List<MediaUrlEntity>? mediaUrl,
    String? title,
    String? description,
    bool? isApproved,
    num? totalViews,
    num? averageRating,
    bool? haveStories,
    int? storyCount, required DateTime createdAt,
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
