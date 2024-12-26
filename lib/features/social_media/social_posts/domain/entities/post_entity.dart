import 'package:fourtyninehub/core/utils/time_utils.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/instagram_post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/location_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/audio_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import '../../../../../res/assets/assets.dart';

class PostEntity {
  final String id;
  String? content;
  LocationModel? location;
  final String photo;
  final String type;
  final List<String>? images;
  final List<TwitterUserModel>? users;
  final List<TwitterUserModel>? likedUsers;
  final List<TwitterUserModel>? sadUsers;
  final List<TwitterUserModel>? wowUsers;
  final List<TwitterUserModel>? hahaUsers;
  final List<TwitterUserModel>? angryUsers;
  final List<TwitterUserModel>? loveUsers;
  List<AudioEntity>? audio;
  final bool isShared;
  bool isDocumentation;
  bool isLove;
  bool isLikes;
  bool isWow;
  bool isSad;
  bool isAngry;
  bool isHaha;
  final dynamic user;
  FeelingEntity? feeling;
  ActivityEntity? activity;
  final int privacy;
  final int commentPrivacy;
  num commentsCount;
  final num sharesCount;
  num likesCount;
  num loveCount;
  num hahaCount;
  num wowCount;
  num sadCount;
  num angryCount;
  num totalCount;
  String? backgroundColor;
  String? name;
  String? videoMedia;
  String? audioMedia;

  // Twitter-specific
  List<String>? shares;
  MainPostEntity? mainPost;
  List<dynamic>? comments;
  InstagramPostEntity? firstComment;
  bool isReact;

  // Advertisement-specific
  String? advertisementType;
  String? post;
  String? description;
  bool isApproved;

  DateTime? createdAt;
  DateTime? createAt;

  Duration get publishedDuration => TimeUtils.calculateDuration(createdAt);

  String get sinceTime => TimeUtils.getSinceTime(createdAt);

  PostEntity({
    required this.id,
    this.content,
    this.location,
    required this.type,
    this.images,
    this.users,
    this.firstComment,
    required this.user,
    this.commentPrivacy = 1,
    this.privacy = 1,
    this.isShared = false,
    this.isLove = false,
    this.isLikes = false,
    this.isWow = false,
    this.isSad = false,
    this.isAngry = false,
    this.isDocumentation = false,
    this.isHaha = false,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.likesCount = 0,
    this.loveCount = 0,
    this.wowCount = 0,
    this.sadCount = 0,
    this.angryCount = 0,
    this.hahaCount = 0,
    this.totalCount = 0,
    this.createdAt,
    this.feeling,
    this.activity,
    this.backgroundColor,
    this.shares,
    this.mainPost,
    this.comments,
    this.isReact = false,
    this.advertisementType,
    this.post,
    this.description,
    this.name,
    this.videoMedia,
    this.audioMedia,
    this.createAt,
    this.isApproved = false,
    required this.photo,
    required this.angryUsers,
    required this.hahaUsers,
    required this.likedUsers,
    required this.loveUsers,
    required this.sadUsers,
    required this.wowUsers,
    required this.audio,
  });
}

enum Reaction { like, haha, love, wow, sad, angry }

extension ReactionX on Reaction {
  String value() {
    switch (this) {
      case Reaction.like:
        return 'like';
      case Reaction.haha:
        return 'haha';
      case Reaction.love:
        return 'love';
      case Reaction.wow:
        return 'wow';
      case Reaction.sad:
        return 'sad';
      case Reaction.angry:
        return 'angry';
    }
  }

  String label() {
    switch (this) {
      case Reaction.like:
        return 'Like';
      case Reaction.haha:
        return 'Haha';
      case Reaction.love:
        return 'Love';
      case Reaction.wow:
        return 'Wow';
      case Reaction.sad:
        return 'Sad';
      case Reaction.angry:
        return 'Angry';
    }
  }

  String image() {
    switch (this) {
      case Reaction.like:
        return Assets.like;
      case Reaction.haha:
        return Assets.hand;
      case Reaction.love:
        return Assets.heart;
      case Reaction.wow:
        return Assets.wow;
      case Reaction.sad:
        return Assets.sad;
      case Reaction.angry:
        return Assets.angry;
    }
  }
}
