import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/client_details_entity.dart';

import '../../../domain/entities/dashboards/rating_entity.dart';

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({
    required super.firstName,
    required super.profilePictureUrl,
    required super.gender,
    required RatingModell? super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      firstName: json['firstName'],
      profilePictureUrl: json['profilePictureUrl']??'',
      gender: json['gender'],
      rating:
          json['rating'] != null ? RatingModell.fromJson(json['rating']) : null,
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({super.rating, super.comment});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rating: json['rating']?.toDouble(),
      comment: json['comment'],
    );
  }
}
class RatingModell extends RatingEntityy {
  RatingModell({super.average, super.count});

  factory RatingModell.fromJson(Map<String, dynamic> json) {
    return RatingModell(
      average: json['average']?.toDouble(),
      count: json['count'],
    );
  }
}