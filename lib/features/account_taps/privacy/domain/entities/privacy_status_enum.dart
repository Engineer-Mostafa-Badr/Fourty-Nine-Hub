enum PrivacyStatus {
  onlyMe,
  public,
  friends,
  followers,
  friendsAndFollowers,
}


enum MaritalStatus {
  single,
  married,
  divorced,
  widowed,
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
      return 'friends/followers';
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
