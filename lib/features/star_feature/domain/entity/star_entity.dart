import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';

class StarEntity {
  final String id;
  final UserStarEntity user;
  final String videoUrlId;
  final String videoUrlMediaKey;
  final String videoUrlVideo;
  final String title;
  final String description;
  final bool isApproved;
  final num totalViews;
  final num totalRatings;
  final num totalPoints;
  final num averageRating;
  final num averageRatingPercentage;

  StarEntity(
      {required this.id,
      required this.user,
      required this.videoUrlId,
      required this.videoUrlMediaKey,
      required this.videoUrlVideo,
      required this.title,
      required this.description,
      required this.isApproved,
      required this.totalViews,
      required this.totalRatings,
      required this.totalPoints,
      required this.averageRating,
      required this.averageRatingPercentage});
}
