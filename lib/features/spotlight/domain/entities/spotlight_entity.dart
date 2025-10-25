// spotlight_entity.dart
class SpotlightEntity {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final DateTime? birthday;
  final String? profilePictureUrl;
  final String? coverPictureUrl;
  final num viewCount;
  final String? aboutMe;
  final String? lookingFor;
  final String? distance;
  final num? height;
  final String? university;
  final String? smoking;
  final String? workout;
  final List<String> pets;
  final String? education;
  final String? zodiac;
  final List<String> interests;
  final bool isFriend;

  const SpotlightEntity({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.birthday,
    this.profilePictureUrl,
    this.coverPictureUrl,
    required this.viewCount,
    this.aboutMe,
    this.lookingFor,
    this.distance,
    this.height,
    this.university,
    this.smoking,
    this.workout,
    this.pets = const [],
    this.education,
    this.zodiac,
    this.interests = const [],
    required this.isFriend,
  });
}
