import 'package:fourtyninehub/features/social_media/create_post/data/models/activity_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/feeling_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/location_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/main_post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

class PostModel extends PostEntity {
  PostModel(
      {required super.id,
      super.content,
      super.location,
      super.createdAt,
      super.createAt,
      required super.type,
      super.angryCount,
      super.commentsCount,
      super.images,
      super.users,
      super.isShared,
      super.likesCount,
      super.loveCount,
      super.totalCount,
      super.hahaCount,
      super.sadCount,
      super.commentPrivacy,
      super.privacy,
      super.sharesCount,
      super.isLove,
      super.isLikes,
      super.isWow,
      super.isSad,
      super.isAngry,
      super.isHaha,
      super.activity,
      super.feeling,
      super.backgroundColor,
      super.comments,
      super.firstComment,
      super.love,
      super.isReact,
      super.shares,
      super.isDocumentation,
      super.advertisementType,
      super.post,
      super.description,
      super.mainPost,
      super.isApproved,
      required super.user,
      super.wowCount,
      super.name,
      super.videoMedia,
      super.audioMedia,
      required super.photo});
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id: json['_id'],
        content: json['content'] ?? '',
        location: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
        type: json['type'] ?? '',
        images: json['media'] != null
            ? List<String>.from(json['media'].map(
                (mediaItem) => mediaItem['photo'] ?? mediaItem['mediaKey']))
            : null,
        isShared: json['isShared'] ?? false,
        advertisementType: json['advertisement_type'] ?? '',
        post: json['post'] ?? '',
        description: json['description'] ?? '',
        name: json['name'] ?? '',
        videoMedia: json['videoMedia'] ?? '',
        audioMedia: json['audioMedia'] ?? '',
        // totalPrice: json['totalPrice'] ?? '',
        isApproved: json['isApproved'] ?? false,
        isReact: json['isReact'] ?? false,
        isLove: json['isLove'] ?? false,
        isLikes: json['isLikes'] ?? false,
        isWow: json['isWow'] ?? false,
        isSad: json['isSad'] ?? false,
        isAngry: json['isAngry'] ?? false,
        isHaha: json['isHaha'] ?? false,
        isDocumentation: json['twitter_documentation'] ?? false,
        activity: json['activity'] != null
            ? ActivityModel.fromJson(json['activity'])
            : null,
        feeling: json['feeling'] != null
            ? FeelingModel.fromJson(json['feeling'])
            : null,
        mainPost: json['mainPost'] != null
            ? MainPostModel.fromJson(json['mainPost'])
            : null,
        user: json['user'] == null
            ? null
            : json['user'] is String
                ? json['user']
                : TwitterUserModel.fromJson(json['user']),
        privacy: json['privacy'] ?? 0,
        commentPrivacy: json['commentPrivacy'] ?? 0,
        sharesCount: json['sharesCount'] ?? 0,
        likesCount: json['likesCount'] ?? 0,
        loveCount: json['loveCount'] ?? 0,
        wowCount: json['wowCount'] ?? 0,
        sadCount: json['sadCount'] ?? 0,
        angryCount: json['angryCount'] ?? 0,
        hahaCount: json['hahaCount'] ?? 0,
        totalCount: json['totalCount'] ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        createAt: json['createAt'] ?? '',
        shares: json['shares'] != null ? List<String>.from(json['shares']) : [],
        commentsCount: json['commentsCount'] ?? 0,
        comments: json['comments'] == null
            ? null
            : json['comments'] is List<String>
                ? json['comments'] as List<String>
                : (json['comments'] as List)
                    .map(
                        (e) => e is String ? e : InstagramPostModel.fromJson(e))
                    .toList(),
        firstComment: json['firstComment'] != null
            ? InstagramPostModel.fromJson(json['firstComment'])
            : null,
        love: json['love'] == null
            ? null
            : (json['love'] as List)
                .map((e) => TwitterUserModel.fromJson(e))
                .toList(),
        users: json['with'] == null
            ? null
            : (json['with'] as List)
                .map((e) => TwitterUserModel.fromJson(e))
                .toList(),
        photo: json['photo'] ?? '',
        backgroundColor: json['background_color']);
  }
}
