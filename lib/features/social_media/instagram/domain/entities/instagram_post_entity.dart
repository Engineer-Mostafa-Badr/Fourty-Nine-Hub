class InstagramPostEntity {
  final String id;
  final String content;
  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String? locationName;
  final String? profilePictureUrl;
  final bool verifiedBadge;
  final List<String> medias;
  final List<CommentsEntity> comments;
  final List<UserTagEntity> userTags;
  final List<String> hashtags;
  final int favoritesCounter;
  final int commentsCounter;
  final int likesCounter;
  final String? createdAt;
  final int countOfStory;
  final bool isFriend;

  InstagramPostEntity({
    required this.id,
    required this.content,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.locationName,
    required this.profilePictureUrl,
    required this.verifiedBadge,
    required this.medias,
    required this.comments,
    required this.userTags,
    required this.hashtags,
    required this.favoritesCounter,
    required this.commentsCounter,
    required this.likesCounter,
    required this.createdAt,
    required this.countOfStory,
    required this.isFriend,
  });
}

class UserTagEntity {
  final String username;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;

  UserTagEntity({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
  });
}

class CommentsEntity {
  final String id;

  CommentsEntity({
    required this.id,
  });
}
