import 'package:fourtyninehub/core/utils/duration_helper.dart';

class TwitterCommentReplyEntity {
  final String id;
  String? content;
  String? reply;
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
    this.reply,
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

  //toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'content': content,
        'reply': reply,
        'post': post,
        'image': image,
        'loveCount': loveCount,
        'totalCount': totalCount,
        'isReact': isReact,
        'edit': edit,
        'love': love,
        'repliesCount': repliesCount,
        'createdAt': createdAt.toIso8601String(),
      };
}
