class PrivacyEntity {
  final String id;
  final String userId;
  final String privacyCountry;
  final String privacyPhone;
  final String privacyEmail;
  final String privacyBirthDay;
  final String privacySocialStatus;
  final String privacyJob;
  final String privacyCity;
  final String privacyIsMale;
  final String privacyLanguage;
  final String privacyReceiveMessages;
  final String privacyLastSeen;
  final String privacyFriendList;
  final String privacyFollowerList;
  final String privacyActivity;
  final String privacyCall;
  final bool privacyFriendRequest;
  final bool privacyFollowRequest;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> usersStoryPrivacy;
  final String privacyStories;

  PrivacyEntity(
      {required this.id,
      required this.userId,
      required this.privacyCountry,
      required this.privacyPhone,
      required this.privacyEmail,
      required this.privacyBirthDay,
      required this.privacySocialStatus,
      required this.privacyJob,
      required this.privacyCity,
      required this.privacyIsMale,
      required this.privacyLanguage,
      required this.privacyReceiveMessages,
      required this.privacyLastSeen,
      required this.privacyFriendList,
      required this.privacyFollowerList,
      required this.privacyActivity,
      required this.privacyCall,
      required this.privacyFriendRequest,
      required this.privacyFollowRequest,
      required this.createdAt,
      required this.updatedAt,
      required this.usersStoryPrivacy,
      required this.privacyStories});
}
