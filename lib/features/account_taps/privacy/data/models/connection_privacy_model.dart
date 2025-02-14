import '../../domain/entities/connection_privacy_entity.dart';

class ConnectionPrivacyModel extends ConnectionPrivacyEntity {
  ConnectionPrivacyModel({
    String? userId,
    String? friendRequests,
    String? followerRequests,
    String? friendsList,
    String? followerList,
    Map<String, dynamic>? allowedUsers,
  }) : super(
    userId: userId,
    friendRequests: friendRequests,
    followerRequests: followerRequests,
    friendsList: friendsList,
    followerList: followerList,
    allowedUsers: allowedUsers,
  );

  factory ConnectionPrivacyModel.fromJson(Map<String, dynamic> json) {
    return ConnectionPrivacyModel(
      userId: json['userId'],
      friendRequests: json['friendRequests'],
      followerRequests: json['followerRequests'],
      friendsList: json['friendsList'],
      followerList: json['followerList'],
      allowedUsers: json['allowedUsers'],
    );
  }


}