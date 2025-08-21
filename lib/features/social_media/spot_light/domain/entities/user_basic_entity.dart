import 'package:equatable/equatable.dart';

class UserBasicEntity extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String? userProfileUrl;

  const UserBasicEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.userProfileUrl,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props =>
      [userId, firstName, lastName, username, userProfileUrl];
}
