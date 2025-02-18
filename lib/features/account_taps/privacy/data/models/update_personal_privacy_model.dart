import '../../domain/entities/update_personal_privacy_entity.dart';

import '../../domain/entities/update_personal_privacy_entity.dart';

class UpdatePersonalPrivacyDataModel extends UpdatePersonalPrivacyDataEntity {
  UpdatePersonalPrivacyDataModel({
    String? id,
    String? userId,
    String? profile,
    String? posts,
    String? stories,
    String? reels,
    String? chat,
    String? friendRequests,
    String? followerRequests,
    String? friendsList,
    String? followerList,
    Map<String, dynamic>? allowedUsers,
    Map<String, dynamic>? forbiddenUsers, // New field for forbiddenUsers
    String? createdAt,
    String? updatedAt,
    int? v,
    String? email,
    String? phoneNumber,
    String? gender,
    String? country,
    String? city,
    String? job,
    String? birthDay,
    String? language,
    String? showPosts,
    String? showStories,
    String? showReels,
    String? writeComments,
    String? receiveCalls,
    String? receiveSocialMessages,
    String? receiveGreetMessages,
    String? receiveAnonymousMessages,
    String? lastSeen, // New field for lastSeen
    String? randomAppearance, // New field for randomAppearance
  }) : super(
    id: id,
    userId: userId,
    profile: profile,
    posts: posts,
    stories: stories,
    reels: reels,
    chat: chat,
    friendRequests: friendRequests,
    followerRequests: followerRequests,
    friendsList: friendsList,
    followerList: followerList,
    allowedUsers: allowedUsers,
    forbiddenUsers: forbiddenUsers, // Added forbiddenUsers
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v,
    email: email,
    phoneNumber: phoneNumber,
    gender: gender,
    country: country,
    city: city,
    job: job,
    birthDay: birthDay,
    language: language,
    showPosts: showPosts,
    showStories: showStories,
    showReels: showReels,
    writeComments: writeComments,
    receiveCalls: receiveCalls,
    receiveSocialMessages: receiveSocialMessages,
    receiveGreetMessages: receiveGreetMessages,
    receiveAnonymousMessages: receiveAnonymousMessages,
    lastSeen: lastSeen, // Added lastSeen
    randomAppearance: randomAppearance, // Added randomAppearance
  );

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
