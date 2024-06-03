import 'package:equatable/equatable.dart';

class BaseUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;

  String get fullName => '$firstName $lastName';

  const BaseUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        profilePicture,
      ];
}
