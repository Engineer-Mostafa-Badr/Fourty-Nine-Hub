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
//TODO
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
      return 'friends/followers';
    case PrivacyStatus.exceptFrom:
      return 'friends-except';
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
