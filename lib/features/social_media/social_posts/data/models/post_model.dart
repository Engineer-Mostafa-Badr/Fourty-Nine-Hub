import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

class PostModel extends PostEntity {
  PostModel(
      {required super.id,
      required super.content,
      required super.createdAt,
      super.angryCount,
      super.commentsCount,
      super.images,
      super.isShared,
      super.likesCount,
      super.loveCount,
      super.totalCount,
      super.sadCount,
      super.commentPrivacy,
      super.privacy,
      super.sharesCount,
        super.isLove,
        super.isLikes,
        super.isWow,
        super.isSad,
        super.isAngry,
      required super.user,
      super.wowCount});
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'],
      content: json['content'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      isShared: json['isShared'] ?? false,
      isLove: json['isLove'] ?? false,
      isLikes: json['isLikes'] ?? false,
      isWow: json['isWow'] ?? false,
      isSad: json['isSad'] ?? false,
      isAngry: json['isAngry'] ?? false,
      user: TwitterUserModel.fromJson(json['user']),
      privacy: json['privacy'],
      commentPrivacy: json['commentPrivacy'],
      sharesCount: json['sharesCount']??0,
      likesCount: json['likesCount']??0,
      loveCount: json['loveCount']??0,
      wowCount: json['wowCount']??0,
      sadCount: json['sadCount']??0,
      angryCount: json['angryCount']??0,
      totalCount: json['totalCount']??0,
      createdAt: DateTime.parse(json['createdAt']),
      commentsCount: json['commentsCount']??0,
    );
  }
}
