import 'twitter_user_entity.dart';

import '../../../../../core/utils/duration_helper.dart';

class TwitterCommentEntity {
  final String id;
  final TwitterUserEntity user;
  final String content;
  final String post;
  final num likesCount;
  final num loveCount;
  final num wowCount;
  final num sadCount;
  final num angryCount;
  final num repliesCount;
  final DateTime createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
  TwitterCommentEntity({
    required this.id,
    required this.user,
    required this.content,
    required this.post,
    required this.createdAt,
    this.likesCount = 0,
    this.loveCount = 0,
    this.wowCount = 0,
    this.sadCount = 0,
    this.angryCount = 0,
    this.repliesCount = 0,
  });
}
