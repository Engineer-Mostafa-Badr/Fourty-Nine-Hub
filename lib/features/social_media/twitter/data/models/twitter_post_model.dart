import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_main_post_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

import '../../domain/entities/twitter_post_entity.dart';

class TwitterPostModel extends TwitterPostEntity {
  TwitterPostModel(
      {required super.id,
      required super.content,
      required super.createdAt,
      super.commentsCount,
      super.images,
      super.love,
      super.shares,
      super.isShared,
      required super.mainPost,
      super.loveCount,
      super.commentPrivacy,
      super.sharesCount,
      required super.user,
        required super.comments});
  factory TwitterPostModel.fromJson(Map<String, dynamic> json) {
    return TwitterPostModel(
      id: json['_id'],
      content: json['content'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      shares: json['shares'] != null ? List<String>.from(json['shares']) : [],
      love: (json['love'] as List)
          .map((e) => TwitterUserModel.fromJson(e))
          .toList(),
      isShared: json['isShared'] ?? false,
      mainPost: json['mainPost'] != null
          ? TwitterMainPostModel.fromJson(json['mainPost'] )
          : null,
      user: TwitterUserModel.fromJson(json['user']),
      commentPrivacy: json['commentPrivacy'],
      sharesCount: json['sharesCount']??0,
      loveCount: json['loveCount']??0,
      createdAt: DateTime.parse(json['createdAt']),
      commentsCount: json['commentsCount']??0,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((item) => TwitterCommentModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}
