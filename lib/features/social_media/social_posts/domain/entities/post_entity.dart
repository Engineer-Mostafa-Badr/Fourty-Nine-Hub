import '../../../create_post/domain/entities/activity_entity.dart';
import '../../../create_post/domain/entities/feeling_entity.dart';
import '../../../instagram/domain/entities/instagram_post_entity.dart';
import '../../data/models/location_model.dart';
import 'audio_entity.dart';
import 'life_event_post_entity.dart';
import 'main_post_entity.dart';
import '../../../twitter/data/models/twitter_user_model.dart';

import '../../../../../res/assets/assets.dart';

class PostEntity {
  final String id;
  final String? content;
  final LocationModel? location;
  final String? photo;
  final String type;
  final String? gifUrl;
  final LifeEventPostEntity? lifeEvent;
  final List<String> images;
  final List<TwitterUserModel> users;
  final List<TwitterUserModel> likedUsers;
  final List<TwitterUserModel> sadUsers;
  final List<TwitterUserModel> wowUsers;
  final List<TwitterUserModel> hahaUsers;
  final List<TwitterUserModel> angryUsers;
  final List<TwitterUserModel> loveUsers;
  final List<AudioEntity> audio;
  final bool isShared;
  final bool isDocumentation;
  final bool isLove;
  final bool isLikes;
  final bool isWow;
  final bool isSad;
  final bool isAngry;
  final bool isHaha;
  final TwitterUserModel user;
  final FeelingEntity? feeling;
  final ActivityEntity? activity;
  final int privacy;
  final int commentPrivacy;
  final int commentsCount;
  final int sharesCount;
  final int likesCount;
  final int loveCount;
  final int hahaCount;
  final int wowCount;
  final int sadCount;
  final int angryCount;
  final int totalCount;
  final String? backgroundColor;
  final String? name;
  final String? videoMedia;
  final String? audioMedia;
  final List<String> shares;
  final MainPostEntity? mainPost;
  final List<InstagramPostEntity> comments;
  final InstagramPostEntity? firstComment;
  final bool isReact;
  final String? advertisementType;
  final String? post;
  final String? description;
  final bool isApproved;
  final DateTime? createdAt;
  final DateTime? createAt;

  PostEntity({
    required this.id,
    this.content,
    this.location,
    this.photo,
    this.type = 'normal_post',
    this.gifUrl,
    this.lifeEvent,
    this.images = const [],
    this.users = const [],
    this.likedUsers = const [],
    this.sadUsers = const [],
    this.wowUsers = const [],
    this.hahaUsers = const [],
    this.angryUsers = const [],
    this.loveUsers = const [],
    this.audio = const [],
    this.isShared = false,
    this.isDocumentation = false,
    this.isLove = false,
    this.isLikes = false,
    this.isWow = false,
    this.isSad = false,
    this.isAngry = false,
    this.isHaha = false,
    required this.user,
    this.feeling,
    this.activity,
    this.privacy = 1,
    this.commentPrivacy = 2,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.likesCount = 0,
    this.loveCount = 0,
    this.hahaCount = 0,
    this.wowCount = 0,
    this.sadCount = 0,
    this.angryCount = 0,
    this.totalCount = 0,
    this.backgroundColor,
    this.name,
    this.videoMedia,
    this.audioMedia,
    this.shares = const [],
    this.mainPost,
    this.comments = const [],
    this.firstComment,
    this.isReact = false,
    this.advertisementType,
    this.post,
    this.description,
    this.isApproved = false,
    this.createdAt,
    this.createAt,
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
