import '../../domain/entities/update_personal_privacy_entity.dart';


class UpdatePersonalPrivacyDataModel extends UpdatePersonalPrivacyDataEntity {
  UpdatePersonalPrivacyDataModel({
    super.id,
    super.userId,
    super.profile,
    super.posts,
    super.stories,
    super.reels,
    super.chat,
    super.friendRequests,
    super.followerRequests,
    super.friendsList,
    super.followerList,
    super.allowedUsers,
    super.forbiddenUsers, // New field for forbiddenUsers
    super.createdAt,
    super.updatedAt,
    super.v,
    super.email,
    super.phoneNumber,
    super.gender,
    super.country,
    super.city,
    super.job,
    super.birthDay,
    super.language,
    super.showPosts,
    super.showStories,
    super.showReels,
    super.writeComments,
    super.receiveCalls,
    super.receiveSocialMessages,
    super.receiveGreetMessages,
    super.receiveAnonymousMessages,
    super.lastSeen, // New field for lastSeen
    super.randomAppearance, // New field for randomAppearance
  });

  factory UpdatePersonalPrivacyDataModel.fromJson(Map<String, dynamic> json) {
    return UpdatePersonalPrivacyDataModel(
      id: json['_id'],
      userId: json['userId'],
      profile: json['profile'],
      posts: json['posts'],
      stories: json['stories'],
      reels: json['reels'],
      chat: json['chat'],
      friendRequests: json['friendRequests'],
      followerRequests: json['followerRequests'],
      friendsList: json['friendsList'],
      followerList: json['followerList'],
      allowedUsers: json['privacyList']['allowedUsers'], // Adjusted to match nested structure
      forbiddenUsers: json['privacyList']['forbiddenUsers'], // Adjusted to match nested structure
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      country: json['country'],
      city: json['city'],
      job: json['job'],
      birthDay: json['birthDay'],
      language: json['language'],
      showPosts: json['showPosts'],
      showStories: json['showStories'],
      showReels: json['showReels'],
      writeComments: json['writeComments'],
      receiveCalls: json['receiveCalls'],
      receiveSocialMessages: json['receiveSocialMessages'],
      receiveGreetMessages: json['receiveGreetMessages'],
      receiveAnonymousMessages: json['receiveAnonymousMessages'],
      lastSeen: json['lastSeen'], // Added mapping for lastSeen
      randomAppearance: json['randomAppearance'], // Added mapping for randomAppearance
    );
  }
}
