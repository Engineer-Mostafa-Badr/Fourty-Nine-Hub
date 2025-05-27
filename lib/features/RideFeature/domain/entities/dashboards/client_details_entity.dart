import 'rating_entity.dart';

class ClientDetailsEntity {
  final String id;
  final String firstName;
  final String profilePictureUrl;
  final String gender;
  DriverRatingEntity? rating;

  ClientDetailsEntity({
    required this.id,
    required this.firstName,
    required this.profilePictureUrl,
    required this.gender,
    this.rating,
  });
}
