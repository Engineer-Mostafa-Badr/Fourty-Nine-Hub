import '../../../../../core/utils/duration_helper.dart';
import '../../data/models/twitter_user_model.dart';
import 'twitter_comment_reply_entity.dart';

class TwitterPostCommentEntity {
  final String id;
  dynamic user;
  String? content;
  final String post;
  // final String image;
  final bool adminIgnore;
  num? loveCount;
  final num repliesCount;
  bool showReplies;
  bool addReply;
  bool? isReact;
  bool? yourReposted;
  bool? edit;
  final List<String> love;
  List<TwitterCommentReplyEntity>? replies;
  final DateTime createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt);
  TwitterUserModel? ownerData;
  Map<String, dynamic>? postData;

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);
  TwitterPostCommentEntity(
      {required this.adminIgnore,
      required this.id,
      required this.user,
      required this.content,
      required this.post,
      // required this.image,
      required this.createdAt,
      this.loveCount = 0,
      required this.love,
      this.repliesCount = 0,
      this.showReplies = false,
      this.addReply = false,
      this.isReact = false,
      this.yourReposted = false,
      this.edit = false,
      this.replies,
        this.ownerData,
        this.postData

      });

  //toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'content': content,
        'post': post,
        // 'image': image,
        'adminIgnore': adminIgnore,
        'loveCount': loveCount,
        'repliesCount': repliesCount,
        'showReplies': showReplies,
        'addReply': addReply,
        'isReact': isReact,
        'yourReposted': yourReposted,
        'edit': edit,
        'love': love,
        'replies': replies?.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };
}
