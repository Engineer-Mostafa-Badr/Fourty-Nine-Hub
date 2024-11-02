import 'package:fourtyninehub/core/utils/duration_helper.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';

class StarWinnerEntity {
  final String id;
  final UserStarEntity user;
  final String videoUrlId;
  final String videoUrlMediaKey;
  final String videoUrlVideo;
  final String title;
  final String description;
  final num years;
  final num month;
  final num totalViews;
  final num totalPoints;
  final num averageRating;
  final num averageRatingPercentage;

  DateTime? createdAt;
  String? createAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt!);

  String get sinceTime =>
      DurationHelper().getTimeDifference( createdAt!);

  StarWinnerEntity(
      {required this.id,
      required this.user,
      required this.videoUrlId,
      required this.videoUrlMediaKey,
      required this.videoUrlVideo,
      required this.title,
      required this.description,
      required this.years,
      required this.totalViews,
      required this.month,
      required this.totalPoints,
      required this.averageRating,
      required this.averageRatingPercentage,
        this.createdAt,
        this.createAt,
      });
}
