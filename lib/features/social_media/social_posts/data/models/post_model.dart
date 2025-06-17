import 'package:fourtyninehub/features/social_media/create_post/data/models/activity_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/feeling_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/audio_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/location_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/main_post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';

import 'life_event_post_model.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    super.content,
    super.location,
    super.photo,
    super.type,
    super.gifUrl,
    super.lifeEvent,
    super.images,
    super.users,
    super.likedUsers,
    super.sadUsers,
    super.wowUsers,
    super.hahaUsers,
    super.angryUsers,
    super.loveUsers,
    super.audio,
    super.isShared,
    super.isDocumentation,
    super.isLove,
    super.isLikes,
    super.isWow,
    super.isSad,
    super.isAngry,
    super.isHaha,
    required super.user,
    super.feeling,
    super.activity,
    super.privacy,
    super.commentPrivacy,
    super.commentsCount,
    super.sharesCount,
    super.likesCount,
    super.loveCount,
    super.hahaCount,
    super.wowCount,
    super.sadCount,
    super.angryCount,
    super.totalCount,
    super.backgroundColor,
    super.name,
    super.videoMedia,
    super.audioMedia,
    super.shares,
    super.mainPost,
    super.comments,
    super.firstComment,
    super.isReact,
    super.advertisementType,
    super.post,
    super.description,
    super.isApproved,
    super.createdAt,
    super.createAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final user = TwitterUserModel.fromJson(json['owner']??json['user']);

    List<TwitterUserModel> parseUserList(dynamic data) {
      if (data is List) {
        return data.map((item) => TwitterUserModel.fromJson(item)).toList();
      }
      return [];
    }

    List<String> parseMediaList(dynamic data) {
      if (data is List) {
        return data.map((m) {
          return m['mediaKey']?.toString() ?? m['photo']?.toString() ?? '';
        }).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    return PostModel(
      id: json['_id']?.toString() ?? '',
      content: json['content']?.toString(),
      location: json['location'] is Map ? LocationModel.fromJson(json['location']) : null,
      photo: user.image,
      type: json['type']?.toString() ?? 'normal_post',
      gifUrl: json['gifUrl']?.toString(),
      lifeEvent: json['liveEvent'] != null || json['liveEventPostId'] != null
          ? LifeEventPostModel.fromJson(json['liveEvent'] ?? {'_id': json['liveEventPostId']})
          : null,
      images: parseMediaList(json['media']),
      users: parseUserList(json['tags']),
      likedUsers: parseUserList(json['likes']),
      sadUsers: parseUserList(json['sad']),
      wowUsers: parseUserList(json['wow']),
      hahaUsers: parseUserList(json['haha']),
      angryUsers: parseUserList(json['angry']),
      loveUsers: parseUserList(json['love']),
      audio: json['audioId'] != null && json['audioId'] != ''
          ? [AudioModel(id: json['audioId'].toString(), mediaKey: '', sound: '')]
          : [], // Handle null or empty audioId
      isShared: json['isShared'] == true,
      isDocumentation: json['twitter_documentation'] == true,
      isLove: json['isLove'] == true,
      isLikes: json['isLikes'] == true,
      isWow: json['isWow'] == true,
      isSad: json['isSad'] == true,
      isAngry: json['isAngry'] == true,
      isHaha: json['isHaha'] == true,
      user: user,
      feeling: json['feeling'] is Map ? FeelingModel.fromJson(json['feeling']) : null,
      activity: json['activity'] is Map ? ActivityModel.fromJson(json['activity']) : null,
      privacy: (json['privacy'] as num?)?.toInt() ?? 1,
      commentPrivacy: (json['commentPrivacy'] as num?)?.toInt() ?? 2,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      sharesCount: (json['sharesCount'] as num?)?.toInt() ?? 0,
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      loveCount: (json['loveCount'] as num?)?.toInt() ?? 0,
      hahaCount: (json['hahaCount'] as num?)?.toInt() ?? 0,
      wowCount: (json['wowCount'] as num?)?.toInt() ?? 0,
      sadCount: (json['sadCount'] as num?)?.toInt() ?? 0,
      angryCount: (json['angryCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      backgroundColor: json['background_color']?.toString(),
      name: json['name']?.toString(),
      videoMedia: json['videoMedia']?.toString(),
      audioMedia: json['audioMedia']?.toString(),
      shares: (json['shares'] as List?)?.map((s) => s.toString()).toList() ?? [],
      mainPost: json['mainPost'] is Map ? MainPostModel.fromJson(json['mainPost']) : null,
      comments: (json['comments'] as List?)?.map((c) {
        return c is String ?  InstagramPostModel.fromJson(json['firstComment']) : InstagramPostModel.fromJson(c);
      }).toList() ?? [],
      firstComment: json['firstComment'] is Map
          ? InstagramPostModel.fromJson(json['firstComment'])
          : null,
      isReact: json['isReact'] == true,
      advertisementType: json['advertisement_type']?.toString(),
      post: json['post']?.toString(),
      description: json['description']?.toString(),
      isApproved: json['isApproved'] == true,
      createdAt: json['createdAt'] is String ? DateTime.tryParse(json['createdAt']) : null,
      createAt: json['createAt'] is String ? DateTime.tryParse(json['createAt']) : null,
    );
  }
}
