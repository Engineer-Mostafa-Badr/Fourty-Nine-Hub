import 'package:fourtyninehub/core/utils/duration_helper.dart';

class TwitterCommentReplyEntity {
  final String id;
  String? content;
  dynamic user;
  final String post;
  final String image;
  num? loveCount;
  num? totalCount;
  final num repliesCount;
  bool? isReact;
  bool? edit;
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
    this.totalCount = 0,
    this.isReact = false,
    this.edit = false,
    required this.love,
    this.repliesCount = 0,
  });
}
