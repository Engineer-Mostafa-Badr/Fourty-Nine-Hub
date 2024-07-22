import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_main_post_entity.dart';

class TwitterMainPostModel extends TwitterMainPostEntity {
  TwitterMainPostModel(
      {required super.id,
      required super.content,
      required super.createdAt,
      super.commentsCount,
      super.images,
      super.love,
      super.shares,
      super.isShared,
      super.loveCount,
      super.commentPrivacy,
      super.sharesCount,
      required super.user,
        required super.comments
      });
  factory TwitterMainPostModel.fromJson(Map<String, dynamic> json) {
    return TwitterMainPostModel(
      id: json['_id'],
      content: json['content'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      shares: json['shares'] != null ? List<String>.from(json['shares']) : [],
      love: json['love'] != null ? List<String>.from(json['love']) : [],
      comments: json['comments'] != null ? List<String>.from(json['comments']) : [],
      isShared: json['isShared'] ?? false,
      user: TwitterUserModel.fromJson(json['user']),
      commentPrivacy: json['commentPrivacy'],
      sharesCount: json['sharesCount']??0,
      loveCount: json['loveCount']??0,
      createdAt: DateTime.parse(json['createdAt']),
      commentsCount: json['commentsCount']??0,
      // comments: (json['comments'] as List<dynamic>?)
      //     ?.map((item) => TwitterCommentModel.fromJson(item as Map<String, dynamic>))
      //     .toList() ?? [],
    );
  }
}
