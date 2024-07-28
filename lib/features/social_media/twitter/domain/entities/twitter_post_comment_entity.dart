import 'package:fourtyninehub/core/utils/duration_helper.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';

class TwitterPostCommentEntity {
  final String id;
  final String user;
  final String content;
  final String post;
  // final String image;
  final bool adminIgnore;
  final num loveCount;
  final num repliesCount;
  bool showReplies;
  bool addReply;
  final List<String> love;
  List<TwitterCommentReplyEntity>? replies;
  final DateTime createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
  TwitterPostCommentEntity({
    required this.adminIgnore,
    required this.id,
    required this.user,
    required this.content,
    required this.post,
    // required this.image,
    required this.createdAt,
    this.loveCount = 0,
    required this.love,
    this.repliesCount = 0,
    this.showReplies=false,
    this.addReply=false,
    this.replies
  });
}
