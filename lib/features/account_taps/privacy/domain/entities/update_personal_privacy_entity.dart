class UpdatePersonalPrivacyDataEntity {
  final String? id;
  final String? userId;
  final String? profile;
  final String? posts;
  final String? stories;
  final String? reels;
  final String? chat;
  final String? friendRequests;
  final String? followerRequests;
  final String? friendsList;
  final String? followerList;
  final Map<String, dynamic>? allowedUsers;
  final Map<String, dynamic>? forbiddenUsers;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? country;
  final String? city;
  final String? job;
  final String? birthDay;
  final String? language;
  final String? showPosts;
  final String? showStories;
  final String? showReels;
  final String? writeComments;
  final String? receiveCalls;
  final String? receiveSocialMessages;
  final String? receiveGreetMessages;
  final String? receiveAnonymousMessages;
  final String? lastSeen;
  final String? randomAppearance;

  UpdatePersonalPrivacyDataEntity({
    this.id,
    this.userId,
    this.profile,
    this.posts,
    this.stories,
    this.reels,
    this.chat,
    this.friendRequests,
    this.followerRequests,
    this.friendsList,
    this.followerList,
    this.allowedUsers,
    this.forbiddenUsers,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.email,
    this.phoneNumber,
    this.gender,
    this.country,
    this.city,
    this.job,
    this.birthDay,
    this.language,
    this.showPosts,
    this.showStories,
    this.showReels,
    this.writeComments,
    this.receiveCalls,
    this.receiveSocialMessages,
    this.receiveGreetMessages,
    this.receiveAnonymousMessages,
    this.lastSeen,
    this.randomAppearance,
  });
}
