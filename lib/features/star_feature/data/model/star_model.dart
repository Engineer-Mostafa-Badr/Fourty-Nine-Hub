import 'package:fourtyninehub/features/star_feature/data/model/user_star_model.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

class StarModel extends StarEntity {
  StarModel(
      {required super.id,
      required super.user,
      required super.videoUrlId,
      required super.videoUrlMediaKey,
      required super.videoUrlVideo,
      required super.title,
      required super.description,
      required super.isApproved,
      required super.totalViews,
      required super.totalRatings,
      required super.totalPoints,
      required super.averageRating,
      required super.averageRatingPercentage});

  factory StarModel.fromJson(Map<String, dynamic> json) {
    return StarModel(
      id: json['_id'],
      videoUrlId: json['videoUrl']['_id'] ?? '',
      videoUrlMediaKey: json['videoUrl']['mediaKey'] ?? '',
      videoUrlVideo: json['videoUrl']['video'] ?? '',
      user: UserStarModel.fromJson(json['userId']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isApproved: json['isApprove'] ?? false,
      totalViews: json['totalViews'] ?? 0,
      totalRatings: json['totalRatings'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      averageRating: json['averageRating'] ?? 0,
      averageRatingPercentage: json['averageRatingPercentage'] ?? 0,
    );
  }
}
