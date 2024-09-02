import 'package:equatable/equatable.dart';

class ClubVoiceRoomEntity extends Equatable {
  final String id;
  final String hostname;
  final String subject;
  //will be List<Users>
  final List<ClubUserEntity>? users;
  const ClubVoiceRoomEntity({
    required this.id,
    required this.hostname,
    required this.subject,
    required this.users,
  });

  @override
  List<Object> get props => [
        id,
        hostname,
        subject,
        users ?? [],
      ];
}

class ClubUserEntity {
  final String firstName;
  final String lastName;
  final String id;
  final String? profilePicture;

  ClubUserEntity({
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.id,
  });
}
