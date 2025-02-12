import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';

class FacebookFeedEntity {
  final List<PostEntity>? posts;
  final List<Reel>? reels;
  final List<PostEntity>? tweets;
  final List<PostEntity>? ads;
  final List<SuggestUserEntity>? suggestedFriends;

  FacebookFeedEntity({ this.posts,  this.reels,  this.tweets, this.suggestedFriends, this.ads});

}