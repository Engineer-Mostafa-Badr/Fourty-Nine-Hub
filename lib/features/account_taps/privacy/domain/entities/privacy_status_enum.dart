enum PrivacyStatus {
  onlyMe,
  public,
  friends,
  followers,
  friendsAndFollowers,
  exceptFrom,
  onlyWith,
  contacts,
}


enum MaritalStatus {
  single,
  married,
  divorced,
  widowed,
}
enum PrivacyFeature {
  email,
  phoneNumber,
  gender,
  country,
  city,
  job,
  birthDay,
  language,
  receiveCalls,
  receiveSocialMessages,
  receiveGreetMessages,
  receiveAnonymousMessages,
  lastSeen,
  friendRequests,
  followerRequests,
  friendsList,
  followerList,
  randomAppearance,
  exceptFrom,
  showPosts,
  showStories,
  showReels,
  writeComments,

}

String mapPrivacyFeatureToString(PrivacyFeature feature) {
  switch (feature) {
    case PrivacyFeature.email:
      return 'email';
    case PrivacyFeature.phoneNumber:
      return 'phoneNumber';
    case PrivacyFeature.gender:
      return 'gender';
    case PrivacyFeature.country:
      return 'country';
    case PrivacyFeature.city:
      return 'city';
    case PrivacyFeature.job:
      return 'job';
    case PrivacyFeature.birthDay:
      return 'birthDay';
    case PrivacyFeature.language:
      return 'language';
    case PrivacyFeature.receiveCalls:
      return 'receiveCalls';
    case PrivacyFeature.receiveSocialMessages:
      return 'receiveSocialMessages';
    case PrivacyFeature.receiveGreetMessages:
      return 'receiveGreetMessages';
    case PrivacyFeature.receiveAnonymousMessages:
      return 'receiveAnonymousMessages';
    case PrivacyFeature.lastSeen:
      return 'lastSeen';
    case PrivacyFeature.friendRequests:
      return 'friendRequests';
    case PrivacyFeature.followerRequests:
      return 'followerRequests';
    case PrivacyFeature.friendsList:
      return 'friendsList';
    case PrivacyFeature.followerList:
      return 'followerList';
    case PrivacyFeature.randomAppearance:
      return 'randomAppearance';
    case PrivacyFeature.exceptFrom:
      return 'exceptFrom';
    case PrivacyFeature.showPosts:
      return 'showPosts';
    case PrivacyFeature.showStories:
      return 'showStories';
    case PrivacyFeature.showReels:
      return 'showReels';
    case PrivacyFeature.writeComments:
      return 'writeComments';
    default:
      return '';
  }
}
String mapPrivacyStatusToString(PrivacyStatus status) {
  switch (status) {
    case PrivacyStatus.onlyMe:
      return 'only-me';
    case PrivacyStatus.public:
      return 'public';
    case PrivacyStatus.friends:
      return 'friends';
    case PrivacyStatus.followers:
      return 'followers';
    case PrivacyStatus.friendsAndFollowers:
      return 'friends-and-followers';
    case PrivacyStatus.contacts:
      return 'contacts';
    case PrivacyStatus.onlyWith:
      return 'only-me';
    case PrivacyStatus.exceptFrom:
      return 'only-me';
    default:
      return 'public';
  }
}
String mapPrivacyStatusToString1(PrivacyStatus status) {
  switch (status) {
    case PrivacyStatus.onlyMe:
      return 'only-me';
    case PrivacyStatus.public:
      return 'public';
    case PrivacyStatus.friends:
      return 'friends';
    case PrivacyStatus.followers:
      return 'followers';
    case PrivacyStatus.friendsAndFollowers:
      return 'friends-and-followers';
    case PrivacyStatus.exceptFrom:
      return 'except-from';
    case PrivacyStatus.onlyWith:
      return 'only-with';
    case PrivacyStatus.contacts:
      return 'contacts';
  }
}


String mapMaritalStatusToString(MaritalStatus status) {
  switch (status) {
    case MaritalStatus.single:
      return 'Single';
    case MaritalStatus.married:
      return 'Married';
    case MaritalStatus.divorced:
      return 'Divorced';
    case MaritalStatus.widowed:
      return 'Widowed';
  }
}
