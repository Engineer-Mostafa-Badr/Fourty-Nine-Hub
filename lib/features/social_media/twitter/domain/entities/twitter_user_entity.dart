import '../../../../../core/utils/duration_helper.dart';

class TwitterUserEntity {
  final String id;
  final String firstName;
  final String lastName;
  // final dynamic profilePicture;
  final num loveCount;
  final DateTime createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
  TwitterUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    // required this.profilePicture,
    this.loveCount = 0,
  });
}
