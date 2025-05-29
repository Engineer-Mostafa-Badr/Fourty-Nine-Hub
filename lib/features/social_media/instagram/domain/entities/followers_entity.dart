import 'package:equatable/equatable.dart';

class FollowersEntity extends Equatable{
  // final String id;
  // final String followerId;
  final String firstName;
  final String lastname;
  final String username;
  // final String email;
  final String profilePictureUrl;
  // final String followingId;
  final String userId;

  const FollowersEntity({
    // required this.id,
    // required this.followerId,
    required this.firstName,
    required this.lastname,
    required this.username,
    // required this.email,
    required this.profilePictureUrl,
    // required this.followingId,
    required this.userId,
  });

  @override
  List<Object?> get props => [
    // id,
    // followerId,
    firstName,
    lastname,
    username,
    // email,
    profilePictureUrl,
    // followingId,
    userId,
  ];

}
