class ConnectionPrivacyEntity {
  final String? userId;
  final String? friendRequests;
  final String? followerRequests;
  final String? friendsList;
  final String? followerList;
  final String? randomAppearance;
  final Map<String, dynamic>? allowedUsers;

  ConnectionPrivacyEntity({
    this.userId,
    this.friendRequests,
    this.followerRequests,
    this.friendsList,
    this.followerList,
    this.randomAppearance,
    this.allowedUsers,
  });
}