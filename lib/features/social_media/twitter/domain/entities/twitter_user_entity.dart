import 'package:fourtyninehub/core/utils/time_utils.dart';

class TwitterUserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? userName;
  final String? image;
  final String email;
  final bool isDocumented;
  final bool hasStory;
  final DateTime createdAt;
  Duration get publishedDuration => TimeUtils.calculateDuration(createdAt);

  String get sinceTime => TimeUtils.getSinceTime(createdAt);
  TwitterUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.userName,
    required this.createdAt,
    this.image,
    required this.email,
    required this.isDocumented,
    required this.hasStory,
  });
}
