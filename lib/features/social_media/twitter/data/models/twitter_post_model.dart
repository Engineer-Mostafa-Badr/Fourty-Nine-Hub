import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_main_post_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

import '../../domain/entities/twitter_post_entity.dart';

class TwitterPostModel extends TwitterPostEntity {
  TwitterPostModel(
      {required super.id,
      required super.content,
      super.postShare,
      required super.createdAt,
      super.commentsCount,
      super.images,
      super.love,
      super.shares,
      super.isShared,
      super.isReact,
      super.photo,
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
      postShare: json['mainPost'] != null
          ? TwitterMainPostModel.fromJson(json['mainPost'])
          : null,
      images: json['media'] != null
          ? List<String>.from(
              json['media'].map((mediaItem) => mediaItem['photo']))
          : [],
      shares: json['shares'] != null ? List<String>.from(json['shares']) : [],
      love: (json['love'] as List)
          .map((e) => TwitterUserModel.fromJson(e))
          .toList(),
      isShared: json['isShared'] ?? false,
      isReact: json['isReact'] ?? false,
      photo: json['photo'] ?? '',
      mainPost: json['mainPost'] != null
          ? (json['mainPost'] is Map<String, dynamic>)
              ? TwitterMainPostModel.fromJson(json['mainPost']) // Single post
              : (json['mainPost'] is List<dynamic>)
                  ? json['mainPost']
                      .map((item) => TwitterMainPostModel.fromJson(item))
                      .toList() // Multiple posts
                  : null
          : null,
      user: json['user'] is String
          ? json['user']
          : TwitterUserModel.fromJson(json['user']),
      commentPrivacy: json['commentPrivacy'],
      sharesCount: json['sharesCount'] ?? 0,
      loveCount: json['loveCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      commentsCount: json['commentsCount'] ?? 0,
      comments:
          json['comments'] != null ? List<String>.from(json['comments']) : [],
      // comments: (json['comments'] as List<dynamic>?)
      //     ?.map((item) => TwitterCommentModel.fromJson(item as Map<String, dynamic>))
      //     .toList() ?? [],
    );
  }
}
