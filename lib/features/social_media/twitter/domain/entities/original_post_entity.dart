 import '../../data/models/twitter_user_model.dart';

class TwitterOriginalPost {
  final String postId;
  final String? content;
  final List<String> media;
  final int likesCount;
  final int repliesCount;
  final int repostCount;
  final bool youLiked;
  final bool yourReposted;
  final TwitterUserModel owner;

  const TwitterOriginalPost({
    required this.postId,
    this.content,
    this.media = const [],
    this.likesCount = 0,
    this.repliesCount = 0,
    this.repostCount = 0,
    this.youLiked = false,
    this.yourReposted = false,
    required this.owner,
  });
}

