import 'rating_entity.dart';

class ClientDetailsEntity {
  final String firstName;
  final String profilePictureUrl;
  final String gender;
  final RatingEntityy? rating;

  ClientDetailsEntity({
    required this.firstName,
    required this.profilePictureUrl,
    required this.gender,
    required this.rating,
  });
}
