import '../../../twitter/data/models/twitter_user_model.dart';

import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel(
      {required super.id,
      required super.content,
      required super.post,
      required super.createdAt,
      super.reply,
      super.replies,
      super.angryCount,
      super.likesCount,
      super.loveCount,
      super.repliesCount,
      super.remainingRepliesCount,
      super.totalCount,
      super.sadCount,
      super.hahaCount,
      required super.user,
      super.isLove,
      super.isLikes,
      super.isWow,
      super.isSad,
      super.isAngry,
      super.edit,
      super.isHaha,
      super.wowCount});
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      content: json['content'],
      replies: json['replies']??[],
      reply: json['reply'] ?? '',
      post: json['post'] != null
          ? json['post'] is String
              ? json['post']
              : ''
          : '',
      isLove: json['isLove'] ?? false,
      isLikes: json['isLikes'] ?? false,
      user: json['user'] is String
          ? json['user']
          : TwitterUserModel.fromJson(json['user']),
      isWow: json['isWow'] ?? false,
      isSad: json['isSad'] ?? false,
      isHaha: json['isHaha'] ?? false,
      isAngry: json['isAngry'] ?? false,
      likesCount: json['likesCount'] ?? 0,
      loveCount: json['loveCount'] ?? 0,
      wowCount: json['wowCount'] ?? 0,
      hahaCount: json['hahaCount'] ?? 0,
      sadCount: json['sadCount'] ?? 0,
      angryCount: json['angryCount'] ?? 0,
      repliesCount: json['repliesCount'] ?? 0,
      remainingRepliesCount: json['repliesCount'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  //toJson
  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'post': post,
      'isLove': isLove,
      'isLikes': isLikes,
      'user': user,
      'isWow': isWow,
      'isSad': isSad,
      'isHaha': isHaha,
      'isAngry': isAngry,
      'likesCount': likesCount,
      'loveCount': loveCount,
      'wowCount': wowCount,
      'hahaCount': hahaCount,
      'sadCount': sadCount,
      'angryCount': angryCount,
      'repliesCount': repliesCount,
      'totalCount': totalCount,
      'createdAt': createdAt,
    };
  }
}
