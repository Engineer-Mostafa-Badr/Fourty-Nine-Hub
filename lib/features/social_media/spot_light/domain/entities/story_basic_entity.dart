import 'package:equatable/equatable.dart';


class StoryBasicEntity extends Equatable {
  final String id;
  final bool isViewed;
  final String? type; // 'text', 'image', 'video'
  final String? content; // النص أو رابط الوسائط
  final String? thumbnailUrl;
  final DateTime? createdAt;
  final String? color; // للـ text stories
  final String? fontFamily; // للـ text stories

  const StoryBasicEntity({
    required this.id,
    required this.isViewed,
    this.type,
    this.content,
    this.thumbnailUrl,
    this.createdAt,
    this.color,
    this.fontFamily,
  });

  @override
  List<Object?> get props =>
      [id, isViewed, type, content, thumbnailUrl, createdAt, color, fontFamily];
}