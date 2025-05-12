import 'package:equatable/equatable.dart';

class LastLikeEntity extends Equatable {
  final String userId;
  final String username;
  final String firstName;
  final String lastName;
  final String profilePic;

  const LastLikeEntity(
      {required this.userId,
      required this.username,
      required this.profilePic,
      required this.firstName,
      required this.lastName});

  @override
  List<Object?> get props => [
        userId,
        username,
        profilePic,
        firstName,
        lastName,
      ];
}
