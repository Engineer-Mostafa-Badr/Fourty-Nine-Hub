import 'package:fourtyninehub/core/utils/duration_helper.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';

class StarEntity {
  final String id;
  final UserStarEntity user;
  final List<MediaUrlEntity> mediaUrl;
  final String title;
  final String description;
  final bool isApproved;
  final num totalViews;
  final num averageRating;

  DateTime? createdAt;
  String? createAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt!);

  String get sinceTime =>
      DurationHelper().getTimeDifference( createdAt!);

  StarEntity(
      {required this.id,
      required this.user,
      required this.mediaUrl,
      required this.title,
      required this.description,
      required this.isApproved,
      required this.totalViews,
      required this.averageRating,
        this.createdAt,
        this.createAt,
      });
}


class MediaUrlEntity{
  final String id;
  final String mediaKey;

  MediaUrlEntity({required this.id, required this.mediaKey});
}