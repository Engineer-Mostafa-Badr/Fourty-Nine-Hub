import '../../../reels/data/models/new_reels_model.dart';
import 'post_entity.dart';
import 'suggest_user_entity.dart';

class FacebookFeedEntity {
  final List<PostEntity>? posts;
  final List<Reel>? reels;
  final List<PostEntity>? tweets;
  final List<PostEntity>? ads;
  final List<SuggestUserEntity>? suggestedFriends;

  FacebookFeedEntity({ this.posts,  this.reels,  this.tweets, this.suggestedFriends, this.ads});
}