import '../../domain/entities/connection_privacy_entity.dart';

class ConnectionPrivacyModel extends ConnectionPrivacyEntity {
  ConnectionPrivacyModel({
    super.userId,
    super.friendRequests,
    super.followerRequests,
    super.friendsList,
    super.followerList,
    super.randomAppearance,
    super.allowedUsers,
  });

  factory ConnectionPrivacyModel.fromJson(Map<String, dynamic> json) {
    return ConnectionPrivacyModel(
      userId: json['userId'],
      friendRequests: json['friendRequests'],
      followerRequests: json['followerRequests'],
      friendsList: json['friendsList'],
      followerList: json['followerList'],
      allowedUsers: json['allowedUsers'],
      randomAppearance: json['randomAppearance'],
    );
  }


}