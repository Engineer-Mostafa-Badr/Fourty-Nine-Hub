class PrivacyEntity {
  final String? id;
  final String? userId;
  final String? privacyCountry;
  final String? privacyPhone;
  final String? privacyEmail;
  final String? privacyBirthDay;
  final String? privacySocialStatus;
  final String? privacyJob;
  final String? privacyCity;
  final String? privacyIsMale;
  final String? privacyLanguage;
  final String? privacyReceiveMessages;
  final String? privacyLastSeen;
  final String? privacyFriendList;
  final String? privacyFollowerList;
  final String? privacyActivity;
  final String? privacyCall;
  final bool? privacyFriendRequest;
  final bool? privacyFollowRequest;
  final String? createdAt;
  final String? updatedAt;
  final List<dynamic>? usersStoryPrivacy;
  final String? privacyStories;

  PrivacyEntity(
      { this.id,
       this.userId,
       this.privacyCountry,
       this.privacyPhone,
       this.privacyEmail,
       this.privacyBirthDay,
       this.privacySocialStatus,
       this.privacyJob,
       this.privacyCity,
       this.privacyIsMale,
       this.privacyLanguage,
       this.privacyReceiveMessages,
       this.privacyLastSeen,
       this.privacyFriendList,
       this.privacyFollowerList,
       this.privacyActivity,
       this.privacyCall,
       this.privacyFriendRequest,
       this.privacyFollowRequest,
       this.createdAt,
       this.updatedAt,
       this.usersStoryPrivacy,
       this.privacyStories});
}
