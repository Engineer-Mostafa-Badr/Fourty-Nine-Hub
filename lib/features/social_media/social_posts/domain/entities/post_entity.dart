import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/main_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_user_model.dart';
import '../../../../../core/utils/duration_helper.dart';
import '../../../../../res/assets/assets.dart';

class PostEntity {
  final String id;
  String? content;
  final String photo;
  final String type;
  final List<String>? images;
  final bool isShared;
  bool? isDocumentation;
  bool? isLove;
  bool? isLikes;
  bool? isWow;
  bool? isSad;
  bool? isAngry;
  bool? isHaha;
  final dynamic user;
  FeelingEntity? feeling;
  ActivityEntity? activity;
  final int privacy;
  final int commentPrivacy;
  num? commentsCount;
  final num sharesCount;
  num? likesCount;
  num? loveCount;
  num? hahaCount;
  num? wowCount;
  num? sadCount;
  num? angryCount;
  num? totalCount;
  String? backgroundColor;
  String? name;
  String? videoMedia;
  String? audioMedia;

  //==>twitter
  List<String>? shares;
  List<TwitterUserModel>? love;
  MainPostEntity? mainPost;
  List<String>? comments;
  bool? isReact;

  //==>Advertisement
  String? advertisementType;
  String? post;
  String? description;
  // num? totalPrice;
  bool? isApproved;

  DateTime? createdAt;
  Duration get publishedDuration => DateTime.now().difference(createdAt!);

  String get sinceTime =>
      DurationHelper().sinceTime(duration: publishedDuration);

  PostEntity({
    required this.id,
    this.content,
    required this.type,
    this.images,
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
    this.love,
    this.mainPost,
    this.comments,
    this.isReact = false,
    this.advertisementType,
    this.post,
    this.description,
    this.name,
    this.videoMedia,
    this.audioMedia,
    this.isApproved = false,
    required this.photo,
  });
}

enum Reactions { like, haha, love, wow, sad, angry }

extension ReactionX on Reactions {
  String value() {
    switch (this) {
      case Reactions.like:
        return 'like';
      case Reactions.haha:
        return 'haha';
      case Reactions.love:
        return 'love';
      case Reactions.wow:
        return 'wow';
      case Reactions.sad:
        return 'sad';
      case Reactions.angry:
        return 'angry';
    }
  }

  String label() {
    switch (this) {
      case Reactions.like:
        return 'Like';
      case Reactions.haha:
        return 'Haha';
      case Reactions.love:
        return 'Love';
      case Reactions.wow:
        return 'Wow';
      case Reactions.sad:
        return 'Sad';
      case Reactions.angry:
        return 'Angry';
    }
  }

  String image() {
    switch (this) {
      case Reactions.like:
        return Assets.like;
      case Reactions.haha:
        return Assets.hand;
      case Reactions.love:
        return Assets.heart;
      case Reactions.wow:
        return Assets.wow;
      case Reactions.sad:
        return Assets.sad;
      case Reactions.angry:
        return Assets.angry;
    }
  }
}
