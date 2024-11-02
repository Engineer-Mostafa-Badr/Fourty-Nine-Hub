import 'package:fourtyninehub/features/star_feature/data/model/user_star_model.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_winner_entity.dart';

class StarWinnerModel extends StarWinnerEntity {
    StarWinnerModel(
      {required super.id,
      required super.user,
      required super.videoUrlId,
      required super.videoUrlMediaKey,
      required super.videoUrlVideo,
      required super.title,
      required super.description,
      required super.years,
      required super.totalViews,
      required super.month,
      required super.totalPoints,
      required super.averageRating,
      required super.averageRatingPercentage,
          super.createdAt,
          super.createAt,
      });

  factory StarWinnerModel.fromJson(Map<String, dynamic> json) {
      return StarWinnerModel(
          id: json['_id'],
          videoUrlId: json['videoUrl']['_id'] ??'',
          videoUrlMediaKey: json['videoUrl']['mediaKey'] ??'',
          videoUrlVideo: json['videoUrl']['video'] ??'',
          user: UserStarModel.fromJson(json['userId']),
          title: json['title'] ??'',
          description: json['description'] ??'',
        years: json['year'] ??false,
          totalViews: json['totalViews'] ??0,
        month: json['month'] ??0,
          totalPoints: json['totalPoints'] ??0,
          averageRating: json['averageRating'] ??0,
          averageRatingPercentage: json['averageRatingPercentage'] ??0,
          createAt: json['createAt']??'',
          createdAt: json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : null,
      );
  }
}
