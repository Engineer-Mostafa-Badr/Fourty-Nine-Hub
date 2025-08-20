import '../../domain/entities/following_entity.dart';

class FollowingModel extends FollowingEntity {
  FollowingModel({
    required super.id,
    required super.followerId,
    required super.firstName,
    required super.lastname,
    required super.email,
    required super.image,
    required super.followingId,
  });

  factory FollowingModel.fromJson(Map<String, dynamic> json) {
    return FollowingModel(
      id: json['_id'] ?? '',
      followerId: json['followerId'] ?? '',
      firstName: json['followingId']?['firstName'] ?? '',
      lastname: json['followingId']?['lastName'] ?? '',
      email: json['followingId']?['email'] ?? '',
      image: json['followingId']?['image'] ?? '',
      followingId: json['followingId']?['_id'] ?? '',
    );
  }
}
