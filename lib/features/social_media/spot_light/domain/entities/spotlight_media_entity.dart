import 'package:equatable/equatable.dart';

enum MediaType { image, video, story }

enum MediaStatus { pending, uploading, completed, failed }

class SpotlightMediaEntity extends Equatable {
  final String id;
  final String userId;
  final MediaType type;
  final String? thumbnailUrl;
  final String? mediaUrl;
  final String? caption;
  final MediaStatus status;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SpotlightMediaEntity({
    required this.id,
    required this.userId,
    required this.type,
    this.thumbnailUrl,
    this.mediaUrl,
    this.caption,
    required this.status,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        thumbnailUrl,
        mediaUrl,
        caption,
        status,
        likesCount,
        commentsCount,
        isLiked,
        createdAt,
        updatedAt,
      ];
}