import 'package:fourtyninehub/core/utils/duration_helper.dart';

class TwitterCommentReplyEntity {
  final String id;
  final String content;
  final String user;
  final String post;
  final String image;
  num? loveCount;
  final num repliesCount;
  bool? isReact;
  final List<String> love;
  final DateTime createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
  TwitterCommentReplyEntity({
    required this.id,
    required this.user,
    required this.content,
    required this.post,
    required this.image,
    required this.createdAt,
    this.loveCount = 0,
    this.isReact = false,
    required this.love,
    this.repliesCount = 0,
  });
}
