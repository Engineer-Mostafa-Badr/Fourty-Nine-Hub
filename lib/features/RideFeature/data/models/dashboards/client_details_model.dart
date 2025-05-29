import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/client_details_entity.dart';

import '../../../domain/entities/dashboards/rating_entity.dart';

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({
    required super.id,
    required super.firstName,
    required super.profilePictureUrl,
    required super.gender,
    super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      id: json['id']??'',
      firstName: json['firstName']??'',
      profilePictureUrl: json['profilePictureUrl']??'',
      gender: json['gender']??'',
      rating:
          json['rating'] != null ? DriverRatingModel.fromJson(json['rating']) : null,
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({super.id,super.rating, super.comment});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id']??'',
      rating: json['rating']??0.0,
      comment: json['comment']??'',
    );
  }
}

class DriverRatingModel extends DriverRatingEntity {
  DriverRatingModel({required super.count,required super.average});

  factory DriverRatingModel.fromJson(Map<String, dynamic> json) {
    return DriverRatingModel(
      count: json['count']??0,
      average: json['average']??0.0,
    );
  }
}
class RatingModell extends RatingEntityy {
  RatingModell({super.id,super.average, super.count});

  factory RatingModell.fromJson(Map<String, dynamic> json) {
    return RatingModell(
      id: json['id']??'',
      average: json['average']??0,
      count: json['count']??0,
    );
  }
}